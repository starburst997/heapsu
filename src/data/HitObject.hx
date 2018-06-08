package data;

import objects.*;
import objects.curves.*;
import utils.*;

using FS;
using FSHeaps;

@:enum
abstract HitType(Int) from Int to Int {
    var Circle       = 1;
    var Slider       = 2;
    var NewCombo     = 4;
    var Spinner      = 8; 
}

@:enum
abstract Sound(Int) from Int to Int {
    var Normal       = 0;
    var Whistle      = 2;
    var Finish       = 4;
    var Clap         = 8; 
}

@:enum
abstract Slider(String) from String to String {
    var Catmull      = 'C';
    var Bezier       = 'B';
    var Linear       = 'L';
    var PerfectCurve = 'P'; 
}

class HitObject {
    
    public static inline var MAX_X = 512;
    public static inline var MAX_Y = 384;

    public static var stackOffset:Float = 0.0;

    // Dimension
    public static var containerHeight:Int;
    public static var xMultiplier:Float = 1.0;
    public static var yMultiplier:Float = 1.0;
    public static var xOffset:Int;
    public static var yOffset:Int;

    // Common
    public var x:Float = 0.0;
    public var y:Float = 0.0;
    public var time:Int;
    public var hitSound:Sound;
    public var type:HitType;

    public var additionIndex:Int;
    public var addition:Array<Int> = [];
    public var additionCustomSampleIndex:Int;
    public var additionHitSoundVolume:Int;
    public var additionHitSound:Sound;

    public var endTime:Int;

    public var stack:Int;

    // Slider
    public var sliderType:Slider;
    public var sliderX:Array<Float> = [];
    public var sliderY:Array<Float> = [];
    public var repeat:Int;
    public var pixelLength:Float;
    public var edgeHitSound:Array<Sound> = [];
    public var edgeAddition:Array<Array<Int>> = [];

    // Misc
    public var comboIndex:Int;
    public var comboNumber:Int;

    public static inline function create() {
        return new HitObject();
    }

    public static function init(width:Int, height:Int) {
        containerHeight = height;
        var swidth:Float = width;
        var sheight:Float = height;
        if (swidth * 3 > sheight * 4)
            swidth = sheight * 4 / 3;
        else
            sheight = swidth * 3 / 4;
        xMultiplier = swidth / 640;
        yMultiplier = sheight / 480;
        xOffset = Std.int((width - MAX_X * xMultiplier) / 2);
        yOffset = Std.int((height - MAX_Y * yMultiplier) / 2);
    }

    public function new() { }

    public inline function getComboSkip():Int {
        return type >> NewCombo;
    }

    public inline function isCircle():Bool {
        return (type & Circle) > 0;
    }

    public inline function isSlider():Bool {
        return (type & Slider) > 0;
    }

    public inline function isSpinner():Bool {
        return (type & Spinner) > 0;
    }

    public inline function isNewCombo():Bool {
        return (type & NewCombo) > 0;
    }

    public function getScaledX() { 
        return (x - stack * stackOffset) * xMultiplier + xOffset;
    }

    public function getScaledY() {
        return if (GameMod.hardRock.isActive())
            containerHeight - ((y + stack * stackOffset) * yMultiplier + yOffset);
        else
            (y - stack * stackOffset) * yMultiplier + yOffset;
    }

    public function getScaledSliderX():Array<Float> {
        return sliderX.mapa(x -> (x - stack * stackOffset) * xMultiplier + xOffset);
    }

    public function getScaledSliderY():Array<Float> {
        return if (GameMod.hardRock.isActive())
            sliderY.mapa(y -> containerHeight - ((y + stack * stackOffset) * yMultiplier + yOffset));
        else
            sliderY.mapa(y -> (y - stack * stackOffset) * yMultiplier + yOffset);
    }

    public function getSliderTime(sliderMultiplier:Float, beatLength:Float) {
        return beatLength * (pixelLength / sliderMultiplier) / 100;
    }

    public function getEdgeHitSoundType(index:Int):Sound {
        return if (index < edgeHitSound.length)
            edgeHitSound[index];
        else
            hitSound;
    }

    public function getSampleSet(index:Int):Int {
        if (index < edgeAddition.length)
            return edgeAddition[index][0];
        if (addition.length > 0)
            return addition[0];
        return 0;
    }

    public function getAdditionSampleSet(index:Int):Int {
        if (index < edgeAddition.length)
            return edgeAddition[index][1];
        if (addition.length > 1)
            return addition[1];
        return 0;
    }

    public function getSliderCurve(scaled:Bool):Curve {
        return switch(sliderType) {
            case PerfectCurve if (sliderX.length == 2) : 
                var nora = new h3d.Vector(sliderX[0] - x, sliderY[0] - y).norm();
                var norb = new h3d.Vector(sliderX[0] - sliderX[1], sliderY[0] - sliderY[1]).norm();
                if (Math.abs(norb.x * nora.y - norb.y * nora.x) < 0.00001)
                    new LinearBezier(this, false, scaled);  // vectors parallel, use linear bezier instead
                else
                    //new CircumscribedCircle(this, scaled);
                    new LinearBezier(this, false, scaled);
            //case Catmull : 
            //    new CatmullCurve(this, scaled);
            default : 
                new LinearBezier(this, sliderType == Linear, scaled);
        }
    }

    public function parseValues(values:Array<String>) {
        Assert.that(values.length >= 5);

        // Common field
        x = values[0].parseFloat();
        y = values[1].parseFloat();
        time = values[2].parseInt();
        type = values[3].parseInt();
        hitSound = values[4].parseInt();

        // Type-specific fields
        var additionIndex;
        if (isCircle())
            additionIndex = 5;
        else if (isSlider()) {
            Assert.that(values.length >= 8);

            additionIndex = 10;

            // Slider curve type and coordinates
            var sliderTokens = values[5].split('|');
            sliderType = sliderTokens[0].charAt(0);
            sliderX = [];
            sliderY = [];
            sliderTokens.iteri((i, slider) -> if (i > 0) {
                var sliderXY = slider.split(':');
                Assert.that(sliderXY.length >= 2);

                sliderX.push(Std.parseInt(sliderXY[0]));
                sliderY.push(Std.parseInt(sliderXY[1]));
            });
            
            repeat = Std.parseInt(values[6]);
            pixelLength = Std.parseFloat(values[7]);
            if (values.length > 8) {
                edgeHitSound = values[8].split('|').mapa(value -> Std.parseInt(value));
            }
            if (values.length > 9) {
                edgeAddition = values[9]
                    .split('|')
                    .mapa(value -> value
                        .split(':')
                        .mapa(t -> Std.parseInt(t)));
            }
        } else { //if (isSpinner()) {
            Assert.that(values.length >= 6);
            additionIndex = 6;

            // some 'endTime' fields contain a ':' character (?)
            var index = values[5].indexOf(':');
            if (index != -1)
                values[5] = values[5].substring(0, index);
            endTime = Std.parseInt(values[5]);
        }

        // Addition
        if (values.length > additionIndex) {
            var additionTokens = values[additionIndex].split(':');
            if (additionTokens.length > 1)
                addition = [Std.parseInt(additionTokens[0]), Std.parseInt(additionTokens[1])];
            if (additionTokens.length > 2)
                additionCustomSampleIndex = Std.parseInt(additionTokens[2]);
            if (additionTokens.length > 3)
                additionHitSoundVolume = Std.parseInt(additionTokens[3]);
            if (additionTokens.length > 4)
                additionHitSound = Std.parseInt(additionTokens[4]);
        }

        return this;
    }

    public function toString():String {
        var str = '';

        // common fields
        str = '${x.toString()},${y.toString()},$time,$type,$hitSound,';

        // type-specific fields
        if (isCircle()) {
            // Nothing
        } else if (isSlider()) {
            str += '${sliderType}|';

            for (i in 0...sliderX.length)
                str += '${sliderX[i]}:${sliderY[i]}${i == sliderX.length - 1 ? ',' : '|'}';

            str += '$repeat,$pixelLength,';
            
            for (i in 0...edgeHitSound.length)
                str += '${edgeHitSound[i]}${i == edgeHitSound.length - 1 ? ',' : '|'}';

            for (i in 0...edgeAddition.length) 
                str += '${edgeAddition[i][0]}:${edgeAddition[i][1]}${i == edgeHitSound.length - 1 ? ',' : '|'}';
        } else if (isSpinner()) {
            str += '$endTime,';
        }

        // addition
        return if (addition.length > 0) {
            for (i in 0...addition.length)
                str += '${addition[i]}:';
            
            str += '$additionCustomSampleIndex:$additionHitSoundVolume:$additionHitSound';
        } else
            str.substr(-1);
    }
}
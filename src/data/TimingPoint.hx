package data;

using FS;
using StringTools;

class TimingPoint {
    
    public static inline function create() {
        return new TimingPoint();
    }

    public var time:Int;
    public var beatLength:Float = 0.0;
    public var velocity:Int;
    public var meter:Int = 4;
    public var sampleType:Int = 1;
    public var sampleTypeCustom:Int;
    public var sampleVolume:Float;
    public var inherited:Bool;
    public var kiai:Bool;

    public function new() {}

    public function parseString(str:String) {
        var values = str.split(',');
        Assert.that(values.length >= 7);

        time = Std.int(Std.parseFloat(values[0]));
        meter = Std.parseInt(values[2]);
        sampleType = Std.parseInt(values[3]);
        sampleTypeCustom = Std.parseInt(values[4]);
        sampleVolume = Std.parseInt(values[5]) / 100;
        //inherited = values[6] == '1';

        var beatLength = Std.parseFloat(values[1]);
        if (beatLength > 0)
            this.beatLength = beatLength ;
        else {
            velocity = Std.int(beatLength);
            inherited = true;
        }

        return this;
    }

    public inline function getSliderMultiplier() {
        return -velocity.clamp(10, 1000) / 100 * -10;
    }

    public function toString() {
        return if (inherited) {
            '$time,$velocity,$meter,${sampleType},${sampleTypeCustom},${Std.int(sampleVolume * 100)},1,${kiai ? 1: 0}';
        } else {
            '$time,$beatLength,$meter,$sampleType,$sampleTypeCustom,${Std.int(sampleVolume * 100)},0,${kiai ? 1: 0}';
        }
    }
}
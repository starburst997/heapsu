package objects;

import data.*;
import scenes.*;
import objects.curves.*;

class Slider extends GameObject {
    
    var color:Int;
    var comboEnd:Bool;

    var curve:Curve;
    
    public function new(hitObject:HitObject, game:Game, color:Int, comboEnd:Bool) {
        super(hitObject, game);

        this.color = color;
        this.comboEnd = comboEnd;
    }

    public override function draw(trackPosition:Float) {

        var g = new h2d.Graphics(sprite);
        //g.addVertex()

    }

    public override function update(delta:Float, mouseX:Float, mouseY:Float, keyPressed:Bool, trackPosition:Float):Bool {

        draw(trackPosition);

        return false;
    }
}
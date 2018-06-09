package objects;

import data.*;
import scenes.*;

class GameObject {
    
    public var sprite:h2d.Sprite;

    var hitObject:HitObject;
    var game:Game;

    public function new(hitObject:HitObject, game:Game) {
        sprite = new h2d.Sprite();

        this.game = game;
        this.hitObject = hitObject;
    }

    public function draw(trackPosition:Float) {
        Assert.error('Override draw()');
    }

    public function update(delta:Float, mouseX:Float, mouseY:Float, keyPressed:Bool, trackPosition:Float):Bool {
        Assert.error('Override update()');
        return false;
    }

    public function mousePressed(x:Float, y:Float, trackPosition:Float):Bool {
        Assert.error('Override mousePressed()');
        return false;
    }

    public function getPointAt(trackPosition:Int):Point {
        Assert.error('Override getPointAt()');
        return { x: 0, y: 0 };
    }

    public function getEndTime():Int {
        Assert.error('Override getEndTime()');
        return 0;
    }

    public function updatePosition() {
        Assert.error('Override updatePosition()');
    }

    public function reset() {
        sprite.remove();
    }
}
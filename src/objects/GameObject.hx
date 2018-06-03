package objects;

import data.*;
import scenes.*;

using FS;

class GameObject {
    
    public var sprite:h2d.Sprite;

    var hitObject:HitObject;
    var game:Game;

    var bmp:h2d.Bitmap;

    public function new(hitObject:HitObject, game:Game) {
        sprite = new h2d.Sprite();

        this.game = game;
        this.hitObject = hitObject;

        /*var tile = h2d.Tile.fromColor(0xFF0000, 100, 100);
		bmp = new h2d.Bitmap(tile, sprite);
		bmp.x = -50;
		bmp.y = -50;*/
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
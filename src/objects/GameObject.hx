package objects;

import data.*;
import scenes.*;

class GameObject extends h2d.Sprite {
    
    var hitObject:HitObject;
    var game:Game;

    var bmp:h2d.Bitmap;

    public function new(hitObject:HitObject, game:Game) {
        super();

        this.game = game;
        this.hitObject = hitObject;

        var tile = h2d.Tile.fromColor(0xFF0000, 100, 100);
		bmp = new h2d.Bitmap(tile, this);
		bmp.x = -50;
		bmp.y = -50;
    }
}
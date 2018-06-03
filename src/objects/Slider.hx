package objects;

import data.*;
import scenes.*;

class Slider extends GameObject {
    
    var color:Int;
    var comboEnd:Bool;
    
    public function new(hitObject:HitObject, game:Game, color:Int, comboEnd:Bool) {
        super(hitObject, game);

        this.color = color;
        this.comboEnd = comboEnd;
    }

    
}
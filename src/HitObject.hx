using StringTools;
using FS;

@:enum
abstract HitType(Int) from Int to Int {
    var Circle  = 0;
    var Slider  = 1;
    var Spinner = 2; 
}

class HitObject {
    
    var type:HitType;

    public static inline function create() {
        return new HitObject();
    }

    public function new() {
        
    }

    public function setComboNumber(num:Int) {
        // TODO: !!!
    }

    public function setComboIndex(index:Int) {
        // TODO: !!!
    }

    public function getComboSkip():Int {
        // TODO: !!!
        return 0;
    }

    public function isSpinner():Bool {
        return type == Spinner;
    }

    public function isNewCombo():Bool {
        // TODO: !!!
        return false;
    }

    public function parseValues(values:Array<String>) {
        // TODO: !!!
        return this;
    }
}
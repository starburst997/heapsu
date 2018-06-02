using StringTools;
using FS;

class TimingPoint {
    
    public static inline function create() {
        return new TimingPoint();
    }

    public function new() {
        
    }

    public function parseString(str:String) {
        return this;
    }

    public function getBeatLength():Float {
        return 1.0;
    }

    public function isInherited() {
        // TODO: !!!
        return false;
    }
}
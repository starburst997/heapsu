package skins;

@:enum
abstract SliderStyle(Int) {
    var PeppySlider   = 1;
    var MMSlider      = 2;
    var ToonSlider    = 3; // not implemented
    var OpenGLSlider  = 4; // not implemented
}

class Skin {
    public var sliderStyle = PeppySlider;

    public static inline function create() {
        return new Skin();
    }

    public function new() {

    }
}
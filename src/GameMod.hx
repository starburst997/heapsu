using FS;

class Mod {
    public static function create() {
        return new Mod();
    }

    public function new() {

    }

    public function isActive() {
        // TODO: !!!
        return false;
    }
}

class GameMod {
    public static var hardRock = Mod.create();
}
import haxe.ds.Option;

/**
 * A collection of usefull tools
 */
class FS {

    /* Object */

    public static inline function toOption<T>(object:T):Option<T> {
        return object == null ? None : Some(object);
    }

    public static inline function getOr<T>(object:T, f:Void->T):T {
        return object == null ? f() : object;
    }

    @:generic
    public static inline function ifExists<T>(object:T, f:T->Void) {
        if (object != null) f(object);
    }

    public static inline function some<T>(object:T):Option<T> {
        return Some(object);
    }

    public static function iter<T>(it:Iterable<T>, f:T->Void) {
		for (x in it) f(x);
	}

    /* Math */

    public static inline function toInt(f:Float):Int {
        return Std.int(f);
    }

    public static inline function parseInt(str:String):Int {
        return Std.parseInt(str);
    }

    public static inline function parseFloat(str:String):Float {
        return Std.parseFloat(str);
    }

    public static function toString(value:Float, p:Int = 5){
        var t = Std.int(Math.pow(10, p));
        return Std.string(Std.int(value * t) / t);
    }
}

class FSArray {

    @:generic
    public static inline function getOr<T>(array:Array<T>, index:Int, f:Void->T):T {
        return index < array.length && index >= 0 ? array[index] : f();
    }

    @:generic
    public static inline function iter<T>(array:Array<T>, f:T->Void) {
        for (item in array) f(item);
        return array;
    }

    @:generic
    public static inline function iteri<T>(array:Array<T>, f:Int->T->Void) {
        var i = 0;
        for (item in array) f(i++, item);
        return array;
    }

    @:generic
    public static inline function mapa<T,K>(array1:Array<T>, f:T->K):Array<K> {
        var array2 = [];
        for (item in array1) array2.push(f(item));
        return array2;
    }

    @:generic
    public static inline function pushAll<T>(array1:Array<T>, array2:Array<T>) {
        for (item in array2) array1.push(item);
        return array1;
    }
}

class FSOption {
    
    public static inline function getOr<T>(object:Option<T>, f:Void->T):T {
        return switch(object) {
            case Some(object) : object;
            case None : f();
        }
    }

    public static inline function isNone<T>(object:Option<T>):Bool {
        return switch(object) {
            case Some(object) : false;
            case None : true;
        }
    }
}
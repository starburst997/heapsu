package tools;

typedef Point = {
    x:Int,
    y:Int
}

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

    public static inline function int(f:Float):Int {
        return Std.int(f);
    }

    public static inline function parseInt(str:String):Int {
        return Std.parseInt(str);
    }

    public static inline function parseFloat(str:String):Float {
        return Std.parseFloat(str);
    }

    public static inline function toString(value:Float, p:Int = 5){
        var t = Std.int(Math.pow(10, p));
        return Std.string(Std.int(value * t) / t);
    }

    public static inline function clamp(val:Int, low:Int, high:Int) {
        return if (val < low) low;
        else if (val > high) high;
        else val;
    }
}

abstract Integer(Int) from Int to Int {
    @:from
    static public inline function fromFloat(f:Float):Integer {
        return Std.int(f);
    }

    @:to
    static public inline function toFloat(i:Int):Float {
        return i;
    }
}

abstract Byte(Int) from Int to Int {
    @:from
    static public inline function fromFloat(f:Float):Byte {
        return Std.int(f * 255);
    }

    @:to
    static public inline function toFloat(i:Int):Float {
        return i / 255.0;
    }
}

abstract Number(Float) from Float to Float {
    @:from
    static public inline function fromInt(i:Int):Number {
        return i * 1.0;
    }

    @:to
    static public inline function toInt(f:Float):Int {
        return Std.int(f);
    }
}

class FSNumber {
    public static inline function clamp(val:Float, low:Float = 0.0, high:Float = 1.0) {
        return if (val < low) low;
        else if (val > high) high;
        else val;
    }

    public static inline function iter(val:Int, f:Int->Void) {
        for (i in 0...val) f(i);
        return val;
    }

    public static inline function iterAdd(val:Int, f:Int->Integer) {
        var total = 0;
        for (i in 0...val) total += f(i);
        return total;
    }

    public static inline function lerp(a:Float, b:Float, t:Float) {
        return a * (1 - t) + b * t;
    }

    public static inline function equals(a:Float, b:Float, precision:Float = 0.0001) {
        return Math.abs(a - b) < precision;
    }
}

class FSArray {

    @:generic
    public static inline function getOr<T>(array:Array<T>, index:Int, f:Void->T):T {
        return if (index < array.length && index >= 0)
            array[index];
        else
            array[index] = f();
    }

    @:generic
    public static inline function filter<T>(array:Array<T>, f:T->Bool) {
        var filtered = [];
        for (item in array) if (f(item)) filtered.push(item);
        return filtered;
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

    public static inline function ifSome<T>(object:Option<T>, f:T->Void):Option<T> {
        switch(object) {
            case Some(object) : f(object);
            case None :
        }
        return object;
    }

    public static inline function ifNone<T>(object:Option<T>, f:Void->Void):Option<T> {
        switch(object) {
            case Some(object) : 
            case None : f();
        }
        return object;
    }
}
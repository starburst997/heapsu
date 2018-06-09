package tools;

import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.Tools;

typedef Assert = tools.FSAssert;

class FSAssert {
    public static inline function warn(str:String) {
        trace('Warning: $str');
    }

    public static inline function error(str:String) {
        #if assert
        throw str;
        #else
        trace('Throw: $str');
        #end
    }

    public static macro function that(e:Expr) {
        #if !display
        var s = e.toString();
        var p = e.pos;
        var el = [];
        var descs = [];
        function add(e:Expr, s:String) {
            var v = "_tmp" + el.length;
            el.push(macro var $v = $e);
            descs.push(s);
            return v;
        }
        function map(e:Expr) {
            return switch (e.expr) {
                case EConst((CInt(_) | CFloat(_) | CString(_) | CRegexp(_) | CIdent("true" | "false" | "null"))):
                    e;
                case _:
                    var s = e.toString();
                    e = e.map(map);
                    macro $i {add(e, s)};
            }
        }
        var e = map(e);
        var a = [for (i in 0...el.length) macro {expr: $v {descs[i]}, value: $i {"_tmp" + i}}];
    
        #if assert
        el.push(macro if (!$e) @:pos(p) throw new tools.FSAssert.AssertionFailure($v {s}, $a {a}));
        #else
        el.push(macro if (!$e) @:pos(p) trace(new tools.FSAssert.AssertionFailure($v{s}, $a{a})));
        #end

        return macro $b {el};
        #else
        return macro {};
        #end
    }
}

private typedef AssertionPart = {
    expr:String,
    value:Dynamic
}

class AssertionFailure {
    public var message(default, null):String;
    public var parts(default, null):Array<AssertionPart>;
    
    public function new(message:String, parts:Array<AssertionPart>) {
        this.message = message;
        this.parts = parts;
    }

    public function toString() {
        var buf = new StringBuf();
        buf.add("Assertion failure: " + message);
        for (part in parts) {
            buf.add("\n\t" + part.expr + ": " + part.value);
        }
        return buf.toString();
    }
}
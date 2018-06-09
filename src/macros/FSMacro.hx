package macros;

typedef Macro = macros.FSMacro;

/**
 * A collection of usefull macros
 */
class FSMacro {

    public static macro function fromColor(?r:Int, ?g:Int, ?b:Int, ?rf:Float, ?gf:Float, ?bf:Float, a:Float = 1.0):haxe.macro.Expr.ExprOf<Int> {
        #if !display
        if (r == null) r = Std.int(rf.clamp() * 255);
        if (g == null) g = Std.int(gf.clamp() * 255);
        if (b == null) b = Std.int(bf.clamp() * 255);
        return macro $v{((a.clamp() * 255 + 0.499).int() << 24) | (r << 16) | (g << 8) | b};
        #else
        return macro $v{0};
        #end
    }
}
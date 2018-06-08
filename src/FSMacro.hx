/**
 * A collection of usefull tools for heaps
 */
using FS;

class FSMacro {

    public static macro function fromColor(?r:Int, ?g:Int, ?b:Int, ?rf:Float, ?gf:Float, ?bf:Float, a:Float = 1.0):haxe.macro.Expr.ExprOf<Int> {
        #if !display
        if (r == null) r = Std.int(rf * 255);
        if (g == null) g = Std.int(gf * 255);
        if (b == null) b = Std.int(bf * 255);
        return macro $v{((a.clamp() * 255 + 0.499).int() << 24) | (r << 16) | (g << 8) | b};
        #else
        return macro $v{0};
        #end
    }
}
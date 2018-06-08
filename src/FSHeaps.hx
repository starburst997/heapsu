import haxe.ds.Option;

using FS;
using FSHeaps;

/**
 * A collection of usefull tools for heaps
 */
class FSHeaps {

    public static var tempVector:h3d.Vector = new h3d.Vector();

    /* H2D */

    public static inline function bitmap(image:hxd.res.Image, ?parent:h2d.Sprite):h2d.Bitmap {
        return new h2d.Bitmap(image.toTile(), parent);
    }

    public static inline function cover(bitmap:h2d.Bitmap, width:Int, height:Int, offsetX:Float = 0.0, offsetY:Float = 0.0, alpha:Float = 1.0, stretch:Bool = false, parallax:Float = 0.0):h2d.Bitmap {
        var bmpWidth = bitmap.tile.width;
        var bmpHeight = bitmap.tile.height;
        
        if ((bmpWidth > bmpHeight) && ((height / bmpHeight) * bmpWidth) >= width) {
            var scale = height / bmpHeight;
            bitmap.scale(scale);
            bitmap.setPos(-(bmpWidth * scale - width) / 2, 0);
        } else {
            var scale = width / bmpWidth;
            bitmap.scale(scale);
            bitmap.setPos(0, -(bmpHeight * scale - height) / 2);
        }

        bitmap.alpha = alpha;
        return bitmap;
    }

    public static inline function drawCentered(bitmap:h2d.Bitmap, x:Float, y:Float):h2d.Bitmap {
        var size = bitmap.getSize();
        bitmap.setPos(x - (size.width / 2), y - (size.height / 2));
        return bitmap;
    }

    public static inline function changeScale(bitmap:h2d.Bitmap, scale:Float) {
        bitmap.scale(scale);
        return bitmap;
    }

    public static inline function center(bitmap:h2d.Bitmap) {
        bitmap.setPos(bitmap.x - (bitmap.tile.width * bitmap.scaleX / 2), bitmap.y - (bitmap.tile.height * bitmap.scaleY / 2));
        return bitmap;
    }

    public static inline function setPosition(bitmap:h2d.Bitmap, x:Float, y:Float) {
        bitmap.setPos(x, y);
        return bitmap;
    }

    public static inline function setColor(bitmap:h2d.Bitmap, ?vec:h3d.Vector, ?color:Int) {
        bitmap.colorAdd = vec != null ? vec : h3d.Vector.fromColor(color);
        return bitmap;
    }

    /* Vector */

    public static inline function norm(vec:h3d.Vector):h3d.Vector {
        vec.normalize();
        return vec;
    }

    public static inline function cpy(vec:h3d.Vector):h3d.Vector {
        return vec.clone();
    }

    public static inline function len(vec:h3d.Vector):Float {
        return vec.length();
    }

    public static inline function tmp(vec:h3d.Vector):h3d.Vector {
        tempVector.load(vec);
        return tempVector;
    }

    public static inline function scale(vec:h3d.Vector, s:Float):h3d.Vector {
        vec.scale3(s);
        return vec;
    }

    public static inline function equals(a:h3d.Vector, b:h3d.Vector):Bool {
        return a.x.equals(b.x) && a.y.equals(b.y) && a.z.equals(b.z);
    }
}
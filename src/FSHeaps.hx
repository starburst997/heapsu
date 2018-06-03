import haxe.ds.Option;

using FSHeaps;

/**
 * A collection of usefull tools for heaps
 */
class FSHeaps {

    /* H2D */

    public static inline function bitmap(image:hxd.res.Image, ?parent:h2d.Sprite):h2d.Bitmap {
        return new h2d.Bitmap(image.toTile(), parent);
    }

    public static inline function cover(bitmap:h2d.Bitmap, width:Int, height:Int, offsetX:Float = 0.0, offsetY:Float = 0.0, alpha:Float = 1.0, stretch:Bool = false, parallax:Float = 0.0):h2d.Bitmap {
        var bmpWidth = bitmap.tile.width;
        var bmpHeight = bitmap.tile.height;
        
        if (bmpWidth > bmpHeight) {
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
}
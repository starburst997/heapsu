import haxe.ds.Option;

/**
 * A collection of usefull tools for heaps
 */
class FSHeaps {

    /* H2D */

    public static inline function bitmap(image:hxd.res.Image, ?parent:h2d.Sprite):h2d.Bitmap {
        return new h2d.Bitmap(image.toTile(), parent);
    }

    public static inline function cover(bitmap:h2d.Bitmap, width:Int, height:Int):h2d.Bitmap {
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

        return bitmap;
    }
}
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
        var swidth = width;
		var sheight = height;
		if (!stretch) {
			// fit image to screen
			if (bitmap.tile.width / bitmap.tile.height > width / height)  // x > y
				sheight = Std.int(width * bitmap.tile.height / bitmap.tile.width);
			else
				swidth = Std.int(height * bitmap.tile.width / bitmap.tile.height);
		} else {
			// fill screen while maintaining aspect ratio
			if (bitmap.tile.width / bitmap.tile.height > width / height)  // x > y
				swidth = Std.int(height * bitmap.tile.width / bitmap.tile.height);
			else
				sheight = Std.int(width * bitmap.tile.height / bitmap.tile.width);
		}
		if (parallax != 0.0) {
			swidth = Std.int(swidth * parallax);
			sheight = Std.int(sheight * parallax);
		}
		bitmap.scaleX = swidth / width;
        bitmap.scaleY = sheight / height;
		bitmap.alpha = alpha;
		if (parallax == 0.0 && offsetX == 0 && offsetY == 0)
			bitmap.drawCentered(width / 2, height / 2);
		else
			bitmap.drawCentered(width / 2 + offsetX, height / 2 + offsetY);
        return bitmap;
    }

    public static inline function drawCentered(bitmap:h2d.Bitmap, x:Float, y:Float):h2d.Bitmap {
        var size = bitmap.getSize();
        bitmap.setPos(x - (size.width / 2), y - (size.height / 2));
        return bitmap;
    }

    public static inline function center(bitmap:h2d.Bitmap) {
        var size = bitmap.getSize();
        bitmap.setPos(bitmap.x - (size.width / 2), bitmap.y - (size.height / 2));
        return bitmap;
    }
}
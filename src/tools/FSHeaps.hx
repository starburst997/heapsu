package tools;

/**
 * A collection of usefull tools for heaps, 
 * mostly adding a functional feel to it
 */
class FSHeaps {

    public static var tempVector:h3d.Vector = new h3d.Vector();

    /* H2D */

    public static inline function bitmap(image:hxd.res.Image, ?parent:h2d.Sprite):h2d.Bitmap {
        return new h2d.Bitmap(image.toTile(), parent);
    }

    public static inline function text(font:h2d.Font, ?parent:h2d.Sprite):h2d.Text {
        return new h2d.Text(font, parent);
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

class FSHeapsSprite {

    @:generic
    public static inline function setPosition<T:h2d.Sprite>(sprite:T, ?x:Float, ?y:Float):T {
        sprite.setPos(x == null ? sprite.x : x, y == null ? sprite.y : y);
        return sprite;
    }

    @:generic
    public static inline function setX<T:h2d.Sprite>(sprite:T, x:Float):T {
        sprite.setPos(x, sprite.y);
        return sprite;
    }

    @:generic
    public static inline function setY<T:h2d.Sprite>(sprite:T, y:Float):T {
        sprite.setPos(sprite.x, y);
        return sprite;
    }
}

class FSHeapsText {

    public static inline function setColor(text:h2d.Text, color:Int):h2d.Text {
        text.textColor = color;
        return text;
    }

    public static inline function setText(text:h2d.Text, str:String):h2d.Text {
        text.text = str;
        return text;
    }

    public static inline function setAlign(text:h2d.Text, align:h2d.Text.Align):h2d.Text {
        text.textAlign = align;
        return text;
    }
}

class FSHeapsTile {
    
    public static inline function bitmap(tile:h2d.Tile, ?parent:h2d.Sprite):h2d.Bitmap {
        return new h2d.Bitmap(tile, parent);
    }
}
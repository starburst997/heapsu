package objects;

import haxe.ds.Option;

import data.*;
import utils.*;
import scenes.*;
import scenes.Game;

using FS;
using FSHeaps;

class Circle extends GameObject {
    
    private static var diameter:Float = 50.0;

    public static function init(circleDiameter:Float) {
        //diameter = circleDiameter * HitObject.getXMultiplier();
    }

    var color:Int;
    var comboEnd:Bool;

    var hitCircle:Option<h2d.Bitmap> = None;

    public function new(hitObject:HitObject, game:Game, color:Int, comboEnd:Bool) {
        super(hitObject, game);

        this.color = color;
        this.comboEnd = comboEnd;
    }

    public override function draw(trackPosition:Float) {
        var timeDiff = hitObject.time - trackPosition;
		var approachTime = game.approachTime;
		var fadeInTime = game.approachTime;
		var scale = timeDiff / approachTime;
		var approachScale = 1 + scale * 3;
		var fadeinScale = (timeDiff - approachTime + fadeInTime) / fadeInTime;
		var alpha = (1 - fadeinScale).clamp(0, 1);

        hitCircle.ifNone(() -> {
            var res = hxd.Res.load('images/hitcircle.png');
            var bmp = res.toImage().bitmap(sprite).center();
            bmp.scale(0.40);
            hitCircle = bmp.toOption();
        });

        // TODO: !!!
        /*if (GameMod.HIDDEN.isActive()) {
			final int hiddenDecayTime = game.getHiddenDecayTime();
			final int hiddenTimeDiff = game.getHiddenTimeDiff();
			if (fadeinScale <= 0f && timeDiff < hiddenTimeDiff + hiddenDecayTime) {
				float hiddenAlpha = (timeDiff < hiddenTimeDiff) ? 0f : (timeDiff - hiddenTimeDiff) / (float) hiddenDecayTime;
				alpha = Math.min(alpha, hiddenAlpha);
			}
		}*/

        // TODO: !!!
        /*if (timeDiff >= 0 && !GameMod.HIDDEN.isActive())
			GameImage.APPROACHCIRCLE.getImage().getScaledCopy(approachScale).drawCentered(x, y, color);
		GameImage.HITCIRCLE.getImage().drawCentered(x, y, color);
		boolean overlayAboveNumber = Options.getSkin().isHitCircleOverlayAboveNumber();
		if (!overlayAboveNumber)
			GameImage.HITCIRCLE_OVERLAY.getImage().drawCentered(x, y, Colors.WHITE_FADE);
		data.drawSymbolNumber(hitObject.getComboNumber(), x, y,
				GameImage.HITCIRCLE.getImage().getWidth() * 0.40f / data.getDefaultSymbolImage(0).getHeight(), alpha);
		if (overlayAboveNumber)
			GameImage.HITCIRCLE_OVERLAY.getImage().drawCentered(x, y, Colors.WHITE_FADE);

		Colors.WHITE_FADE.a = oldAlpha;*/
    }

    public override function update(delta:Float, mouseX:Float, mouseY:Float, keyPressed:Bool, trackPosition:Float):Bool {
        draw(trackPosition);
        updatePosition();

        var time = hitObject.time;

		var hitResultOffset = game.hitResultOffset;
		var isAutoMod = false; //GameMod.AUTO.isActive();

        trace(trackPosition, time + hitResultOffset[Hit50]);
		if (trackPosition > time + hitResultOffset[Hit50]) {
			/*if (isAutoMod)  // "auto" mod: catch any missed notes due to lag
				data.sendHitResult(time, GameData.HIT_300, x, y, color, comboEnd, hitObject, HitObjectType.CIRCLE, true, 0, null, false);

			else  // no more points can be scored, so send a miss
				data.sendHitResult(trackPosition, GameData.HIT_MISS, x, y, null, comboEnd, hitObject, HitObjectType.CIRCLE, true, 0, null, false);*/
			
            return true;
		}

		// "auto" mod: send a perfect hit result
		else if (isAutoMod) {
			if (Math.abs(trackPosition - time) < Std.int(hitResultOffset[Hit300])) {
				//data.sendHitResult(time, GameData.HIT_300, x, y, color, comboEnd, hitObject, HitObjectType.CIRCLE, true, 0, null, false);
				return true;
			}
		}

		// "relax" mod: click automatically
		else if (GameMod.relax.isActive() && trackPosition >= time)
			return mousePressed(mouseX, mouseY, trackPosition);

		return false;
    }

    public override function updatePosition() {
        trace('Pos:', hitObject.getScaledX(), hitObject.getScaledY());
        sprite.setPos(hitObject.getScaledX() + 100, hitObject.getScaledY() + 100);
    }
}
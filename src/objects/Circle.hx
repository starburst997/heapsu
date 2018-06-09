package objects;

import data.*;
import utils.*;
import scenes.*;
import scenes.Game;
import utils.Colors;

class Circle extends GameObject {
    
    private static var diameter:Float = 50.0;

    public static function init(circleDiameter:Float) {
        diameter = circleDiameter * HitObject.xMultiplier;
    }

    var color:Int;
    var comboEnd:Bool;

    var hitCircle:Option<h2d.Bitmap> = None;
    var approachCircle:Option<h2d.Bitmap> = None;
    var hitCircleOverlay:Option<h2d.Bitmap> = None;

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
        var alpha = (1 - fadeinScale).clamp();

        hitCircle.ifNone(() -> {
            var res = hxd.Res.images.hitcircle;
            var bmp = res.bitmap(sprite).changeScale(0.40).center().setColor(color);
            hitCircle = bmp.toOption();
        });

        approachCircle.ifNone(() -> {
            var res = hxd.Res.images.approachcircle;
            var bmp = res.bitmap(sprite).changeScale(0.40).center().setColor(color);
            approachCircle = bmp.toOption();
        });

        hitCircleOverlay.ifNone(() -> {
            var res = hxd.Res.images.approachcircle;
            var bmp = res.bitmap(sprite).changeScale(0.40).center().setColor(color);
            approachCircle = bmp.toOption();
        });

        if (GameMod.hidden.isActive()) {
            var hiddenDecayTime = game.hiddenDecayTime;
            var hiddenTimeDiff = game.hiddenTimeDiff;
            if (fadeinScale <= 0 && timeDiff < hiddenTimeDiff + hiddenDecayTime) {
                var hiddenAlpha = (timeDiff < hiddenTimeDiff) ? 0 : (timeDiff - hiddenTimeDiff) / hiddenDecayTime;
                alpha = Math.min(alpha, hiddenAlpha);
            }
        }

        switch([hitCircle, approachCircle, hitCircleOverlay]) {
            case [Some(hit), Some(approach), Some(overlay)] : 
                if (timeDiff >= 0 && !GameMod.hidden.isActive())
                    approach.changeScale(approachScale).center();

                var overlayAboveNumber = Options.skin.hitCircleOverlayAboveNumber;
                if (!overlayAboveNumber)
                    overlay.center().setColor(WhiteFade);
                //data.drawSymbolNumber(hitObject.getComboNumber(), x, y,
                //        GameImage.HITCIRCLE.getImage().getWidth() * 0.40f / data.getDefaultSymbolImage(0).getHeight(), alpha);
                if (overlayAboveNumber)
                    overlay.center().setColor(WhiteFade);

                //Colors.WHITE_FADE.a = oldAlpha;
            default : 
        }
    }

    public override function update(delta:Float, mouseX:Float, mouseY:Float, keyPressed:Bool, trackPosition:Float):Bool {
        draw(trackPosition);
        updatePosition();

        var time = hitObject.time;

        var hitResultOffset = game.hitResultOffset;
        var isAutoMod = false; //GameMod.AUTO.isActive();

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
        sprite.setPos(hitObject.getScaledX(), hitObject.getScaledY());
    }
}
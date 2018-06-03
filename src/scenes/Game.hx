package scenes;

import haxe.ds.Option;

import data.*;
import objects.*;
import utils.*;

using FS;
using FSHeaps;
using StringTools;

@:enum
abstract Hit(Int) from Int to Int {
    var HitMiss             = 0;
    var Hit50               = 1;
    var Hit100              = 2;
    var Hit300              = 3;
    var Hit100k             = 4;  // 100-Katu
    var Hit300k             = 5;  // 300-Katu
    var Hit300g             = 6;  // Geki
    var HitSlider10         = 7;
    var HitSlider30         = 8;
    var HitMax              = 9;
    var HitSliderRepeat     = 10;
    var HitAnimationResult  = 11;
    var HitSpinnerSpin      = 12;
    var HitSPinnerBonus     = 13;
    var HitMu               = 14; // Mu 
}

class Game extends h2d.Sprite {
    
    public static inline function create(s2d:h2d.Scene) {
        return new Game(s2d);
    }

    var isLoaded:Bool;
    var s2d:h2d.Scene;

    var beatmap:Beatmap;
    var music:hxd.snd.Channel;
    var background:h2d.Bitmap;
    var video:Option<h2d.Bitmap> = None;

    var cursor:h2d.Bitmap;

    var deathTime:Int = -1;
    var pauseTime:Int = -1;

    var gameFinished:Bool;

    // Breaks
    var breakIndex:Int;
    var breakTime:Int;

    var beatLengthBase:Float;
    var beatLength:Float;

    var objectIndex:Int;
    var gameObjects:Array<GameObject> = [];
    var passedObjects:Array<GameObject> = [];
    
    var timingPointIndex:Int;

    public var approachTime:Int;
    public var fadeInTime:Int;
    public var hitResultOffset:Array<Hit> = [];

    public function new(s2d:h2d.Scene) {
        this.s2d = s2d;
        super(s2d);
    }

    public function load(res:hxd.res.Any) {
        beatmap = Beatmap.fromBytes(res.entry.getBytes());
        
        Assert.that(beatmap.objects.length > 0);

        // Play music (use .ogg instead of .mp3)
        var musicPath = '${res.entry.directory}/${beatmap.audioFilename.replace('.mp3', '.ogg')}';
        var musicRes = hxd.Res.load(musicPath);
        music = musicRes.toSound().play(false);

        // Debug, skip a few seconds
        music.position = 13;

        // Load background (load menu as fallback)
        var backgroundPath = '${res.entry.directory}/${beatmap.backgroundFilename}';
        var backgroundRes = hxd.Res.load(backgroundPath);
        if (!backgroundRes.entry.isAvailable) backgroundRes = hxd.Res.load('images/menu-background.jpg');
        background = backgroundRes
            .toImage()
            .bitmap(this)
            .cover(s2d.width, s2d.height);
        
        // Cursor
        var cursorRes = hxd.Res.load('images/cursor.png');
        cursor = cursorRes.toImage().bitmap(this);
        cursor.scale(0.5);

        // Read beatmap objects
        var comboIndex = 0;
        var ignoreSkins = Options.isBeatmapSkinIgnored;
        var combo = beatmap.colors; // ignoreSkins ? Options.getSkin().getComboColors() : beatmap.colors
        beatmap.objects.iteri((i, hitObject) -> {
            // Is this the last note in the combo?
            var comboEnd = false;
            if (i + 1 >= beatmap.objects.length || beatmap.objects[i + 1].isNewCombo())
                comboEnd = true;

            // Calculate color index if ignoring beatmap skin
            var color;
            if (ignoreSkins) {
                if (hitObject.isNewCombo() || i == 0) {
                    var skip = (hitObject.isSpinner() ? 0 : 1) + hitObject.getComboSkip();
                    for (j in 0...skip) comboIndex = (comboIndex + 1) % combo.length;
                }
                color = combo[comboIndex];
            } else
                color = combo[hitObject.comboIndex];

            // Pass beatLength to hit objects
            var hitObjectTime = hitObject.time;
            while (timingPointIndex < beatmap.timingPoints.length) {
                var timingPoint = beatmap.timingPoints[timingPointIndex];
                if (timingPoint.time > hitObjectTime)
                    break;
                setBeatLength(timingPoint, false);
                timingPointIndex++;
            }

            // Create GameObjects
            gameObjects.push(new Circle(hitObject, this, color, comboEnd));

            /*if (hitObject.isCircle())
                gameObjects.push(new Circle(hitObject, this, color, comboEnd));
            else if (hitObject.isSlider())
                gameObjects.push(new Slider(hitObject, this, color, comboEnd));
            else if (hitObject.isSpinner())
                gameObjects.push(new Spinner(hitObject, this));
            else  // invalid hit object, use a dummy GameObject
                gameObjects.push(new Dummy(hitObject, this));*/
        });

        // Difficulty
        hitResultOffset = [for (i in 0...HitMax) 1000];

        /*hitResultOffset = new int[GameData.HIT_MAX];
		hitResultOffset[GameData.HIT_300]  = (int) Utils.mapDifficultyRange(overallDifficulty, 80, 50, 20);
		hitResultOffset[GameData.HIT_100]  = (int) Utils.mapDifficultyRange(overallDifficulty, 140, 100, 60);
		hitResultOffset[GameData.HIT_50]   = (int) Utils.mapDifficultyRange(overallDifficulty, 200, 150, 100);
		hitResultOffset[GameData.HIT_MISS] = (int) (500 - (overallDifficulty * 10));
		data.setHitResultOffset(hitResultOffset);*/

        isLoaded = true;
    }

    function setBeatLength(timingPoint:TimingPoint, setSampleSet:Bool) {
		if (!timingPoint.inherited)
			beatLengthBase = beatLength = timingPoint.beatLength;
		else
			beatLength = beatLengthBase * timingPoint.getSliderMultiplier();
		if (setSampleSet) {
            // TODO: !!!
			//HitSound.setDefaultSampleSet(timingPoint.getSampleType());
			//SoundController.setSampleVolume(timingPoint.getSampleVolume());
		}
	}

    public function update(dt:Float) {
        if (isLoaded) {
            var width = s2d.width;
            var height = s2d.height;
            var trackPosition = music.position * 1000;
            if (pauseTime > -1)  // returning from pause screen
                trackPosition = pauseTime;
            else if (deathTime > -1)  // "Easy" mod: health bar increasing
                trackPosition = deathTime;
            var firstObjectTime = beatmap.objects[0].time;
		    var timeDiff = firstObjectTime - trackPosition;

            if (GameMod.flashlight.isActive()) {
                // TODO: !!!
            }

            // cursor
            cursor.setPos(s2d.mouseX, s2d.mouseY);
            cursor.center();

            // background
            var dimLevel = Options.backgroundDim;
            switch(video) {
                case Some(video) : // TODO: !!!
                case None : 
                    if (trackPosition < firstObjectTime) {
                        if (timeDiff < approachTime)
                            dimLevel += (1 - dimLevel) * (timeDiff / approachTime);
                        else
                            dimLevel = 1;
                    }
                    if (Options.isDefaultPlayfieldForced) background.cover(width, height, 0, 0, dimLevel, false, Options.isParallaxEnabled ? Options.parallaxScale : 0.0);
            }

            // break periods
		    if (beatmap.breaks.length > 0 && breakIndex < beatmap.breaks.length && breakTime > 0) {
                // Some fade to black transition + show the weird red arrows and the X / Check mark if over 50% health
                // TODO: !!!
            } else {
                //data.drawGameElements(g, false, objectIndex == 0, gameElementAlpha);
            }

            // Process object
            var keyPressed = false;
            passedObjects.iter(object -> {
                if (object.update(dt, s2d.mouseX, s2d.mouseY, keyPressed, trackPosition)) {
                    object.reset();
					passedObjects.remove(object);
                }
            });

			// update objects (loop over any skipped indexes)
            while (objectIndex < gameObjects.length && trackPosition > beatmap.objects[objectIndex].time) {
				// check if we've already passed the next object's start time
				var overlap =
					(objectIndex + 1 < gameObjects.length &&
					trackPosition > beatmap.objects[objectIndex + 1].time - hitResultOffset[Hit50]);

				// update hit object and check completion status
				var object = gameObjects[objectIndex];
                if (object.sprite.parent == null) addChild(object.sprite);
                if (object.update(dt, s2d.mouseX, s2d.mouseY, keyPressed, trackPosition)) {
					// done, so increment object index
                    object.reset();
					objectIndex++;
				} else if (overlap) {
					// overlap, so save the current object and increment object index
					passedObjects.push(object);
					objectIndex++;
				} else
					break;
			}
        }
    }
}
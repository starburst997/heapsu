package scenes;

import haxe.ds.Option;

import data.*;
import objects.*;
import utils.*;

using FS;
using FSHeaps;
using StringTools;

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

    var approachTime:Int;
    var gameFinished:Bool;

    // Breaks
    var breakIndex:Int;
    var breakTime:Int;

    var beatLengthBase:Float;
    var beatLength:Float;

    var gameObjects:Array<GameObject> = [];
    
    var timingPointIndex:Int;
    
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
            if (hitObject.isCircle())
                gameObjects.push(new Circle(hitObject, this, color, comboEnd));
            else if (hitObject.isSlider())
                gameObjects.push(new Slider(hitObject, this, color, comboEnd));
            else if (hitObject.isSpinner())
                gameObjects.push(new Spinner(hitObject, this));
            else  // invalid hit object, use a dummy GameObject
                gameObjects.push(new Dummy(hitObject, this));
        });

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
            var trackPosition = music.position;
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

        }
    }
}
import haxe.ds.Option;

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
    
    public function new(s2d:h2d.Scene) {
        this.s2d = s2d;
        super(s2d);
    }

    public function load(res:hxd.res.Any) {
        beatmap = Beatmap.fromBytes(res.entry.getBytes());
        
        // Play music (use .ogg instead of .mp3)
        var musicPath = '${res.entry.directory}/${beatmap.audioFilename.replace('.mp3', '.ogg')}';
        var musicRes = hxd.Res.load(musicPath);
        music = musicRes.toSound().play(false);

        // Load background
        var backgroundPath = '${res.entry.directory}/${beatmap.backgroundFilename}';
        var backgroundRes = hxd.Res.load(backgroundPath);
        background = backgroundRes
            .toImage()
            .bitmap(this)
            .cover(s2d.width, s2d.height);

        isLoaded = true;
    }

    public function update(dt:Float) {
        if (isLoaded) {
            trace(music.position);
        }
    }
}
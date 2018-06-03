using FS;
using Lambda;

class Main extends hxd.App {
	var bmp:h2d.Bitmap;
	
    var isMobile = #if mobile true #else false #end;

    override function setup() {
        #if hlsdl
        switch(hxd.System.platform) { // TODO: Not working
            case hxd.System.Platform.Android | hxd.System.Platform.IOS : isMobile = true;
            default:
        }
        #end

        if (isMobile) {
            // Remove status bar
            var stage = hxd.Stage.getInstance();
            var e = h3d.Engine.getCurrent();
            
            @:privateAccess stage.window.displayMode = sdl.Window.DisplayMode.Fullscreen;
            @:privateAccess e.resize(stage.window.width, stage.window.height);
        }

        super.setup();
    }

	override function init() {
        super.init();

        trace(s2d.width, s2d.height);

		var tile = h2d.Tile.fromColor(0xFF0000, 100, 100);
		bmp = new h2d.Bitmap(tile, s2d);
		bmp.x = s2d.width * 0.5;
		bmp.y = s2d.height * 0.5;

        // Dummy test
        var folder = hxd.Res.load('beatmaps');
        var beatmapFolders = folder.filter(folder -> folder.name.charAt(0) != '.').array();

        // Load the first one
        if (beatmapFolders.length > 0) {
            // Load first .osu in folder
            var beatmapFolder = beatmapFolders[0];
            var beatmaps = beatmapFolder.array();
            if (beatmaps.length > 0) {
                var beatmapEntry = beatmaps[0];
                var beatmap = Beatmap.fromBytes(beatmapEntry.entry.getBytes());
                trace(beatmap.fileFormat);
            }
        }

        trace('Yo! Yo!');
	}
	
	override function update(dt:Float) {
		bmp.rotation += 0.1;

        // Keyboard inputs
        if (hxd.Key.isPressed(hxd.Key.ESCAPE)) {
            hxd.System.exit();
        }
	}
	
	static function main() {
        hxd.Res.initLocal();
		new Main();
	}
}
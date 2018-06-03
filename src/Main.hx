import haxe.ds.Option;

using FS;
using Lambda;
using StringTools;

class Main extends hxd.App {
    
    var game:Game;
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

        game = Game.create(s2d);

        // Load the first one
        var folder = hxd.Res.load('beatmaps');
        var beatmapFolders = folder.filter(folder -> folder.name.charAt(0) != '.').array();
        if (beatmapFolders.length > 0) {
            // Load first .osu in folder
            var beatmapFolder = beatmapFolders[0];
            var beatmaps = beatmapFolder.filter(file -> file.entry.name.endsWith('.osu')).array();
            if (beatmaps.length > 0) {
                game.load(beatmaps[0]);
            }
        }
    }
    
    override function update(dt:Float) {
        game.update(dt);

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
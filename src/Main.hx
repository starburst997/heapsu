import haxe.ds.Option;

import scenes.*;

using FS;
using Lambda;
using StringTools;

class Main extends hxd.App {
    
    var game:Game;

    // TODO: Hack until hxd.System.Platform works
    var isMobile = #if mobile true #else false #end;

    override function setup() {
        #if hlsdl
        switch(hxd.System.platform) { // TODO: Not working
            case hxd.System.Platform.Android | hxd.System.Platform.IOS : isMobile = true;
            default:
        }
        
        // Fix retina display
        // TODO: Finc a proper fix in hashlink / heaps
        var stage = hxd.Stage.getInstance();
        var e = h3d.Engine.getCurrent();
        @:privateAccess e.resize(stage.window.drawableWidth, stage.window.drawableHeight);
        
        #if mobile
        @:privateAccess stage.window.displayMode = sdl.Window.DisplayMode.Fullscreen;
        #end
        #end

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
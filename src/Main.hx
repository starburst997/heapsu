import hxd.Event;

import data.*;
import scenes.*;

class Main extends hxd.App {
    
    var game:Game;
    var trackBar:h2d.Bitmap;
    var title:h2d.Text;
    var timer:h2d.Text;

    // TODO: Hack until hxd.System.Platform works
    var isMobile = #if mobile true #else false #end;

    override function setup() {
        #if hlsdl
        switch(hxd.System.platform) { // TODO: Not working
            case hxd.System.Platform.Android | hxd.System.Platform.IOS : isMobile = true;
            default:
        }
        
        // Fix retina display
        // TODO: Find a proper fix in hashlink / heaps
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
        
        // Create UI elements
        trackBar = h2d.Tile.fromColor(0x990000, 10, 10).bitmap(s2d);

        var font = hxd.Res.fonts.kaufhalle.toFont();
        title = font.text(s2d).setColor(0xAA0000).setAlign(Center).setPosition(0, 20);
        timer = font.text(s2d);

        // Load the first one
        var folder = hxd.Res.load('beatmaps');
        var beatmapFolders = folder.filter(folder -> folder.name.charAt(0) != '.').array();
        if (beatmapFolders.length > 0) {
            // Load first .osu in folder
            var beatmapFolder = beatmapFolders[0];
            var beatmaps = beatmapFolder.filter(file -> file.entry.name.endsWith('.osu')).array();
            if (beatmaps.length > 0) {
                load(game.load(beatmaps[0]));
            }
        }

        hxd.Stage.getInstance().addEventTarget(onEvent);

        onResize();
    }

    function load(beatmap:Beatmap) {
        title.setText('${beatmap.title} by ${beatmap.artist}');
    }

    override function onResize() {
        trace('RESIZE', s2d.width, s2d.height);

        title.maxWidth = s2d.width;

        game.onResize();
    }

    function onEvent(e:hxd.Event) {
        // Debug mode
        switch(e.kind) {
            case EWheel:
                game.music.position += e.wheelDelta * 0.01;
            case EPush:
                if (e.button == 0) game.music.pause = !game.music.pause;
            case EKeyDown: switch( e.keyCode ) {
                case hxd.Key.ESCAPE: hxd.System.exit();
                default:
            }
            default:
        }
    }
    
    override function update(dt:Float) {
        game.update(dt);

        // Mouse gesture
        if (hxd.Key.isDown(hxd.Key.MOUSE_LEFT)) {

        }
    }
    
    static function main() {
        hxd.Res.initLocal();
        new Main();
    }
}
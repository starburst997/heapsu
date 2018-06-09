# heapsu!
osu! clone in heaps

First run `./install.sh` to install libraries and the likes

To run in HL, `./make.sh`

To run in iOS, `haxe build-hlc.hxml -D mobile`, open the XCode project at xcode/iOS/heaps-iOS.xcodeproj, press Build (you will probably need to modify the signing / bundle identifier).

Put your uncompressed `.osu` folder in `res/beatmaps`

You need to convert the `.mp3` to `.ogg` for now (ex: `ffmpeg -i song.mp3 -ar 44100 -c:a libvorbis song.ogg`)

WIP

## Generating fonts

I personally use [Hiero](https://libgdx.badlogicgames.com/nightlies/runnables/runnable-hiero.jar) from [libGDX](https://github.com/libgdx/libgdx), choose your font, select `Java` as rendering, choose ASCII and set the color as white. Select `File -> Save BMFont files` and put them in the `res/fonts` folder. 
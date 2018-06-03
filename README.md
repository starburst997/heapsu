# heapsu!
osu! clone in heaps

First run `./install.sh` to install libraries and the likes

To run in HL, `./make.sh`

To run in iOS, `haxe build-hlc.hxml -D mobile`, open the XCode project at xcode/iOS/heaps-iOS.xcodeproj, press Build (you will probably need to modify the signing / bundle identifier).

Put your uncompressed `.osu` folder in `res/beatmaps`

You need to convert the `.mp3` to `.ogg` for now (ex: `ffmpeg -i song.mp3 song.ogg`)

WIP
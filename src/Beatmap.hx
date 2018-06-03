import haxe.io.Bytes;
import HitObject;

using StringTools;
using FS;

@:enum
abstract Header(String) {
    var General              = '[General]';
    var Editor               = '[Editor]';
    var Metadata             = '[Metadata]';
    var Difficulty           = '[Difficulty]';
    var Events               = '[Events]';
    var TimingPoints         = '[TimingPoints]';
    var Colours              = '[Colours]';
    var HitObjects           = '[HitObjects]';
}

@:enum
abstract General(String) {
    var AudioFilename        = 'AudioFilename';
    var AudioLeadIn          = 'AudioLeadIn';
    var AudioHash            = 'AudioHash'; 
    var PreviewTime          = 'PreviewTime';
    var Countdown            = 'Countdown';
    var SampleSet            = 'SampleSet';
    var StackLeniency        = 'StackLeniency';
    var Mode                 = 'Mode';
    var LetterboxInBreaks    = 'LetterboxInBreaks';
    var WidescreenStoryboard = 'WidescreenStoryboard';
    var EpilepsyWarning      = 'EpilepsyWarning';
    var SpecialStyle         = 'SpecialStyle';
}

@:enum
abstract Editor(String) {
    var Bookmarks            = 'Bookmarks';
    var DistanceSpacing      = 'DistanceSpacing';
    var BeatDivisor          = 'BeatDivisor'; 
    var GridSize             = 'GridSize';
    var TimelineZoom         = 'TimelineZoom';
}

@:enum
abstract Metadata(String) {
    var Title                = 'Title';
    var TitleUnicode         = 'TitleUnicode';
    var Artist               = 'Artist'; 
    var ArtistUnicode        = 'ArtistUnicode';
    var Creator              = 'Creator';
    var Version              = 'Version';
    var Source               = 'Source';
    var Tags                 = 'Tags';
    var BeatmapID            = 'BeatmapID';
    var BeatmapSetID         = 'BeatmapSetID';
}

@:enum
abstract Difficulty(String) {
    var HPDrainRate          = 'HPDrainRate';
    var CircleSize           = 'CircleSize';
    var OverallDifficulty    = 'OverallDifficulty'; 
    var ApproachRate         = 'ApproachRate';
    var SliderMultiplier     = 'SliderMultiplier';
    var SliderTickRate       = 'SliderTickRate';
}

@:enum
abstract Events(String) {
    var Background           = '0';
    var Video                = '1';
    var VideoOpt             = 'Video';
    var Breaks               = '2'; 
}

@:enum
abstract Colours(String) {
    var Combo1               = 'Combo1';
    var Combo2               = 'Combo2';
    var Combo3               = 'Combo3';
    var Combo4               = 'Combo4';
    var Combo5               = 'Combo5';
    var Combo6               = 'Combo6';
    var Combo7               = 'Combo7';
    var Combo8               = 'Combo8';
    var SliderBorder         = 'SliderBorder';
}

class Beatmap {
    
    public static inline function create() {
        return new Beatmap();
    }

    public static inline function fromBytes(bytes:Bytes) {
        return create().parseString(bytes.toString());
    }
    
    var fileFormat:String;

    // General
    var audioFilename:String;
    var audioLeadIn:Int;
    var audioHash:String;
    var previewTime:Int;
    var countdown:Int;
    var sampleSet:String;
    var stackLeniency:Float;
    var mode:Int;
    var letterboxInBreaks:Bool;
    var widescreenStoryboard:Bool;
    var epilepsyWarning:Bool;
    var specialStyle:Bool;

    // Editor
    var bookmarks:String;
    var distanceSpacing:Int;
    var beatDivisor:Int;
    var gridSize:Int;
    var timelineZoom:Float;

    // Metadata
    var title:String;
    var titleUnicode:String;
    var artist:String;
    var artistUnicode:String;
    var creator:String;
    var version:String;
    var source:String;
    var tags:String;
    var beatmapID:Int;
    var beatmapSetID:Int;

    // Difficulty
    var hpDrainRate:Float;
    var circleSize:Float;
    var overallDifficulty:Float; 
    var approachRate:Float;
    var sliderMultiplier:Float;
    var sliderTickRate:Float;

    // Events
    var backgroundFilename:String;
    var videoFilename:String;
    var videoOffset:Int;
    var breaks:Array<Int>;

    // Timing Points
    var timingPoints:Array<TimingPoint>;
    var bpmMin:Int;
    var bpmMax:Int;

    // Colours
    var colors:Array<Int>;
    var sliderBorder:Int;

    // HitObject
    var endTime:Int;
    var hitObjectCircle:Int;
    var hitObjectSlider:Int;
    var hitObjectSpinner:Int;
    var objects:Array<HitObject>;

    public function new() {
        
    }

    public function parseString(file:String, parseObject:Bool = true):Beatmap {
        // Reset
        breaks = [];
        timingPoints = [];
        colors = [];
        objects = [];
        
        // Utils functions
        function parseInt(value:String)      return Std.parseInt(value);
        function parseFloat(value:String)    return Std.parseFloat(value);
        function parseBool(value:String)     return parseInt(value) == 1;
        function parseFilename(value:String) return ~/^"|"$/g.replace(value, '');
        function breaker(line)               return line.charAt(0) == '[';

        // Parse all lines in file
        var lines = LineParser
            .create(file)
            .setFormatter(line -> line.trim())
            .setValidator(line -> line.length > 1 && !line.startsWith('//'));
        
        // Format lines
        var pairLines = lines
            .clone(line -> {
                var a = line.split(':').map(str -> str.trim());
                Assert.that(a.length == 2);
                return {
                    key: a.getOr(0, () -> 'missing'),
                    value: a.getOr(1, () -> 'missing')
                };
            })
            .setBreaker(breaker);

        var arrayLines = lines
            .clone(line -> {
                var a = line.split(',').map(str -> str.trim());
                Assert.that(a.length > 0);
                return {
                    key: a.shift(),
                    values: a
                };
            })
            .setBreaker(breaker);

        var strLines = lines
            .clone(line -> line)
            .setBreaker(breaker);

        // Read the file
        fileFormat = lines.readLine();
        lines.iter(line -> switch(line) {
            case General : 
                pairLines.iter(function(line) switch(line.key) {
                    case AudioFilename        : audioFilename = line.value;
                    case AudioLeadIn          : audioLeadIn = parseInt(line.value);
                    case AudioHash            : audioHash = line.value;
                    case PreviewTime          : previewTime = parseInt(line.value);
                    case Countdown            : countdown = parseInt(line.value);
                    case SampleSet            : sampleSet = line.value;
                    case StackLeniency        : stackLeniency = parseFloat(line.value);
                    case Mode                 : mode = parseInt(line.value);
                    case LetterboxInBreaks    : letterboxInBreaks = parseBool(line.value);
                    case WidescreenStoryboard : widescreenStoryboard = parseBool(line.value);
                    case EpilepsyWarning      : epilepsyWarning = parseBool(line.value);
                    case SpecialStyle         : specialStyle = parseBool(line.value);
                    default : Assert.warn('Unknown general line: ${line.key} with value ${line.value}');
                });
            case Editor : 
                pairLines.iter(function(line) switch(line.key) {
                    case Bookmarks            : bookmarks = line.value;
                    case DistanceSpacing      : distanceSpacing = parseInt(line.value);
                    case BeatDivisor          : beatDivisor = parseInt(line.value);
                    case GridSize             : gridSize = parseInt(line.value);
                    case TimelineZoom         : timelineZoom = parseFloat(line.value);
                    default : Assert.warn('Unknown editor line: ${line.key} with value ${line.value}');
                });
            case Metadata : 
                pairLines.iter(function(line) switch(line.key) {
                    case Title                : title = line.value;
                    case TitleUnicode         : titleUnicode = line.value;
                    case Artist               : artist  = line.value;
                    case ArtistUnicode        : artistUnicode = line.value;
                    case Creator              : creator = line.value;
                    case Version              : version = line.value;
                    case Source               : source = line.value;
                    case Tags                 : tags = line.value.toLowerCase();
                    case BeatmapID            : beatmapID = parseInt(line.value);
                    case BeatmapSetID         : beatmapSetID = parseInt(line.value);
                    default : Assert.warn('Unknown metadata line: ${line.key} with value ${line.value}');
                });
            case Difficulty : 
                pairLines.iter(function(line) switch(line.key) {
                    case HPDrainRate          : hpDrainRate = parseFloat(line.value);
                    case CircleSize           : circleSize = parseFloat(line.value);
                    case OverallDifficulty    : overallDifficulty = parseFloat(line.value); 
                    case ApproachRate         : approachRate = parseFloat(line.value);
                    case SliderMultiplier     : sliderMultiplier = parseFloat(line.value);
                    case SliderTickRate       : sliderTickRate = parseFloat(line.value);
                    default : Assert.warn('Unknown difficulty line: ${line.key} with value ${line.value}');
                });
            case Events : 
                arrayLines.iter(function(line) switch(line.key) {
                    case Background           : backgroundFilename = parseFilename(line.values[1]);
                    case Video | VideoOpt     : 
                        videoFilename = parseFilename(line.values[1]);
                        videoOffset = parseInt(line.values[0]);
                    case Breaks               : 
                        breaks.pushAll(line.values.mapa(line -> parseInt(line)));
                    default : Assert.warn('Unknown events line: ${line.key} with values ${line.values}');
                });
            case TimingPoints : 
                strLines.iter(line -> {
                    var timingPoint = TimingPoint.create().parseString(line);
                    timingPoints.push(timingPoint);
                    
                    if (!timingPoint.isInherited()) {
                        var bpm = Math.round(60000 / timingPoint.getBeatLength());
                        bpmMin = Math.min(bpm, bpmMin).toInt();
                        bpmMax = Math.min(bpm, bpmMax).toInt();
                    }
                });
            case Colours : 
                pairLines.iter(function(line) {
                    var rgb = line.value.split(',').map(c -> parseInt(c));
                    Assert.that(rgb.length == 3);
                    var color:Int = rgb[0] << 16 | rgb[1] << 8 | rgb[2];
                    switch(line.key) {
                        case Combo1 | Combo2 | Combo3 | Combo4 | Combo5 | Combo6 | Combo7 | Combo8 : 
                            colors.push(color);
                        case SliderBorder : 
                            sliderBorder = color;
                        default : Assert.warn('Unknown colours line: ${line.key}');
                    }
                });
            case HitObjects : 
                var first = false;
                var comboIndex = 0;
			    var comboNumber = 1;
                strLines.iter(function(line) {
                    Assert.that(line.length >= 5);
                    
                    var values = line.split(',').map(str -> str.trim());
                    var type = parseInt(values[3]);
                    if (type & Circle > 0) {
                        hitObjectCircle++;
                    } else if (type & Slider > 0) {
                        hitObjectSlider++;
                    } else {
                        hitObjectSpinner++;
                    }

                    if (type & Spinner > 0) {
                        var index = values[5].indexOf(':');
                        if (index != -1)
                            values[5] = values[5].substring(0, index);
                        endTime = parseInt(values[5]);
                    } else if (type != 0)
                        endTime = parseInt(values[2]);

                    if (parseObject) {
                        var hitObject = HitObject.create().parseValues(values);

                        if (hitObject.isNewCombo() || first) {
                            var skip = (hitObject.isSpinner() ? 0 : 1) + hitObject.getComboSkip();
                            for (i in 0...skip) {
                                comboIndex = (comboIndex + 1) % colors.length;
                                comboNumber = 1;
                            }
                            first = false;
                        }

                        hitObject.comboIndex = comboIndex;
                        hitObject.comboNumber = comboNumber++;

                        objects.push(hitObject);
                    }
                });
            default : 
                Assert.warn('Unknown line header: $line');
                strLines.iter(line -> Assert.warn(':: $line'));
        });

        return this;
    }
}
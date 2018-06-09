package utils;

@:enum
abstract Color(Int) from Int to Int {
    var BlackAlpha      = Macro.fromColor(0, 0, 0, 0.5);
    var WhiteAlpha      = Macro.fromColor(255, 255, 255, 0.5);
    var BlueDivider     = Macro.fromColor(49, 94, 237);
    var BlueBackground  = Macro.fromColor(74, 130, 255);
    var BlueButton      = Macro.fromColor(40, 129, 237);
    var OrangeButton    = Macro.fromColor(200, 90, 3);
    var PinkButton      = Macro.fromColor(223, 71, 147);
    var YellowAlpha     = Macro.fromColor(255, 255, 0, 0.4);
    var WhiteFade       = Macro.fromColor(255, 255, 255, 1);
    var RedHover        = Macro.fromColor(255, 112, 112);
    var Green           = Macro.fromColor(137, 201, 79);
    var LightOrange     = Macro.fromColor(255, 192, 128);
    var LightGreen      = Macro.fromColor(128, 255, 128);
    var LightBlue       = Macro.fromColor(128, 128, 255);
    var GreenSearch     = Macro.fromColor(173, 255, 47);
    var DarkGray        = Macro.fromColor(0.3, 0.3, 0.3, 1);
    var RedHighlight    = Macro.fromColor(246, 154, 161);
    var BlueHighlight   = Macro.fromColor(173, 216, 230);
    var BlueeScoreboard = Macro.fromColor(133, 208, 212);
    var BlackBGNormal   = Macro.fromColor(0, 0, 0, 0.25);
    var BlackBGHover    = Macro.fromColor(0, 0, 0, 0.5);
    var BlackBGFocus    = Macro.fromColor(0, 0, 0, 0.75);
    var GhostLogo       = Macro.fromColor(1.0, 1.0, 1.0, 0.25);
    var PinkOption      = Macro.fromColor(235, 117, 139);
    var BlueOption      = Macro.fromColor(88, 217, 253);
    var Purple          = Macro.fromColor(138, 43, 226);
    var YellowFill      = Macro.fromColor(255, 219, 124);
}
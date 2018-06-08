package utils;

@:enum
abstract Color(Int) from Int to Int {
    var BlackAlpha      = FSMacro.fromColor(0, 0, 0, 0.5);
    var WhiteAlpha      = FSMacro.fromColor(255, 255, 255, 0.5);
    var BlueDivider     = FSMacro.fromColor(49, 94, 237);
    var BlueBackground  = FSMacro.fromColor(74, 130, 255);
    var BlueButton      = FSMacro.fromColor(40, 129, 237);
    var OrangeButton    = FSMacro.fromColor(200, 90, 3);
    var PinkButton      = FSMacro.fromColor(223, 71, 147);
    var YellowAlpha     = FSMacro.fromColor(255, 255, 0, 0.4);
    var WhiteFade       = FSMacro.fromColor(255, 255, 255, 1);
    var RedHover        = FSMacro.fromColor(255, 112, 112);
    var Green           = FSMacro.fromColor(137, 201, 79);
    var LightOrange     = FSMacro.fromColor(255, 192, 128);
    var LightGreen      = FSMacro.fromColor(128, 255, 128);
    var LightBlue       = FSMacro.fromColor(128, 128, 255);
    var GreenSearch     = FSMacro.fromColor(173, 255, 47);
    var DarkGray        = FSMacro.fromColor(0.3, 0.3, 0.3, 1);
    var RedHighlight    = FSMacro.fromColor(246, 154, 161);
    var BlueHighlight   = FSMacro.fromColor(173, 216, 230);
    var BlueeScoreboard = FSMacro.fromColor(133, 208, 212);
    var BlackBGNormal   = FSMacro.fromColor(0, 0, 0, 0.25);
    var BlackBGHover    = FSMacro.fromColor(0, 0, 0, 0.5);
    var BlackBGFocus    = FSMacro.fromColor(0, 0, 0, 0.75);
    var GhostLogo       = FSMacro.fromColor(1.0, 1.0, 1.0, 0.25);
    var PinkOption      = FSMacro.fromColor(235, 117, 139);
    var BlueOption      = FSMacro.fromColor(88, 217, 253);
    var Purple          = FSMacro.fromColor(138, 43, 226);
    var YellowFill      = FSMacro.fromColor(255, 219, 124);
}
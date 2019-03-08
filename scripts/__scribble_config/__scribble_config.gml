#macro SCRIBBLE_FONT_DIRECTORY "Fonts/"

#macro SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß"

#macro SCRIBBLE_DEFAULT_WAVE_SIZE            4
#macro SCRIBBLE_DEFAULT_SHAKE_SIZE           4
#macro SCRIBBLE_DEFAULT_RAINBOW_WEIGHT       0.4
#macro SCRIBBLE_DEFAULT_CHARACTER_SMOOTHNESS 0
#macro SCRIBBLE_DEFAULT_LINE_SMOOTHNESS      0
#macro SCRIBBLE_DEFAULT_TYPEWRITER_SPEED     0.3
#macro SCRIBBLE_DEFAULT_TYPEWRITER_METHOD    SCRIBBLE_TYPEWRITER_PER_CHARACTER

#macro SCRIBBLE_EMULATE_LEGACY_SPRITEFONT_SPACING false //GMS2.2.1 made spritefonts much more spaced out for some reason. Turn this if you want to replicate pre-GMS2.2.1 spritefont behaviour
#macro SCRIBBLE_HASH_NEWLINE                       true //Replaces hashes (#) with newlines (ASCII chr10) to emulate GMS1 behaviour
#macro SCRIBBLE_COMPATIBILITY_MODE                false //Forces Scribble functions to use GM's native renderer. Turn this on if certain platforms are causing problems

#macro SCRIBBLE_TIME (current_time/1000) //The value that Scribble uses to calculate effects

#macro SCRIBBLE_TYPEWRITER_PER_CHARACTER 0
#macro SCRIBBLE_TYPEWRITER_PER_LINE      1

#region -- Internal Definitions --

#macro __SCRIBBLE_VERSION "2.5.0 (light)"
#macro __SCRIBBLE_DATE    "2019/03/08"

enum E_SCRIBBLE_WORD
{
    X, Y,
    WIDTH, HEIGHT,
    VALIGN,
    STRING, INPUT_STRING,
    SPRITE, IMAGE,
    LENGTH, FONT, COLOUR,
    RAINBOW, SHAKE, WAVE, NEXT_SEPARATOR,
    __SIZE
}

enum E_SCRIBBLE_LINE
{
    X, Y,
    WIDTH, HEIGHT,
    LENGTH, HALIGN,
    WORDS,
    __SIZE
}

enum __E_SCRIBBLE_GLYPH
{
    CHAR,  //0
    ORD,   //1
    X,     //2
    Y,     //3
    W,     //4
    H,     //5
    DX,    //6
    DY,    //7
    SHF,   //8
    U0,    //9
    V0,    //10
    U1,    //11
    V1,    //12
    __SIZE //13
}

#endregion
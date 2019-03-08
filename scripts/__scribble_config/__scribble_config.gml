#macro SCRIBBLE_FONT_DIRECTORY "Fonts/"

#macro SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß"

#macro SCRIBBLE_DEFAULT_WAVE_SIZE            4
#macro SCRIBBLE_DEFAULT_SHAKE_SIZE           4
#macro SCRIBBLE_DEFAULT_RAINBOW_WEIGHT       0.4
#macro SCRIBBLE_DEFAULT_CHARACTER_SMOOTHNESS 0
#macro SCRIBBLE_DEFAULT_LINE_SMOOTHNESS      0

#macro SCRIBBLE_EMULATE_LEGACY_SPRITEFONT_SPACING false //GMS2.2.1 made spritefonts much more spaced out for some reason
#macro SCRIBBLE_HASH_NEWLINE                       true //Replaces hashes (#) with newlines (ASCII chr10) to emulate GMS1 behaviour
#macro SCRIBBLE_COMPATIBILITY_MODE                false //Forces Scribble functions to use GM's native renderer. Turn this on if certain platforms are causing problems
#macro SCRIBBLE_SAFE_MODE                          true //Pedantic checking
#macro SCRIBBLE_DEFAULT_SHADER          shScribbleLight

#region -- Internal Definitions --

#macro __SCRIBBLE_VERSION "2.5.0 (light)"
#macro __SCRIBBLE_DATE    "2019/03/08"

#macro SCRIBBLE_VERTEX_FORMAT    global.__scribble_vertex_format
#macro SCRIBBLE_MAX_SPRITE_SLOTS 4 //Additionally change the constant in shScribbleLight

#macro __SCRIBBLE_NO_SPRITE -1

enum E_SCRIBBLE_WORD
{
    X, Y,
    WIDTH, HEIGHT,
    VALIGN,
    STRING, INPUT_STRING,
    SPRITE, IMAGE, SPRITE_SLOT,
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
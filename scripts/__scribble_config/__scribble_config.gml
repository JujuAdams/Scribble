#macro SCRIBBLE_FONT_DIRECTORY "Fonts/"

#macro SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß"
#macro SCRIBBLE_DEFAULT_SPRITEFONT_SEPARATION 0
#macro SCRIBBLE_DEFAULT_SHADER shScribble

#macro SCRIBBLE_LEGACY_GMS220_SPRITEFONT_SPACING false //GMS2.2.1 made spritefonts much more spaced out for some reason
#macro SCRIBBLE_HASH_NEWLINE true                      //Replaces hashes (#) with newlines (chr13) to emulate GMS1 behaviour
#macro SCRIBBLE_COMPATIBILITY_MODE false               //Forces Scribble functions to use GM's native renderer. Turn this on if certain platforms are causing problems
#macro SCRIBBLE_SAFE_MODE true                         //Pedantic checking

#region -- Internal Definitions --

#macro __SCRIBBLE_VERSION "02.03.02"
#macro __SCRIBBLE_DATE    "2018/01/14"

#macro SCRIBBLE_VERTEX_FORMAT    global.__scribble_vertex_format
#macro SCRIBBLE_MAX_HYPERLINKS   4 //Additionally change the constant in shScribble
#macro SCRIBBLE_MAX_SPRITE_SLOTS 4 //Additionally change the constant in shScribble

#macro __SCRIBBLE_NO_SPRITE -1

enum E_SCRIBBLE_WORD
{
    X, Y,
    WIDTH, HEIGHT,
    VALIGN,
    STRING, INPUT_STRING,
    SPRITE, IMAGE, SPRITE_SLOT,
    LENGTH, FONT, COLOUR,
    HYPERLINK,
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

enum __E_SCRIBBLE_HYPERLINK
{
    NONE = -2,
    UNLINKED = -1
}

#endregion
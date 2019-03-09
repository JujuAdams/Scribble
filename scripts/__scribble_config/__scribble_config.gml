//  Scribble (light) v2.5.1
//  2019/03/09
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  Intended for use with GMS2.2.1 and later

#macro SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß"
#macro SCRIBBLE_DEFAULT_WAVE_SIZE             4
#macro SCRIBBLE_DEFAULT_SHAKE_SIZE            4
#macro SCRIBBLE_DEFAULT_RAINBOW_WEIGHT        0.4
#macro SCRIBBLE_DEFAULT_TYPEWRITER_SPEED      0.3
#macro SCRIBBLE_DEFAULT_TYPEWRITER_METHOD     SCRIBBLE_TYPEWRITER_PER_CHARACTER
#macro SCRIBBLE_DEFAULT_TYPEWRITER_SMOOTHNESS 3

#macro SCRIBBLE_FONT_DIRECTORY                    "Fonts/" 
#macro SCRIBBLE_EMULATE_LEGACY_SPRITEFONT_SPACING false    //GMS2.2.1 made spritefonts much more spaced out for some reason. Turn this if you want to replicate pre-GMS2.2.1 spritefont behaviour
#macro SCRIBBLE_HASH_NEWLINE                       true    //Replaces hashes (#) with newlines (ASCII chr10) to emulate GMS1 behaviour
#macro SCRIBBLE_COMPATIBILITY_MODE                false    //Forces Scribble functions to use GM's native draw_text() renderer. Turn this on if certain platforms are causing problems
#macro SCRIBBLE_TIME                              (current_time/1000) //The value that Scribble uses to calculate effects

#macro SCRIBBLE_TYPEWRITER_PER_CHARACTER      0
#macro SCRIBBLE_TYPEWRITER_PER_LINE           1

#region -- Internal Definitions --

#macro __SCRIBBLE_VERSION "2.5.1 (light)"
#macro __SCRIBBLE_DATE    "2019/03/09"

enum __E_SCRIBBLE_FONT
{
    NAME,           // 0
    TYPE,           // 1
    TEXTURE_WIDTH,  // 2
    TEXTURE_HEIGHT, // 3
    SPACE_WIDTH,    // 4
    MAPSTRING,      // 5
    SEPARATION,     // 6
    SPRITE,         // 7
    SPRITE_X,       // 8
    SPRITE_Y,       // 9
    __SIZE          //10
}

enum __E_SCRIBBLE_SURFACE
{
    WIDTH,  //0
    HEIGHT, //1
    FONTS,  //2
    LOCKED, //3
    __SIZE  //4
}

enum __E_SCRIBBLE_LINE
{
    X,          //0
    Y,          //1
    WIDTH,      //2
    HEIGHT,     //3
    LENGTH,     //4
    FIRST_CHAR, //5
    LAST_CHAR,  //6
    HALIGN,     //7
    WORDS,      //8
    __SIZE      //9
}

enum __E_SCRIBBLE_WORD
{
    X,              // 0
    Y,              // 1
    WIDTH,          // 2
    HEIGHT,         // 3
    VALIGN,         // 4
    STRING,         // 5
    INPUT_STRING,   // 6
    SPRITE,         // 7
    IMAGE,          // 8
    LENGTH,         // 9
    FONT,           //10
    COLOUR,         //11
    RAINBOW,        //12
    SHAKE,          //13
    WAVE,           //14
    NEXT_SEPARATOR, //15
    __SIZE          //16
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
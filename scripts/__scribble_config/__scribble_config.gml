//  The SCRIBBLE_FONT_ARRAY macro is used to define the various fonts that are loaded automatically on boot.
//  Leave this array empty if you don't want to load any fonts automatically at all.
//  This macro is an array of font definitions. Two kinds of font are supported:
//  
//  1) External fonts: <string>
//     These are defined using a string. The string refers to the name of two files that should be
//     included in the project. To use an external font, first define the font (as normal) in GMS2
//     and save the project. Navigate to the font's folder inside the project directory and find
//     the associated .yy and .png files. Add these two files as Included Files.
//     
//  2) Spritefonts: <string> or <subarray>
//     These can be defined either by using an array, or a string.
//     The array has three elements:
//       [ sprite name <string>, map string <string>, character separation <real> ]
//     The sprite's name (passed as a string) doubles as the font name for use in other Scribble
//     functions. If you would like to use a default value for "map string" or "character
//     separation", set the array element to <undefined>. If only a string is passed (rather than
//     an array) then default values are used for "map string" and "character separation".
//     
//     **N.B.** Your spritefonts must have the collision type "Precise per Frame"
//              Your spritefonts must not have "Separate Texture Page" switched on

#macro SCRIBBLE_FONT_ARRAY [ [ "sprFontMain", undefined, 0 ], ["sprFontSmall", "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.-;:_+-*/|#", 0] ]
#macro SCRIBBLE_FONT_DIRECTORY "Fonts/"

#macro SCRIBBLE_DEFAULT_FONT "sprFontMain"
#macro SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß«»"
#macro SCRIBBLE_DEFAULT_SPRITEFONT_SEPARATION 0
#macro SCRIBBLE_DEFAULT_SHADER shScribble

#macro SCRIBBLE_HASH_NEWLINE true
#macro SCRIBBLE_USE_INTERNAL_TIMER true
#macro SCRIBBLE_COMPATIBILITY_MODE false

#region -- Internal Definitions --

#macro __SCRIBBLE_VERSION "02.02.00"
#macro __SCRIBBLE_DATE    "2018/08/05"

#macro SCRIBBLE_VERTEX_FORMAT global.__scribble_vertex_format

#macro SCRIBBLE_MAX_HYPERLINKS   4 //Additionally change the constant in shScribble
#macro SCRIBBLE_MAX_SPRITE_SLOTS 4 //Additionally change the constant in shScribble

#macro __SCRIBBLE_NO_SPRITE -1

enum __E_SCRIBBLE_GLYPH {
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

enum __E_SCRIBBLE_HYPERLINK {
    NONE = -2,
    UNLINKED = -1
}

#endregion
//  Scribble v4.2.0
//  2019/03/30
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  
//  Intended for use with GMS2.2.1 and later

//Basic input and draw settings
#macro SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß"
#macro SCRIBBLE_ANIMATION_SPEED               0.02  //Speed of text animation effects
#macro SCRIBBLE_HASH_NEWLINE                  true  //Replaces hashes (#) with newlines (ASCII chr10) to emulate GMS1 behaviour
#macro SCRIBBLE_COLOURISE_SPRITES             true  //Whether to apply the text colour to non-animated sprites (animated sprites are always blended white)

//Default draw settings
#macro SCRIBBLE_DEFAULT_XSCALE            1
#macro SCRIBBLE_DEFAULT_YSCALE            1
#macro SCRIBBLE_DEFAULT_ANGLE             0
#macro SCRIBBLE_DEFAULT_BOX_HALIGN        fa_left
#macro SCRIBBLE_DEFAULT_BOX_VALIGN        fa_top
#macro SCRIBBLE_DEFAULT_STEP_SIZE         (delta_time/16667)
#macro SCRIBBLE_DEFAULT_PREMULTIPLY_ALPHA false

//Typewriter mode constants
//Used as arguments for scribble_typewriter_in() and scribble_typewrite_out()
#macro SCRIBBLE_TYPEWRITER_WHOLE         0
#macro SCRIBBLE_TYPEWRITER_PER_CHARACTER 1
#macro SCRIBBLE_TYPEWRITER_PER_LINE      2

//Default animation settings
#macro SCRIBBLE_DEFAULT_WAVE_SIZE              4
#macro SCRIBBLE_DEFAULT_WAVE_FREQUENCY        50
#macro SCRIBBLE_DEFAULT_WAVE_SPEED            10
#macro SCRIBBLE_DEFAULT_SHAKE_SIZE             4
#macro SCRIBBLE_DEFAULT_SHAKE_SPEED           22
#macro SCRIBBLE_DEFAULT_RAINBOW_WEIGHT         0.5
#macro SCRIBBLE_DEFAULT_TYPEWRITER_SPEED       0.3
#macro SCRIBBLE_DEFAULT_TYPEWRITER_SMOOTHNESS  3
#macro SCRIBBLE_DEFAULT_TYPEWRITER_METHOD     SCRIBBLE_TYPEWRITER_PER_CHARACTER

//Advanced users only!
#macro SCRIBBLE_COMPATIBILITY_DRAW                false    //Forces Scribble functions to use GM's native draw_text() renderer. Turn this on if certain platforms are causing problems
#macro SCRIBBLE_FORCE_NO_SPRITE_ANIMATION         false    //Forces all sprite animations off. This can be useful for testing rendering without the Scribble shader set
#macro SCRIBBLE_CALL_STEP_IN_DRAW                 false    //Calls scribble_step() at the start of scribble_draw() for convenience. This isn't recommended - you should keep logic and drawing separate where possible in your code!
#macro SCRIBBLE_EMULATE_LEGACY_SPRITEFONT_SPACING true     //GMS2.2.1 made spritefonts much more spaced out for some reason. Turn this if you want to replicate pre-GMS2.2.1 spritefont behaviour
#macro SCRIBBLE_FIX_NEWLINES                      true     //The newline fix stops unexpected newline types from breaking the parser, but it can be a bit slow
#macro SCRIBBLE_SLANT_AMOUNT                      4
#macro SCRIBBLE_Z                                 0        //Z-value for vertex buffers
#macro SCRIBBLE_COMMAND_TAG_OPEN                  ord("[") //Character used to open a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_CLOSE                 ord("]") //Character used to close a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_ARGUMENT              ord(",") //Character used to delimit a command parameter inside a command tag. First 127 ASCII chars only
#macro SCRIBBLE_MAX_FLAGS                         4        //Change MAX_FLAGS in the shader if you change this value!
#macro SCRIBBLE_MAX_DATA_FIELDS                   6        //Change MAX_DATA_FIELDS in the shader if you change this value!
#macro SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE        200      //If the glyph range (min index to max index) exceeds this number, a font's glyphs will be indexed using a ds_map
#macro SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES        0.50     //Fraction (0 -> 1). If the number of holes exceeds this proportion, a font's glyphs will be indexed using a ds_map

//Glyph property constants
//Used as arguments for scribble_set_glyph_property() and scribble_get_glyph_property()
#macro SCRIBBLE_GLYPH_X_OFFSET                    __E_SCRIBBLE_GLYPH.DX
#macro SCRIBBLE_GLYPH_Y_OFFSET                    __E_SCRIBBLE_GLYPH.DY
#macro SCRIBBLE_GLYPH_SEPARATION                  __E_SCRIBBLE_GLYPH.SHF

//scribble_get_box() constants
enum E_SCRIBBLE_BOX
{
    X0, Y0, //Top left corner
    X1, Y1, //Top right corner
    X2, Y2, //Bottom left corner
    X3, Y3  //Bottom right corner
}

#region -- Internal Definitions --

#macro __SCRIBBLE_VERSION "4.2.0"
#macro __SCRIBBLE_DATE    "2019/03/30"
#macro __SCRIBBLE_DEBUG   false

enum __E_SCRIBBLE_FONT
{
    NAME,           // 0
    TYPE,           // 1
    GLYPHS_MAP,     // 2
    GLYPHS_ARRAY,   // 3
    GLYPH_MIN,      // 4
    GLYPH_MAX,      // 5
    TEXTURE,        // 6
    SPACE_WIDTH,    // 7
    MAPSTRING,      // 8
    SEPARATION,     // 9
    __SIZE          //10
}

enum __E_SCRIBBLE_FONT_TYPE
{
    FONT,
    SPRITE
}

enum __E_SCRIBBLE_GLYPH
{
    CHAR,  // 0
    ORD,   // 1
    W,     // 2
    H,     // 3
    DX,    // 4
    DY,    // 5
    SHF,   // 6
    U0,    // 7
    V0,    // 8
    U1,    // 9
    V1,    //10
    __SIZE //11
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
    SCALE,          // 4
    SLANT,          // 5
    VALIGN,         // 6
    STRING,         // 7
    INPUT_STRING,   // 8
    SPRITE,         // 9
    IMAGE,          //10
    IMAGE_SPEED,    //11
    LENGTH,         //12
    FONT,           //13
    COLOUR,         //14
    FLAGS,          //15
    NEXT_SEPARATOR, //16
    __SIZE          //17
}

enum __E_SCRIBBLE_VERTEX_BUFFER
{
    VERTEX_BUFFER,
    TEXTURE,
    __SIZE
}

enum __E_SCRIBBLE
{
    __SECTION0,              // 0
    STRING,                  // 1
    DEFAULT_FONT,            // 2
    DEFAULT_COLOUR,          // 3
    DEFAULT_HALIGN,          // 4
    WIDTH_LIMIT,             // 5
    LINE_HEIGHT,             // 6
    
    __SECTION1,              // 7
    HALIGN,                  // 8
    VALIGN,                  // 9
    WIDTH,                   //10
    HEIGHT,                  //11
    LEFT,                    //12
    TOP,                     //13
    RIGHT,                   //14
    BOTTOM,                  //15
    LENGTH,                  //16
    LINES,                   //17
    WORDS,                   //18
    GLOBAL_INDEX,            //19
    
    __SECTION2,              //20
    TW_DIRECTION,            //21
    TW_SPEED,                //22
    TW_POSITION,             //23
    TW_METHOD,               //24
    TW_SMOOTHNESS,           //25
    CHAR_FADE_T,             //26
    LINE_FADE_T,             //27
    
    __SECTION3,              //28
    HAS_CALLED_STEP,         //29
    NO_STEP_COUNT,           //30
    DATA_FIELDS,             //31
    ANIMATION_TIME,          //32
    
    __SECTION4,              //33
    LINE_LIST,               //34
    VERTEX_BUFFER_LIST,      //35
    
    __SECTION5,              //36
    EV_CHARACTER_LIST,       //37
    EV_NAME_LIST,            //38
    EV_DATA_LIST,            //39
    EV_TRIGGERED_LIST,       //40
    EV_TRIGGERED_MAP,        //41
    EV_VALUE_MAP,            //42
    EV_CHANGED_MAP,          //43
    EV_PREVIOUS_MAP,         //44
    EV_DIFFERENT_MAP,        //45
    
    __SIZE                   //46
}

#macro __SCRIBBLE_TRY_SEQUENTIAL_GLYPH_INDEX true
#macro __SCRIBBLE_ON_DIRECTX ((os_type == os_windows) || (os_type == os_xboxone) || (os_type == os_uwp) || (os_type == os_win8native) || (os_type == os_winphone))
#macro __SCRIBBLE_ON_MOBILE ((os_type == os_ios) || (os_type == os_android))

#endregion
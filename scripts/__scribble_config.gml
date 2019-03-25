//  Scribble v3.2.3
//  2019/03/16
//  @jujuadams
//  With thanks to glitchroy and Rob van Saaze
//  
//  Backwards ported by @DragoniteSpam to 1.4.9999 so if it doesn't work yell at him

gml_pragma("global", "__scribble_config();");

globalvar SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING;
SCRIBBLE_DEFAULT_SPRITEFONT_MAPSTRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789,.-;:_+-*/\\'\"+'"'+"!?~^°<>|(){[]}%&=#@$ÄÖÜäöüß";

global.__scribble_init_complete = SCRIBBLE_INIT_START;

//scribble_get_box() constants
enum E_SCRIBBLE_BOX {
    X0, Y0, //Top left corner
    X1, Y1, //Top right corner
    X2, Y2, //Bottom left corner
    X3, Y3  //Bottom right corner
}

enum __E_SCRIBBLE_FONT {
    NAME,           // 0
    TYPE,           // 1
    GLYPHS_MAP,     // 2
    GLYPHS_ARRAY,   // 3
    GLYPH_MIN,      // 4
    GLYPH_MAX,      // 5
    TEXTURE_WIDTH,  // 6
    TEXTURE_HEIGHT, // 7
    SPACE_WIDTH,    // 8
    MAPSTRING,      // 9
    SEPARATION,     //10
    SPRITE,         //11
    SPRITE_X,       //12
    SPRITE_Y,       //13
    __SIZE          //14
}

enum __E_SCRIBBLE_GLYPH {
    CHAR,  // 0
    ORD,   // 1
    X,     // 2
    Y,     // 3
    W,     // 4
    H,     // 5
    DX,    // 6
    DY,    // 7
    SHF,   // 8
    U0,    // 9
    V0,    //10
    U1,    //11
    V1,    //12
    __SIZE //13
}

enum __E_SCRIBBLE_SURFACE {
    WIDTH,  //0
    HEIGHT, //1
    FONTS,  //2
    LOCKED, //3
    __SIZE  //4
}

enum __E_SCRIBBLE_LINE {
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

enum __E_SCRIBBLE_WORD {
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
    FLAGS,          //12
    NEXT_SEPARATOR, //13
    __SIZE          //14
}

enum __E_SCRIBBLE_VERTEX_BUFFER {
    VERTEX_BUFFER,
    SPRITE,
    TEXTURE,
    __SIZE
}

enum __E_SCRIBBLE {
    __SECTION0,           // 0
    STRING,               // 1
    DEFAULT_FONT,         // 2
    DEFAULT_COLOUR,       // 3
    DEFAULT_HALIGN,       // 4
    WIDTH_LIMIT,          // 5
    LINE_HEIGHT,          // 6
    
    __SECTION1,           // 7
    HALIGN,               // 8
    VALIGN,               // 9
    WIDTH,                //10
    HEIGHT,               //11
    LEFT,                 //12
    TOP,                  //13
    RIGHT,                //14
    BOTTOM,               //15
    LENGTH,               //16
    LINES,                //17
    WORDS,                //18
    
    __SECTION2,           //19
    TW_DIRECTION,         //20
    TW_SPEED,             //21
    TW_POSITION,          //22
    TW_METHOD,            //23
    TW_SMOOTHNESS,        //24
    CHAR_FADE_T,          //25
    LINE_FADE_T,          //26
    
    __SECTION3,           //27
    DATA_FIELDS,          //28
    ANIMATION_TIME,       //29
    
    __SECTION4,           //30
    LINE_LIST,            //31
    VERTEX_BUFFER_LIST,   //32
    
    __SECTION5,           //33
    EV_CHARACTER_LIST,    //34
    EV_NAME_LIST,         //35
    EV_DATA_LIST,         //36
    EV_TRIGGERED_LIST,    //37
    EV_TRIGGERED_MAP,     //38
    EV_VALUE_MAP,         //39
    EV_CHANGED_MAP,       //49
    EV_PREVIOUS_MAP,      //41
    EV_DIFFERENT_MAP,     //42
    
    __SIZE                //43
}

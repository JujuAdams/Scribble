enum __SCRIBBLE_GEN_GLYPH
{
    ORD,              // 0  \   Can be negative, see below
    BIDI,             // 1   |
                      //     |
    X,                // 2   |
    Y,                // 3   |
    WIDTH,            // 4   |
    HEIGHT,           // 5   |
    FONT_HEIGHT,      // 6   |
    SEPARATION,       // 7   | This group of enums must not change order or be split
    SCALE,            // 8   |
                      //     |
    TEXTURE,          // 9   |
    QUAD_U0,          //10   |
    QUAD_V0,          //11   |
    QUAD_U1,          //12   |
    QUAD_V1,          //13   |
                      //     |
    MSDF_PXRANGE,     //14  /
    
    CONTROL_COUNT,    //15
    ANIMATION_INDEX,  //16
                      
    SPRITE_INDEX,     //17  \
    IMAGE_INDEX,      //18   | Only used for sprites
    IMAGE_SPEED,      //19  /
                      
    __SIZE,           //20
}

enum __SCRIBBLE_GEN_VBUFF_POS
{
    QUAD_L, //0
    QUAD_T, //1
    QUAD_R, //2
    QUAD_B, //3
    __SIZE, //4
}

enum __SCRIBBLE_GEN_CONTROL_TYPE
{
    EVENT,
    HALIGN,
    COLOUR,
    EFFECT,
    CYCLE
}

//These can be used for ORD
#macro  __SCRIBBLE_GLYPH_SPRITE   -1
#macro  __SCRIBBLE_GLYPH_SURFACE  -2

enum __SCRIBBLE_GEN_CONTROL
{
    TYPE,   //0
    DATA,   //1
    __SIZE, //2
}

enum __SCRIBBLE_GEN_WORD
{
    BIDI_RAW,    //0
    BIDI,        //1
    GLYPH_START, //2
    GLYPH_END,   //3
    WIDTH,       //4
    HEIGHT,      //5
    __SIZE,      //6
}

enum __SCRIBBLE_GEN_STRETCH
{
    WORD_START, //0
    WORD_END,   //1
    BIDI,       //2
    __SIZE,
}

enum __SCRIBBLE_GEN_LINE
{
    Y,                  //0
    WORD_START,         //1
    WORD_END,           //2
    WIDTH,              //3
    HEIGHT,             //4
    HALIGN,             //5
    STARTS_MANUAL_PAGE, //6
    __SIZE,             //7
}

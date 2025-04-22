// Feather disable all

////////////////////////////////////////////////////////////////////////////
//                                                                        //
// You're welcome to use any of the following macros in your game but ... //
//                                                                        //
//                       DO NOT EDIT THIS SCRIPT                          //
//                       Bad things might happen.                         //
//                                                                        //
//    Customisation options can be found in the Configuration scripts.    //
//                                                                        //
////////////////////////////////////////////////////////////////////////////

#macro SCRIBBLE_VERSION  "9.5.0"
#macro SCRIBBLE_DATE     "2025-04-22"

#macro SCRIBBLE_NO_PREPROCESS  __scribble_no_preprocessing

enum SCRIBBLE_EASE
{
    NONE,     // 0
    LINEAR,   // 1
    QUAD,     // 2
    CUBIC,    // 3
    QUART,    // 4
    QUINT,    // 5
    SINE,     // 6
    EXPO,     // 7
    CIRC,     // 8
    BACK,     // 9
    ELASTIC,  //10
    BOUNCE,   //11
    CUSTOM_1, //12
    CUSTOM_2, //13
    CUSTOM_3, //14
    __SIZE    //15
}

enum SCRIBBLE_OUTLINE
{
    NO_OUTLINE,      // 0
    FOUR_DIR,        // 1
    EIGHT_DIR,       // 2
    EIGHT_DIR_THICK, // 3
}

enum SCRIBBLE_GLYPH
{
    CHARACTER,   // 0
                 //  
    UNICODE,     // 1
    BIDI,        // 2
                 //  
    X_OFFSET,    // 3
    Y_OFFSET,    // 4
    WIDTH,       // 5
    HEIGHT,      // 6
    FONT_HEIGHT, // 7
    SEPARATION,  // 8
    LEFT_OFFSET, // 9
    FONT_SCALE,  //10
                 //  
    MATERIAL,    //11
    U0,          //12
    U1,          //13
    V0,          //14
    V1,          //15
                 //  
    __SIZE       //17
}
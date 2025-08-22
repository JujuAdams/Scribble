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

#macro SCRIBBLE_VERSION  "9.6.5 beta"
#macro SCRIBBLE_DATE     "2025-08-21"

#macro SCRIBBLE_NO_PREPROCESS  __scribble_no_preprocessing

#macro SCRIBBLE_RAINBOW_CYCLE         "rainbow"
#macro SCRIBBLE_CYCLE_TEXTURE_WIDTH   256
#macro SCRIBBLE_CYCLE_TEXTURE_HEIGHT  256 //Tied to constant in vertex shader

#macro SCRIBBLE_EASE_NONE       0
#macro SCRIBBLE_EASE_LINEAR     1
#macro SCRIBBLE_EASE_QUAD       2
#macro SCRIBBLE_EASE_CUBIC      3
#macro SCRIBBLE_EASE_QUART      4
#macro SCRIBBLE_EASE_QUINT      5
#macro SCRIBBLE_EASE_SINE       6
#macro SCRIBBLE_EASE_EXPO       7
#macro SCRIBBLE_EASE_CIRC       8
#macro SCRIBBLE_EASE_BACK       9
#macro SCRIBBLE_EASE_ELASTIC   10
#macro SCRIBBLE_EASE_BOUNCE    11
#macro SCRIBBLE_EASE_CUSTOM_1  12
#macro SCRIBBLE_EASE_CUSTOM_2  13
#macro SCRIBBLE_EASE_CUSTOM_3  14

#macro SCRIBBLE_EASE_COUNT  15

enum SCRIBBLE_OUTLINE
{
    NO_OUTLINE,      // 0
    FOUR_DIR,        // 1
    EIGHT_DIR,       // 2
    EIGHT_DIR_THICK, // 3
}

enum SCRIBBLE_GLYPH
{
    CHARACTER,    // 0
                  //  
    UNICODE,      // 1
    BIDI,         // 2
                  //  
    X_OFFSET,     // 3
    Y_OFFSET,     // 4
    WIDTH,        // 5
    HEIGHT,       // 6
    FONT_HEIGHT,  // 7
    SEPARATION,   // 8
    LEFT_OFFSET,  // 9
    FONT_SCALE,   //10
                  //  
    MATERIAL,     //11
    U0,           //12
    U1,           //13
    V0,           //14
    V1,           //15
    TEXELS_VALID, //16
                  //  
    __SIZE        //17
}
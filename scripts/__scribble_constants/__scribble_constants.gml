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
#macro SCRIBBLE_RUNNING_FROM_IDE  (GM_build_type == "run")

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

#macro SCRIBBLE_OUTLINE_NONE             0
#macro SCRIBBLE_OUTLINE_FOUR_DIR         1
#macro SCRIBBLE_OUTLINE_EIGHT_DIR        2
#macro SCRIBBLE_OUTLINE_EIGHT_DIR_THICK  3

#macro SCRIBBLE_REVEAL_PER_CHAR  0
#macro SCRIBBLE_REVEAL_PER_WORD  1
#macro SCRIBBLE_REVEAL_PER_LINE  2

#macro SCRIBBLE_GLYPH_BIDI          __SCRIBBLE_GLYPH_PROPR_BIDI
#macro SCRIBBLE_GLYPH_X_OFFSET      __SCRIBBLE_GLYPH_PROPR_X_OFFSET
#macro SCRIBBLE_GLYPH_Y_OFFSET      __SCRIBBLE_GLYPH_PROPR_Y_OFFSET
#macro SCRIBBLE_GLYPH_WIDTH         __SCRIBBLE_GLYPH_PROPR_WIDTH
#macro SCRIBBLE_GLYPH_HEIGHT        __SCRIBBLE_GLYPH_PROPR_HEIGHT
#macro SCRIBBLE_GLYPH_FONT_HEIGHT   __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT
#macro SCRIBBLE_GLYPH_SEPARATION    __SCRIBBLE_GLYPH_PROPR_SEPARATION
#macro SCRIBBLE_GLYPH_LEFT_OFFSET   __SCRIBBLE_GLYPH_PROPR_LEFT_OFFSET
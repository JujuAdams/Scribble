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

#macro SCRIBBLE_VERSION  "9.6.6"
#macro SCRIBBLE_DATE     "2025-09-04"

#macro SCRIBBLE_RUNNING_FROM_IDE  (GM_build_type == "run")

#macro SCRIBBLE_RAINBOW_CYCLE         "rainbow"
#macro SCRIBBLE_CYCLE_TEXTURE_WIDTH   256
#macro SCRIBBLE_CYCLE_TEXTURE_HEIGHT  256 //Tied to constant in vertex shader

#macro SCRIBBLE_EASE_NONE      0
#macro SCRIBBLE_EASE_LINEAR    1
#macro SCRIBBLE_EASE_QUAD      2
#macro SCRIBBLE_EASE_CUBIC     3
#macro SCRIBBLE_EASE_QUART     4
#macro SCRIBBLE_EASE_QUINT     5
#macro SCRIBBLE_EASE_SINE      6
#macro SCRIBBLE_EASE_EXPO      7
#macro SCRIBBLE_EASE_CIRC      8
#macro SCRIBBLE_EASE_BACK      9
#macro SCRIBBLE_EASE_ELASTIC  10
#macro SCRIBBLE_EASE_BOUNCE   11

#macro SCRIBBLE_OUTLINE_NONE             0
#macro SCRIBBLE_OUTLINE_FOUR_DIR         1
#macro SCRIBBLE_OUTLINE_EIGHT_DIR        2
#macro SCRIBBLE_OUTLINE_EIGHT_DIR_THICK  3

#macro SCRIBBLE_REVEAL_PER_CHAR  0
#macro SCRIBBLE_REVEAL_PER_WORD  1
#macro SCRIBBLE_REVEAL_PER_LINE  2

#macro SCRIBBLE_SKIP_TO_EVENT  0
#macro SCRIBBLE_SKIP_TO_DELAY  1
#macro SCRIBBLE_SKIP_TO_PAUSE  2
#macro SCRIBBLE_SKIP_TO_BLOCK  3
#macro SCRIBBLE_SKIP_TO_PAGE   4
#macro SCRIBBLE_SKIP_TO_END    5

#macro SCRIBBLE_TYPIST_STOPPED   0
#macro SCRIBBLE_TYPIST_RUNNING   1
#macro SCRIBBLE_TYPIST_PAUSED    2
#macro SCRIBBLE_TYPIST_DELAYED   3
#macro SCRIBBLE_TYPIST_FINISHED  4

#macro SCRIBBLE_GLYPH_BIDI         __SCRIBBLE_GLYPH_PROPR_BIDI
#macro SCRIBBLE_GLYPH_X_OFFSET     __SCRIBBLE_GLYPH_PROPR_X_OFFSET
#macro SCRIBBLE_GLYPH_Y_OFFSET     __SCRIBBLE_GLYPH_PROPR_Y_OFFSET
#macro SCRIBBLE_GLYPH_WIDTH        __SCRIBBLE_GLYPH_PROPR_WIDTH
#macro SCRIBBLE_GLYPH_HEIGHT       __SCRIBBLE_GLYPH_PROPR_HEIGHT
#macro SCRIBBLE_GLYPH_FONT_HEIGHT  __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT
#macro SCRIBBLE_GLYPH_SEPARATION   __SCRIBBLE_GLYPH_PROPR_SEPARATION
#macro SCRIBBLE_GLYPH_LEFT_OFFSET  __SCRIBBLE_GLYPH_PROPR_LEFT_OFFSET

#macro SCRIBBLE_LAYOUT_NONE           0 //No layout logic is applied
#macro SCRIBBLE_LAYOUT_WRAP           1 //Text is wrapped with no other behaviour. This mode ignores the maximum height
#macro SCRIBBLE_LAYOUT_TRIM           2 //Text is wrapped. Any text that overflows the bottom is trimmed
#macro SCRIBBLE_LAYOUT_TRIM_ELLIPSIS  3 //Text is wrapped. Any text that overflows the bottom is trimmed with an ellipsis
#macro SCRIBBLE_LAYOUT_SCALE          4 //Text is shrunk down using a straight-forward scaling operation
#macro SCRIBBLE_LAYOUT_FIT            5 //Text is dynamically shrunk and reflowed down until it all fits into the max size
#macro SCRIBBLE_LAYOUT_PAGINATE       6 //Text that overflows is placed onto a new page

#macro SCRIBBLE_UNICODE_TAB          0x0009
#macro SCRIBBLE_UNICODE_NEWLINE      0x000A
#macro SCRIBBLE_UNICODE_SUB          0x001A
#macro SCRIBBLE_UNICODE_SPACE        0x0020
#macro SCRIBBLE_UNICODE_DQUOTE       0x0022
#macro SCRIBBLE_UNICODE_APOSTROPHE   0x0027
#macro SCRIBBLE_UNICODE_HYPHEN       0x002D
#macro SCRIBBLE_UNICODE_SEMICOLON    0x003B
#macro SCRIBBLE_UNICODE_GRAVE        0x0060
#macro SCRIBBLE_UNICODE_NBSP         0x00A0
#macro SCRIBBLE_UNICODE_ZWSP         0x200B
#macro SCRIBBLE_UNICODE_L2R          0x200E
#macro SCRIBBLE_UNICODE_R2L          0x200F
#macro SCRIBBLE_UNICODE_EN_DASH      0x2013
#macro SCRIBBLE_UNICODE_EM_DASH      0x2014
#macro SCRIBBLE_UNICODE_BAR          0x2015
#macro SCRIBBLE_UNICODE_QUOTE_ST     0x2018
#macro SCRIBBLE_UNICODE_QUOTE_END    0x2019
#macro SCRIBBLE_UNICODE_DQUOTE_ST    0x201C
#macro SCRIBBLE_UNICODE_DQUOTE_END   0x201D
#macro SCRIBBLE_UNICODE_DQUOTE_LOW   0x201E
#macro SCRIBBLE_UNICODE_DQUOTE_HI    0x201F
#macro SCRIBBLE_UNICODE_ELLIPSIS     0x2026
#macro SCRIBBLE_UNICODE_GREEK_QMARK  0x037E
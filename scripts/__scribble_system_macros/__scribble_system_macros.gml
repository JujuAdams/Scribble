#macro __SCRIBBLE_GLYPH_LAYOUT_UNICODE   0
#macro __SCRIBBLE_GLYPH_LAYOUT_LEFT      1
#macro __SCRIBBLE_GLYPH_LAYOUT_TOP       2
#macro __SCRIBBLE_GLYPH_LAYOUT_RIGHT     3
#macro __SCRIBBLE_GLYPH_LAYOUT_BOTTOM    4
#macro __SCRIBBLE_GLYPH_LAYOUT_Y_OFFSET  5
#macro __SCRIBBLE_GLYPH_LAYOUT_SIZE      6

#macro __SCRIBBLE_RENDER_RASTER               0
#macro __SCRIBBLE_RENDER_RASTER_WITH_EFFECTS  1
#macro __SCRIBBLE_RENDER_SDF                  2

#macro __SCRIBBLE_ANIM_WAVE_SIZE        0
#macro __SCRIBBLE_ANIM_WAVE_FREQ        1
#macro __SCRIBBLE_ANIM_WAVE_SPEED       2
#macro __SCRIBBLE_ANIM_SHAKE_SIZE       3
#macro __SCRIBBLE_ANIM_SHAKE_SPEED      4
#macro __SCRIBBLE_ANIM_WOBBLE_ANGLE     5
#macro __SCRIBBLE_ANIM_WOBBLE_FREQ      6
#macro __SCRIBBLE_ANIM_PULSE_SCALE      7
#macro __SCRIBBLE_ANIM_PULSE_SPEED      8
#macro __SCRIBBLE_ANIM_WHEEL_SIZE       9
#macro __SCRIBBLE_ANIM_WHEEL_FREQ      10
#macro __SCRIBBLE_ANIM_WHEEL_SPEED     11
#macro __SCRIBBLE_ANIM_JITTER_MINIMUM  12
#macro __SCRIBBLE_ANIM_JITTER_MAXIMUM  13
#macro __SCRIBBLE_ANIM_JITTER_SPEED    14
#macro __SCRIBBLE_ANIM_SLANT_GRADIENT  15
#macro __SCRIBBLE_ANIM_SIZE            16

#macro __SCRIBBLE_GEN_GLYPH_UNICODE           0 // } - Can be negative if a glyph is sprite/surface/texture
#macro __SCRIBBLE_GEN_GLYPH_BIDI              1 // }
#macro __SCRIBBLE_GEN_GLYPH_X                 2 // }
#macro __SCRIBBLE_GEN_GLYPH_Y                 3 // }
#macro __SCRIBBLE_GEN_GLYPH_WIDTH             4 // }
#macro __SCRIBBLE_GEN_GLYPH_HEIGHT            5 // }
#macro __SCRIBBLE_GEN_GLYPH_FONT_HEIGHT       6 // }
#macro __SCRIBBLE_GEN_GLYPH_SEPARATION        7 // } This group of enum elements must not change order or be split
#macro __SCRIBBLE_GEN_GLYPH_LEFT_OFFSET       8 // } Be careful of ordering!
#macro __SCRIBBLE_GEN_GLYPH_SCALE             9 // }
#macro __SCRIBBLE_GEN_GLYPH_MATERIAL         10 // }
#macro __SCRIBBLE_GEN_GLYPH_QUAD_U0          11 // }
#macro __SCRIBBLE_GEN_GLYPH_QUAD_U1          12 // }
#macro __SCRIBBLE_GEN_GLYPH_QUAD_V0          13 // }
#macro __SCRIBBLE_GEN_GLYPH_QUAD_V1          14 // }
#macro __SCRIBBLE_GEN_GLYPH_CONTROL_COUNT    15 //
#macro __SCRIBBLE_GEN_GLYPH_ANIMATION_INDEX  16 //
#macro __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX     17 //
#macro __SCRIBBLE_GEN_GLYPH_SPRITE_INDEX     18 // }
#macro __SCRIBBLE_GEN_GLYPH_IMAGE_INDEX      19 // } Only used for sprites
#macro __SCRIBBLE_GEN_GLYPH_IMAGE_SPEED      20 // }
#macro __SCRIBBLE_GEN_GLYPH_SPRITE_ONCE      21 // }
#macro __SCRIBBLE_GEN_GLYPH_SIZE             22 //

#macro __SCRIBBLE_GEN_VBUFF_POS_QUAD_L  0
#macro __SCRIBBLE_GEN_VBUFF_POS_QUAD_T  1
#macro __SCRIBBLE_GEN_VBUFF_POS_QUAD_R  2
#macro __SCRIBBLE_GEN_VBUFF_POS_QUAD_B  3
#macro __SCRIBBLE_GEN_VBUFF_POS_SIZE    4

#macro __SCRIBBLE_GEN_CONTROL_TYPE_EVENT         0
#macro __SCRIBBLE_GEN_CONTROL_TYPE_HALIGN        1
#macro __SCRIBBLE_GEN_CONTROL_TYPE_COLOUR        2
#macro __SCRIBBLE_GEN_CONTROL_TYPE_EFFECT        3
#macro __SCRIBBLE_GEN_CONTROL_TYPE_CYCLE         4
#macro __SCRIBBLE_GEN_CONTROL_TYPE_REGION        5
#macro __SCRIBBLE_GEN_CONTROL_TYPE_FONT          6
#macro __SCRIBBLE_GEN_CONTROL_TYPE_INDENT_START  7
#macro __SCRIBBLE_GEN_CONTROL_TYPE_INDENT_STOP   8
#macro __SCRIBBLE_GEN_CONTROL_TYPE_UNDERLINE     9
#macro __SCRIBBLE_GEN_CONTROL_TYPE_STRIKE       10

//These can be used for ORD
#macro __SCRIBBLE_GLYPH_REPL_SPRITE   -1
#macro __SCRIBBLE_GLYPH_REPL_SURFACE  -2
#macro __SCRIBBLE_GLYPH_REPL_TEXTURE  -3

#macro __SCRIBBLE_GEN_CONTROL_TYPE  0
#macro __SCRIBBLE_GEN_CONTROL_DATA  1
#macro __SCRIBBLE_GEN_CONTROL_SIZE  2

#macro __SCRIBBLE_GEN_WORD_BIDI_RAW     0
#macro __SCRIBBLE_GEN_WORD_BIDI         1
#macro __SCRIBBLE_GEN_WORD_GLYPH_START  2
#macro __SCRIBBLE_GEN_WORD_GLYPH_END    3
#macro __SCRIBBLE_GEN_WORD_WIDTH        4
#macro __SCRIBBLE_GEN_WORD_HEIGHT       5
#macro __SCRIBBLE_GEN_WORD_SIZE         6

#macro __SCRIBBLE_GEN_STRETCH_WORD_START  0
#macro __SCRIBBLE_GEN_STRETCH_WORD_END    1
#macro __SCRIBBLE_GEN_STRETCH_BIDI        2
#macro __SCRIBBLE_GEN_STRETCH_SIZE        3

#macro __SCRIBBLE_ON_DIRECTX           ((os_type == os_windows) || (os_type == os_xboxone) || (os_type == os_xboxseriesxs) || (os_type == os_uwp) || (os_type == os_win8native) || (os_type == os_winphone) || (os_type == os_operagx))
#macro __SCRIBBLE_ON_MOBILE            ((os_type == os_ios) || (os_type == os_android) || (os_type == os_tvos))
#macro __SCRIBBLE_ON_WEB               (os_browser != browser_not_a_browser)
#macro __SCRIBBLE_ON_OPENGL            (!__SCRIBBLE_ON_DIRECTX || __SCRIBBLE_ON_WEB)
#macro __SCRIBBLE_FIX_ARGB             (__SCRIBBLE_ON_OPENGL && (os_type != os_switch))
#macro __SCRIBBLE_EXPECTED_FRAME_TIME  (0.95*game_get_speed(gamespeed_microseconds)/1000) //Uses to prevent the autotype from advancing if a draw call is made multiple times a frame to the same text element
#macro __SCRIBBLE_PIN_LEFT             3
#macro __SCRIBBLE_PIN_CENTRE           4
#macro __SCRIBBLE_PIN_RIGHT            5
#macro __SCRIBBLE_FA_JUSTIFY           6
#macro __SCRIBBLE_PIN_TOP              3
#macro __SCRIBBLE_PIN_MIDDLE           4
#macro __SCRIBBLE_PIN_BOTTOM           5
#macro __SCRIBBLE_HEAD_COUNT           3

#macro __SCRIBBLE_PAUSE_COMMAND_TAG                  "pause"
#macro __SCRIBBLE_DELAY_COMMAND_TAG                  "delay"
#macro __SCRIBBLE_SYNC_COMMAND_TAG                   "sync"
#macro __SCRIBBLE_SPEED_COMMAND_TAG                  "speed"
#macro __SCRIBBLE_UNSPEED_COMMAND_TAG                "/speed"
#macro __SCRIBBLE_AUDIO_COMMAND_TAG                  "__scribble_audio_playback__"
#macro __SCRIBBLE_TYPIST_SOUND_COMMAND_TAG           "__scribble_typist_sound__"
#macro __SCRIBBLE_TYPIST_SOUND_PER_CHAR_COMMAND_TAG  "__scribble_typist_sound_per_char__"

#macro __SCRIBBLE_DEVANAGARI_OFFSET  0xFFFF //This won't work for any other value

#macro __SCRIBBLE_DEBUG       false
#macro __SCRIBBLE_VERBOSE_GC  false

#macro __SCRIBBLE_EASE_COUNT  12
#macro __SCRIBBLE_VERY_BIG    999999

#macro __SCRIBBLE_FLAG_GRAPHIC      0
#macro __SCRIBBLE_FLAG_ANIM_SPRITE  1
#macro __SCRIBBLE_FLAG_WAVE         2
#macro __SCRIBBLE_FLAG_SHAKE        3
#macro __SCRIBBLE_FLAG_WOBBLE       4
#macro __SCRIBBLE_FLAG_PULSE        5
#macro __SCRIBBLE_FLAG_WHEEL        6
#macro __SCRIBBLE_FLAG_CYCLE        7
#macro __SCRIBBLE_FLAG_JITTER       8
#macro __SCRIBBLE_FLAG_SLANT        9

#macro __SCRIBBLE_GLYPH_PROPR_CHARACTER      0
#macro __SCRIBBLE_GLYPH_PROPR_UNICODE        1
#macro __SCRIBBLE_GLYPH_PROPR_BIDI           2
#macro __SCRIBBLE_GLYPH_PROPR_X_OFFSET       3
#macro __SCRIBBLE_GLYPH_PROPR_Y_OFFSET       4
#macro __SCRIBBLE_GLYPH_PROPR_WIDTH          5
#macro __SCRIBBLE_GLYPH_PROPR_HEIGHT         6
#macro __SCRIBBLE_GLYPH_PROPR_FONT_HEIGHT    7
#macro __SCRIBBLE_GLYPH_PROPR_SEPARATION     8
#macro __SCRIBBLE_GLYPH_PROPR_LEFT_OFFSET    9
#macro __SCRIBBLE_GLYPH_PROPR_FONT_SCALE    10
#macro __SCRIBBLE_GLYPH_PROPR_MATERIAL      11
#macro __SCRIBBLE_GLYPH_PROPR_U0            12
#macro __SCRIBBLE_GLYPH_PROPR_U1            13
#macro __SCRIBBLE_GLYPH_PROPR_V0            14
#macro __SCRIBBLE_GLYPH_PROPR_V1            15
#macro __SCRIBBLE_GLYPH_PROPR_TEXELS_VALID  16

#macro __SCRIBBLE_GLYPH_PROPR_COUNT  17

#macro __SCRIBBLE_TAG_COLOR         0
#macro __SCRIBBLE_TAG_EFFECT        1
#macro __SCRIBBLE_TAG_EFFECT_UNSET  2
#macro __SCRIBBLE_TAG_EVENT         3
#macro __SCRIBBLE_TAG_MACRO         4

#macro __SCRIBBLE_ELEMENT_SELFCHECK_MIN  1.0 //in seconds
#macro __SCRIBBLE_ELEMENT_SELFCHECK_MAX  2.0 //in seconds
#macro __SCRIBBLE_CACHE_TIMEOUT          10
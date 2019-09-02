/// Scribble's macros, used to customise and control behaviour throughout the library.
/// 
/// 
/// Scribble v5.x.x
/// 2019/09/02
/// @jujuadams
/// With thanks to glitchroy, Mark Turner, Rob van Saaze, DragoniteSpam, and sp202
/// 
/// For use with GMS2.2.2 and later

#macro SCRIBBLE_HASH_NEWLINE       true  //Replaces hashes (#) with newlines (ASCII chr10) to emulate GMS1 behaviour
#macro SCRIBBLE_COLOURISE_SPRITES  true  //Whether to apply the text colour to non-animated sprites (animated sprites are always blended white)
#macro SCRIBBLE_VERBOSE            false //Enables verbose console output to aid with debugging.

#region Default parameters

//Box alignment
#macro SCRIBBLE_DEFAULT_BOX_HALIGN  fa_left  //The default alignment of the textbox. fa_left places the left-hand side of the box at the draw coordinate when using scribble_draw().
#macro SCRIBBLE_DEFAULT_BOX_VALIGN  fa_top   //The default alignment of the textbox. fa_top places the top of the box at the draw coordinate when using scribble_draw().

//Text wrapping
#macro SCRIBBLE_DEFAULT_LINE_MIN_HEIGHT  -1       //The default minimum height of each line of text. Set to a negative value to use the height of a space character of the default font.
#macro SCRIBBLE_DEFAULT_MAX_WIDTH        -1       //The default maximum horizontal size of the textbox. Set to a negative value for no limit.

//Transform
#macro SCRIBBLE_DEFAULT_XSCALE  1        //The default x-scale of the textbox.
#macro SCRIBBLE_DEFAULT_YSCALE  1        //The default y-scale of the textbox.
#macro SCRIBBLE_DEFAULT_ANGLE   0        //The default rotation of the textbox.

//Colour blending
#macro SCRIBBLE_DEFAULT_BLEND_COLOUR  c_white  //The default blend colour.
#macro SCRIBBLE_DEFAULT_ALPHA         1.0      //The default alpha.

//Typewriter
#macro SCRIBBLE_DEFAULT_TYPEWRITER_SPEED       0.3                               //The default speed of the typewriter effect, in characters/lines per frame.
#macro SCRIBBLE_DEFAULT_TYPEWRITER_SMOOTHNESS  3                                 //The default smoothhness of the typewriter effect. A value of "0" disables smooth fading.
#macro SCRIBBLE_DEFAULT_TYPEWRITER_METHOD      SCRIBBLE_TYPEWRITER_PER_CHARACTER //The default typewriter effect method. See scribble_set_typewriter() for more details

#macro SCRIBBLE_DEFAULT_TEXT_COLOUR   c_white  //The default (vertex) colour of text.
#macro SCRIBBLE_DEFAULT_SPRITE_SPEED  0.1      //The default animation speed for sprites inserted into text.

#endregion

#region Advanced stuff

#macro SCRIBBLE_STEP_SIZE                  (delta_time/game_get_speed(gamespeed_microseconds)) //The animation step size. Using delta_time ensures that animations are smooth at all framerates
#macro SCRIBBLE_FORCE_NO_SPRITE_ANIMATION  false //Forces all sprite animations off. This can be useful for testing rendering without the Scribble shader set
#macro SCRIBBLE_SLANT_AMOUNT               0.24  //The x-axis displacement when using the [slant] tag
#macro SCRIBBLE_Z                          0     //The z-value for vertexes

#macro SCRIBBLE_DEFAULT_CACHE_GROUP        0     //The name of the default cache group. Real value and strings accepted.
#macro SCRIBBLE_CACHE_TIMEOUT              60000 //How long to wait before the cache automatically destroys a scribble data. Set to 0 (or less) to turn off automatic de-caching (you'll need to manually call scribble_free() instead)

#macro SCRIBBLE_COMMAND_TAG_OPEN      ord("[") //Character used to open a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_CLOSE     ord("]") //Character used to close a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_ARGUMENT  ord(",") //Character used to delimit a command parameter inside a command tag. First 127 ASCII chars only

//Normally, Scribble will try to sequentially store glyph data in an array for fast lookup.
//However, some font definitons may have disjointed character indexes (e.g. Chinese). Scribble will detect these fonts and use a ds_map instead for glyph data lookup
#macro SCRIBBLE_SEQUENTIAL_GLYPH_TRY        true
#macro SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE  300  //If the glyph range (min index to max index) exceeds this number, a font's glyphs will be indexed using a ds_map
#macro SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES  0.50 //Fraction (0 -> 1). If the number of holes exceeds this proportion, a font's glyphs will be indexed using a ds_map

//SCRIBBLE_MAX_FLAGS or SCRIBBLE_MAX_DATA_FIELDS must match the corresponding values in shader shScribble
#macro SCRIBBLE_MAX_FLAGS        4 //The maximum number of flags. "Flags" are boolean values that can be set per character, and are sent into shScribble to trigger animation effects etc.
#macro SCRIBBLE_MAX_DATA_FIELDS  7 //The maximum number of data fields. "Data fields" are misc 

#endregion
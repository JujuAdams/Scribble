//  Scribble v4.7.1
//  2019/05/23
//  @jujuadams
//  With thanks to glitchroy, Mark Turner, Rob van Saaze, and DragoniteSpam
//  
//  
//  For use with GMS2.2.2 and later

#region Global behaviours

#macro SCRIBBLE_HASH_NEWLINE          true  //Replaces hashes (#) with newlines (ASCII chr10) to emulate GMS1 behaviour
#macro SCRIBBLE_COLOURISE_SPRITES     true  //Whether to apply the text colour to non-animated sprites (animated sprites are always blended white)
#macro SCRIBBLE_VERBOSE               false //Enables verbose console output to aid with debugging. Turn off if all the console is getting too cluttered for you!
#macro SCRIBBLE_STEP_SIZE             (delta_time/game_get_speed(gamespeed_microseconds)) //Automatically delta times text effects (including typewriter). Set this macro to a variable to control the step size yourself
#macro SCRIBBLE_TEXT_LINE_VALIGN      fa_middle
#macro SCRIBBLE_DEFAULT_SPRITE_SPEED  1.0

#endregion

#region Miscellaneous advanced settings

#macro SCRIBBLE_FORCE_NO_SPRITE_ANIMATION  false    //Forces all sprite animations off. This can be useful for testing rendering without the Scribble shader set
#macro SCRIBBLE_FIX_NEWLINES               true     //The newline fix stops unexpected newline types from breaking the parser, but it can be a bit slow
#macro SCRIBBLE_SLANT_AMOUNT               4        //The x-axis displacement when using the [slant] tag
#macro SCRIBBLE_Z                          0        //The z-value for vertexes

#endregion

#region Sequential glyph indexing

//Normally, Scribble will try to sequentially store glyph data in an array for fast lookup.
//However, some font definitons may have disjointed character indexes (e.g. Chinese). Scribble will detect these fonts and use a ds_map instead for glyph data lookup
#macro SCRIBBLE_SEQUENTIAL_GLYPH_TRY        true
#macro SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE  200      //If the glyph range (min index to max index) exceeds this number, a font's glyphs will be indexed using a ds_map
#macro SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES  0.50     //Fraction (0 -> 1). If the number of holes exceeds this proportion, a font's glyphs will be indexed using a ds_map

#endregion

#region Command tag customisation

#macro SCRIBBLE_COMMAND_TAG_OPEN      ord("[") //Character used to open a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_CLOSE     ord("]") //Character used to close a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_ARGUMENT  ord(",") //Character used to delimit a command parameter inside a command tag. First 127 ASCII chars only

#endregion

#region Shader constants

//SCRIBBLE_MAX_FLAGS or SCRIBBLE_MAX_DATA_FIELDS must match the corresponding values in shader shScribble
#macro SCRIBBLE_MAX_FLAGS           6  //The maximum number of flags. "Flags" are boolean values that can be set per character, and are sent into shScribble to trigger animation effects etc.
#macro SCRIBBLE_MAX_DATA_FIELDS    11  //The maximum number of data fields. "Data fields" are misc 
#macro SCRIBBLE_MAX_LINES        1000  //Maximum number of lines in a textbox.

#endregion
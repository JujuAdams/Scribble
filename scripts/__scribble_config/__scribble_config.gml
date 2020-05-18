/// Scribble's macros, used to customise and control behaviour throughout the library.

#macro SCRIBBLE_HASH_NEWLINE                  true   //Replaces hashes (#) with newlines (ASCII chr10) to emulate GMS1's newline behaviour
#macro SCRIBBLE_COLOURISE_SPRITES             true   //Whether to apply the text colour to non-animated sprites (animated sprites are always blended white)
#macro SCRIBBLE_VERBOSE                       false  //Enables verbose console output to aid with debugging
#macro SCRIBBLE_ADD_SPRITE_ORIGINS            false  //Whether to use sprite origins. Setting this to <false> will vertically centre sprites on the line of text
#macro SCRIBBLE_SPRITEFONT_ALIGN_GLYPHS_LEFT  false  //Set to <true> to emulate GameMaker's native behaviour
#macro SCRIBBLE_MISSING_CHARACTER             "?"    //Used when a character is missing from a font

#region Default parameters

#macro SCRIBBLE_DEFAULT_TEXT_COLOUR     c_white  //The default (vertex) colour of text.
#macro SCRIBBLE_DEFAULT_HALIGN          fa_left
#macro SCRIBBLE_DEFAULT_SPRITE_SPEED    0.1      //The default animation speed for sprites inserted into text
#macro SCRIBBLE_DEFAULT_DELAY_DURATION  450      //Default duration of the [delay] command, in milliseconds

//In 6.0.1, the other default parameters have moved to scribble_draw_reset()

#endregion

#region Advanced stuff

#macro SCRIBBLE_WARNING_REINITIALIZE           true  //Controls whether an error is thrown when calling scribble_init() twice
#macro SCRIBBLE_WARNING_TEXTURE_PAGE           true  //Turns the Separate Texture Page warning for spritefonts on/off
#macro SCRIBBLE_WARNING_AUTOSCAN_YY_NOT_FOUND  true

#macro SCRIBBLE_STEP_SIZE                 (delta_time/game_get_speed(gamespeed_microseconds)) //The animation step size. The default command here uses delta_time ensures that animations are smooth at all framerates
#macro SCRIBBLE_SLANT_AMOUNT              0.24  //The x-axis displacement when using the [slant] tag
#macro SCRIBBLE_CREATE_GLYPH_LTRB_ARRAY   false //Outputs an array of glyph LTRB bounding boxes
#macro SCRIBBLE_CREATE_CHARACTER_ARRAY    false //Outputs an array of character codes

#macro SCRIBBLE_DEFAULT_CACHE_GROUP   0     //The name of the default cache group. Real value and strings accepted.
#macro SCRIBBLE_CACHE_TIMEOUT         15000 //How long to wait (in milliseconds) before the cache automatically destroys a text element. Set to 0 (or less) to turn off automatic de-caching (you'll need to manually call scribble_flush() instead)

#macro SCRIBBLE_COMMAND_TAG_OPEN      ord("[") //Character used to open a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_CLOSE     ord("]") //Character used to close a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_ARGUMENT  ord(",") //Character used to delimit a command parameter inside a command tag. First 127 ASCII chars only

//Normally, Scribble will try to sequentially store glyph data in an array for fast lookup.
//However, some font definitons may have disjointed character indexes (e.g. Chinese). Scribble will detect these fonts and use a ds_map instead for glyph data lookup
#macro SCRIBBLE_SEQUENTIAL_GLYPH_TRY        true
#macro SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE  300  //If the glyph range (min index to max index) exceeds this number, a font's glyphs will be indexed using a ds_map
#macro SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES  0.50 //Fraction (0 -> 1). If the number of holes exceeds this proportion, a font's glyphs will be indexed using a ds_map

#macro SCRIBBLE_MAX_LINES  1000  //Maximum number of lines in a textbox. Thise constant must match the corresponding values in shd_scribble

#endregion
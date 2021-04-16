/// Scribble's macros, used to customise and control behaviour throughout the library
///
/// N.B. You never need to run this script yourself! All of these macros are handled automatically when Scribble is compiled into your project

#macro SCRIBBLE_HASH_NEWLINE                  false  //Replaces hashes (#) with newlines (ASCII chr10) to emulate GMS1's newline behaviour
#macro SCRIBBLE_FIX_ESCAPED_NEWLINES          false  //Replaces newline literals ("\\n") with an actual newline ("\n")
#macro SCRIBBLE_COLORIZE_SPRITES              true   //Whether to use colourization for sprites. This includes [rainbow] and [cycle]
#macro SCRIBBLE_ADD_SPRITE_ORIGINS            false  //Whether to use sprite origins. Setting this to <false> will vertically centre sprites on the line of text
#macro SCRIBBLE_SPRITEFONT_ALIGN_GLYPHS_LEFT  false  //Set to <true> to trim off empty space on the left-hand side of a spritefont, even for non-proportional spritefonts. This is GameMaker's native behaviour
#macro SCRIBBLE_MISSING_CHARACTER             "?"    //Character to use when another character is missing from a font
#macro SCRIBBLE_BGR_COLOR_HEX_CODES           false  //Set to <true> to use GameMaker's #BBGGRR format for in-line hex code colors. <false> uses the industry standard #RRGGBB format
#macro SCRIBBLE_DEFAULT_SPRITE_SPEED          0.1    //The default animation speed for sprites inserted into text
#macro SCRIBBLE_DEFAULT_DELAY_DURATION        450    //Default duration of the [delay] command, in milliseconds
#macro SCRIBBLE_INCLUDED_FILES_SUBDIRECTORY   ""     //The directory to look in for font .yy files, relative to the root folder that Included Files are stored in
#macro SCRIBBLE_BOX_ALIGN_TO_PAGE             false  //Whether to use text element sizes (false) or page sizes (true)



#region Advanced Features

#macro SCRIBBLE_TICK_SIZE                 (delta_time / 16666) //Animation tick size per step. The default macro (delta_time / 16666) ensures that animations are smooth and consistent at all framerates
#macro SCRIBBLE_SLANT_AMOUNT              0.25      //The x-axis displacement when using the [slant] tag
#macro SCRIBBLE_DEFAULT_UNIQUE_ID         "default" //Default value to use for text element unique IDs. This is used when no unique ID is specified
#macro SCRIBBLE_VERBOSE                   false     //Enables verbose console output to aid with debugging
#macro SCRIBBLE_BEZIER_ACCURACY           20        //Controls how accurately text fits Beziér curves. Higher is more accurate but slower
#macro SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE  true      //Whether to trim off empty left-hand space when moving a word to a new line. This can cause issues with spritefonts in some situations
#macro SCRIBBLE_FIT_TO_BOX_ITERATIONS     3         //Number of iterations to fit text when using the .fit_to_box() method. Higher values are slower but more accurate
#macro SCRIBBLE_SAFELY_WRAP_TIME          true      //Whether to wrap the internal time value. If you look at an animation for roughly 4.5 minutes then 

#macro SCRIBBLE_COMMAND_TAG_OPEN          ord("[") //Character used to open a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_CLOSE         ord("]") //Character used to close a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_ARGUMENT      ord(",") //Character used to delimit a command parameter inside a command tag. First 127 ASCII chars only

#macro SCRIBBLE_CREATE_GLYPH_LTRB_ARRAY   false    //*DEPRECATED*   Outputs an array of glyph LTRB bounding boxes
#macro SCRIBBLE_CREATE_CHARACTER_ARRAY    false    //*DEPRECATED*   Outputs an array of character codes

#endregion



#region Warnings

//Various warning messages. Please do not turn these off unless you have to!
#macro SCRIBBLE_WARNING_TEXTURE_PAGE           true
#macro SCRIBBLE_WARNING_AUTOSCAN_YY_NOT_FOUND  true
#macro SCRIBBLE_WARNING_REDEFINITION           true

#endregion



#region Deprecated

//Macros in this region will be removed in the next major version update

#macro SCRIBBLE_SKIP_SPEED_THRESHOLD  99  //A typewriter speed greater than or equal to this value is considered "skipping" and won't wait for delays or pauses in text

#endregion
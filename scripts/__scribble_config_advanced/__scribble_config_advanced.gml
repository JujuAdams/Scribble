//Animation tick size per step. The default macro (delta_time / 16666) ensures that animations are smooth and consistent at all framerates
#macro SCRIBBLE_TICK_SIZE  (delta_time / 16666)

//Enables verbose console output to aid with debugging
#macro SCRIBBLE_VERBOSE  false

//Controls how accurately text fits Beziér curves. Higher is more accurate but slower
#macro SCRIBBLE_BEZIER_ACCURACY  20

//Whether to trim off empty left-hand space when moving a word to a new line. This can cause issues with spritefonts in some situations
#macro SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE  false

//Whether to pad extra space left-hand space when moving a word to a new line
#macro SCRIBBLE_NEWLINES_PAD_LEFT_SPACE  true

//Number of iterations to fit text when using the .layout_fit() method. Higher values are slower but more accurate
#macro SCRIBBLE_FIT_TO_BOX_ITERATIONS  7

//Whether to wrap the internal time value
//This can lead to unsightly "jumps" in an animation but is better than things not working at all
#macro SCRIBBLE_SAFELY_WRAP_TIME  true

//Disables [pause] events immediately before pagebreaks, though only if there are no other events between the pause and the pagebreak
#macro SCRIBBLE_IGNORE_PAUSE_BEFORE_PAGEBREAK  true

//Whether text models should freeze their vertex buffers one frame after the text model is created. This leads to increased performance, especially with large amounts of text
#macro SCRIBBLE_INCREMENTAL_FREEZE  true

//Set to <true> to ignore a sprite origin's contribution to its spritefont glyph x/y offsets
#macro SCRIBBLE_SPRITEFONT_IGNORE_ORIGIN  false

//Version 8 uses GameMaker's native spritefont dimensions. Older versions used the tight bounding box leading to narrower lines. Set this macro to <true> to use the tighter legacy behaviour
#macro SCRIBBLE_SPRITEFONT_LEGACY_HEIGHT  false

//Edge trimming around the bounding box for SDF glyphs (in pixels). This is useful for tidying up any glitches when scaling
#macro SCRIBBLE_SDF_BORDER_TRIM  0

//Whether to force double-draw behaviour. This is useful for fixing problems with SDF glyph border overlap
#macro SCRIBBLE_ALWAYS_DOUBLE_DRAW  false

#macro SCRIBBLE_FETCH_RANGE_ON_ADD  false

//Character used to open a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_OPEN  ord("[")
//Character used to close a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_CLOSE  ord("]")

//Character used to delimit a command parameter inside a command tag. First 127 ASCII chars only
#macro SCRIBBLE_COMMAND_TAG_ARGUMENT  ord(",")

//Whether the .draw() method for text element returns <self>. This defaults to <false> to avoid unintentional misuse
#macro SCRIBBLE_DRAW_RETURNS_SELF  false

//Whether the .build() method for text element returns <self>. This defaults to <false> to avoid unintentional misuse
#macro SCRIBBLE_BUILD_RETURNS_SELF  false

//Controls the drawing of a rectangle that indicates the boundaries of the .layout_wrap(), .layout_fit(), and .layout_scale() methods
#macro SCRIBBLE_SHOW_WRAP_BOUNDARY  false

//Whether to try to fix font scaling due to the font texture being too big for the texture page
#macro SCRIBBLE_ATTEMPT_FONT_SCALING_FIX  true

//Whether to replace a grave accent (` U+0060, decimal=96) with a zero-width space for Thai text
#macro SCRIBBLE_THAI_GRAVE_ACCENTS_ARE_ZWSP  false

//Whether to perform the following Unicode substitutions to fix copy-pasted text from e.g. Google Docs:
// Ellipsis            … U+2026   ->   Three full stops . U+002E
// En dash             – U+2013   ->   Hyphen           - U+002D
// Em dash             — U+2014   ->   Hyphen           - U+002D
// Horizontal bar      ― U+2015   ->   Hyphen           - U+002D
// Start single quote  ‘ U+2018   ->   Single quote     ' U+0027
// End single quote    ’ U+2018   ->   Single quote     ' U+0027
// Start double quote  “ U+201C   ->   Double quote     " U+0022
// End double quote    ” U+201D   ->   Double quote     " U+0022
// Low double quote    „ U+201E   ->   Double quote     " U+0022
// High double quote   ‟ U+201F   ->   Double quote     " U+0022
// Greek question mark ; U+037E   ->   Semicolon        ; U+003B
#macro SCRIBBLE_UNDO_UNICODE_SUBSTITUTIONS  false

#macro SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE  512

#macro SCRIBBLE_INTERNAL_FONT_ADD_MARGIN  1

//Accuracy of cycles. A higher number will lead to more precise colour transitions
#macro SCRIBBLE_CYCLE_ACCURACY  128

//Maximum number of cycles that can be defined
#macro SCRIBBLE_CYCLE_COUNT  31
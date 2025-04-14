// Feather disable all
/// Scribble's macros, used to customise and control behaviour throughout the library
///
/// N.B. You never need to run this script yourself! All of these macros are handled automatically when Scribble is compiled into your project

//Replaces hashes (#) with newlines (ASCII chr10) to emulate GMS1's newline behaviour.
#macro SCRIBBLE_HASH_NEWLINE  false

//Replaces newline literals ("\\n") with an actual newline ("\n").
#macro SCRIBBLE_FIX_ESCAPED_NEWLINES  false

//Whether to use colourization for sprites. This includes [rainbow] and [cycle].
#macro SCRIBBLE_COLORIZE_SPRITES  true

//Whether to use sprite origins. Setting this to <false> will vertically centre sprites on the line
//of text.
#macro SCRIBBLE_ADD_SPRITE_ORIGINS  false

//Character to use when another character is missing from a font.
#macro SCRIBBLE_MISSING_CHARACTER  "?"

//Set to `true` to use GameMaker's #BBGGRR format for in-line hex code colors. `false` uses the web
//standard #RRGGBB format
#macro SCRIBBLE_BGR_COLOR_HEX_CODES  false

//Whether to use text element sizes (false) or page sizes (true) for bounding box calculations
#macro SCRIBBLE_BOUNDING_BOX_USES_PAGE  true

//Width of a horizontal tab, as a number of spaces
#macro SCRIBBLE_TAB_WIDTH  4

//Controls if spaces and tabs have a fixed, unchanging size. Setting this to <false> will ensure
//that spaces are always the same size, which is useful for monospaced fonts.
#macro SCRIBBLE_FLEXIBLE_WHITESPACE_WIDTH  true

//Sets whether pin alignments use the size of the page for positioning, or the size of the text
//element (the bounding box across all pages).
#macro SCRIBBLE_PIN_ALIGNMENT_USES_PAGE_SIZE  false

//Set to <true> to enable the `.get_text()` method on text elements. This will apply to all text
//elements and carries a performance penalty.
#macro SCRIBBLE_ALLOW_TEXT_GETTER  false

//Set to <true> to enable the `.get_glyph_data()` method on text elements (and a few other features
//too). This will apply to all text elements and carries a performance penalty.
#macro SCRIBBLE_ALLOW_GLYPH_DATA_GETTER  false

//Whether to automatically scale sprites to fit into the line of text. This is based on the font
//height of the current font.
#macro SCRIBBLE_AUTOFIT_INLINE_SPRITES  false

//Whether to automatically scale surfaces to fit into the line of text. This is based on the font
//height of the current font.
#macro SCRIBBLE_AUTOFIT_INLINE_SURFACES  false

//Whether to automatically scale textures to fit into the line of text. This is based on the font
//height of the current font.
#macro SCRIBBLE_AUTOFIT_INLINE_TEXTURES  false  

//Whether to adjust the horizontal distance between glyphs depending on special per-font rules. Set
//to `false` for legacy pre-8.2 behaviour.
#macro SCRIBBLE_USE_KERNING  true

//Bilinear filtering state to force for inline sprite (and surfaces too). Set to `undefined` to use
//the current global bilinear filtering state.
#macro SCRIBBLE_SPRITE_BILINEAR_FILTERING  undefined

//Whether the last character in a string should trigger a per-character delay.
#macro SCRIBBLE_DELAY_LAST_CHARACTER  false

//Whether to use ascender offsets when calculating glyph y-offsets. Set this macro to `false` for
//compatibility with legacy codebases.
#macro SCRIBBLE_USE_ASCENDER_OFFSET  true

//Whether to allow use of `scribble_font_set_*align_offset()`. Set this macro to false for a slight
//performance improvement.
#macro SCRIBBLE_USE_FONT_ALIGNMENT_OFFSETS  true

//Whether to require explicit whitelisting of sprites (via `scribble_whitelist_sprite()`).
#macro SCRIBBLE_USE_SPRITE_WHITELIST  false

//Whether to require explicit whitelisting of sounds (via `scribble_whitelist_sound()`).
#macro SCRIBBLE_USE_SOUND_WHITELIST  false

//Whether to floor draw coordinates passed to the `.draw()` method. This will not affect the draw
//coordinates of glyphs themselves.
#macro SCRIBBLE_FLOOR_DRAW_COORDINATES  false





#region Advanced Features

//Animation tick size per step. The default macro `(delta_time / 16666)` ensures that animations
//are smooth and consistent at all framerates.
#macro SCRIBBLE_TICK_SIZE  (delta_time / 16666)

//Default value to use for text element unique IDs. This is used when no unique ID is specified.
//This value must be a string, and must start with a colon (:).
#macro SCRIBBLE_DEFAULT_UNIQUE_ID  "default:"

//Enables verbose console output to aid with debugging
#macro SCRIBBLE_VERBOSE  false

//Controls how accurately text fits Beziér curves. Higher is more accurate but slower.
#macro SCRIBBLE_BEZIER_ACCURACY  20

//Whether to trim off empty left-hand space when moving a word to a new line. This can cause issues
//with spritefonts in some situations.
#macro SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE  false

//Whether to pad extra space left-hand space when moving a word to a new line.
#macro SCRIBBLE_NEWLINES_PAD_LEFT_SPACE  true

//Number of iterations to fit text when using the `.fit_to_box()` method. Higher values are slower
//but more accurate.
#macro SCRIBBLE_FIT_TO_BOX_ITERATIONS  7

//Whether to wrap the internal time value.
#macro SCRIBBLE_SAFELY_WRAP_TIME  true

//Disables [pause] events immediately before pagebreaks, though only if there are no other events
//between the pause and the pagebreak.
#macro SCRIBBLE_IGNORE_PAUSE_BEFORE_PAGEBREAK  true

//Whether text models should freeze their vertex buffers one frame after the text model is created.
//This leads to increased performance, especially with large amounts of text.
#macro SCRIBBLE_INCREMENTAL_FREEZE  true

//Set to `true` to ignore a sprite origin's contribution to its spritefont glyph x/y offsets.
#macro SCRIBBLE_SPRITEFONT_IGNORE_ORIGIN  false

//Version 8 and later uses GameMaker's native spritefont dimensions. Older versions used the tight
//bounding box leading to narrower lines. Set this macro to <true> to use the tighter legacy
//behaviour.
#macro SCRIBBLE_SPRITEFONT_LEGACY_HEIGHT  false

//Edge trimming around the bounding box for SDF glyphs (in pixels). This is useful for tidying up
//any glitches when scaling.
#macro SCRIBBLE_SDF_BORDER_TRIM  0

//Whether to force double-draw behaviour. This is useful for fixing problems with SDF glyph outline
//overlap.
#macro SCRIBBLE_ALWAYS_DOUBLE_DRAW  false

//What function to use to play audio from Scribble. This function is called using the same
//parameters as `audio_play_sound()`:
//  `SCRIBBLE_AUDIO_PLAY_FUNCTION(sound, 1, false, gain, 0, pitch)`
#macro SCRIBBLE_AUDIO_PLAY_FUNCTION  audio_play_sound

//Character used to open a command tag. First 127 ASCII chars only.
#macro SCRIBBLE_COMMAND_TAG_OPEN  ord("[")

//Character used to close a command tag. First 127 ASCII chars only.
#macro SCRIBBLE_COMMAND_TAG_CLOSE  ord("]")

//Character used to delimit a command parameter inside a command tag. First 127 ASCII chars only.
#macro SCRIBBLE_COMMAND_TAG_ARGUMENT  ord(",")

//Whether the `.draw()` method for text element returns `self`. This defaults to `false` to avoid
//unintentional misuse.
#macro SCRIBBLE_DRAW_RETURNS_SELF  false

//Whether the `.build()` method for text element returns `self`. This defaults to `false` to avoid
//unintentional misuse.
#macro SCRIBBLE_BUILD_RETURNS_SELF  false

//Controls the drawing of a rectangle that indicates the boundaries of the `.wrap()`,
//`.fit_to_box()`, and `.scale_to_box()` methods.
#macro SCRIBBLE_SHOW_WRAP_BOUNDARY  false

//Whether to try to fix font scaling due to the font texture being too big for the texture page.
#macro SCRIBBLE_ATTEMPT_FONT_SCALING_FIX  true

//Whether to replace a grave accent (` U+0060, decimal=96) with a zero-width space for Thai text.
//This makes life easier for localisation teams.
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

#endregion
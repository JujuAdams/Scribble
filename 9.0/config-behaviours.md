# Behaviour Configuration

&nbsp;

## `SCRIBBLE_HASH_NEWLINE`

*Typical value:* `false`

Replaces hashes (`#`) with newlines (`\n` `U+00A0`) to emulate GMS1's newline behaviour.

&nbsp;

## `SCRIBBLE_FIX_ESCAPED_NEWLINES`

*Typical value:* `false`

Replaces newline literals `\\n` with an actual newline (`\n` `U+00A0`).

&nbsp;

## `SCRIBBLE_ADD_SPRITE_ORIGINS`

*Typical value:* `false`

Whether to use sprite origins. Setting this to `false` will vertically centre sprites on the line of text.

&nbsp;

## `SCRIBBLE_MISSING_CHARACTER`

*Typical value:* `"?"`

Character to use when another character is missing from a font.

&nbsp;

## `SCRIBBLE_BOUNDING_BOX_USES_PAGE`

*Typical value:* `true`

Whether to use text element sizes (`false`) or page sizes (`true`) for bounding box calculations.

&nbsp;

## `SCRIBBLE_TAB_WIDTH`

*Typical value:* `4`

Width of a horizontal tab, as a number of spaces.

&nbsp;

## `SCRIBBLE_FLEXIBLE_WHITESPACE_WIDTH`

*Typical value:* `true`

Controls if spaces and tabs have a fixed, unchanging size. Setting this to `false` will ensure that spaces are always the same size, which is useful for monospaced fonts.

&nbsp;

## `SCRIBBLE_PIN_ALIGNMENT_USES_PAGE_SIZE`

*Typical value:* `false`

Sets whether pin alignments use the size of the page for positioning, or the size of the text element (the bounding box across all pages).

&nbsp;

## `SCRIBBLE_ALLOW_TEXT_GETTER`

*Typical value:* `false`

Set to `true` to enable the `.get_text()` text element method. This will apply to all text elements and carries a performance penalty.

&nbsp;

## `SCRIBBLE_ALLOW_GLYPH_DATA_GETTER`

*Typical value:* `false`

Set to `true` to enable the `.get_glyph_data()` text element method (and a few other features too). This will apply to all text elements and carries a performance penalty.

&nbsp;

## `SCRIBBLE_AUTOFIT_INLINE_SPRITES`

*Typical value:* `false`

Whether to automatically scale sprites to fit into the line of text. This is based on the font height of the current font.

&nbsp;

## `SCRIBBLE_AUTOFIT_INLINE_SURFACES`

*Typical value:* `false`

Whether to automatically scale surfaces to fit into the line of text. This is based on the font height of the current font.

&nbsp;

## `SCRIBBLE_USE_KERNING`

*Typical value:* `true`

&nbsp;

## `SCRIBBLE_SPRITE_BILINEAR_FILTERING`

*Typical value:* `undefined`

&nbsp;

## `SCRIBBLE_DELAY_LAST_CHARACTER`

*Typical value:* `false`

&nbsp;

&nbsp;

# Advanced

## `SCRIBBLE_TICK_SIZE`

*Typical value:* `(delta_time / 16666)`

Animation tick size per step. The out-of-the-box value `(delta_time / 16666)` presumes a base framerate of 60FPS and ensures that animations are smooth and consistent if the framerate changes.

&nbsp;

## `SCRIBBLE_VERBOSE`

*Typical value:* `false`

Enables verbose console output to aid with debugging.

&nbsp;

## `SCRIBBLE_BEZIER_ACCURACY`

*Typical value:* `20`

Controls how accurately text fits Beziér curves. Higher is more accurate but slower.

&nbsp;

## `SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE`

*Typical value:* `false`

Whether to trim off empty left-hand space when moving a word to a new line. This can cause issues with monospaced fonts and spritefonts in some situations.

&nbsp;

## `SCRIBBLE_NEWLINES_PAD_LEFT_SPACE`

*Typical value:* `true`

Whether to pad extra space left-hand space when moving a word to a new line.

&nbsp;

## `SCRIBBLE_FIT_TO_BOX_ITERATIONS`

*Typical value:* `7`

Number of iterations to fit text when using the .layout_fit() method. Higher values are slower but more accurate.

&nbsp;

## `SCRIBBLE_SAFELY_WRAP_TIME`

*Typical value:* `true`

Whether to wrap the internal time value.

&nbsp;

## `SCRIBBLE_IGNORE_PAUSE_BEFORE_PAGEBREAK`

*Typical value:* `true`

Disables `[pause]` events immediately before pagebreaks, though only if there are no other events between the pause and the pagebreak.

&nbsp;

## `SCRIBBLE_INCREMENTAL_FREEZE`

*Typical value:* `true`

Whether text models should freeze their vertex buffers one frame after the text model is created. This leads to increased performance, especially with large amounts of text.

&nbsp;

## `SCRIBBLE_SPRITEFONT_IGNORE_ORIGIN`

*Typical value:* `false`

Set to <true> to ignore a sprite origin's contribution to its spritefont glyph x/y offsets.

&nbsp;

## `SCRIBBLE_SDF_BORDER_TRIM`

*Typical value:* `0`

Edge trimming around the bounding box for SDF glyphs (in pixels). This is useful for tidying up any glitches when scaling.

&nbsp;

## `SCRIBBLE_ALWAYS_DOUBLE_DRAW`

*Typical value:* `false`

Whether to force double-draw behaviour. This is useful for fixing problems with SDF glyph border overlap.

&nbsp;

## `SCRIBBLE_FETCH_RANGE_ON_ADD`

*Typical value:* `false`



## `SCRIBBLE_COMMAND_TAG_OPEN`

*Typical value:* `ord("[")`

Character used to open a command tag. First 127 ASCII chars only.

&nbsp;

## `SCRIBBLE_COMMAND_TAG_CLOSE`

*Typical value:* `ord("]")`

Character used to close a command tag. First 127 ASCII chars only.

&nbsp;

## `SCRIBBLE_COMMAND_TAG_ARGUMENT`

*Typical value:* `ord(",")`

Character used to delimit a command parameter inside a command tag. First 127 ASCII chars only.

&nbsp;


## `SCRIBBLE_DRAW_RETURNS_SELF`

*Typical value:* `false`

Whether the `.draw()` method for text element returns the text element itself. This defaults to `false` to avoid unintentional misuse.

&nbsp;

## `SCRIBBLE_BUILD_RETURNS_SELF`

*Typical value:* `false`

Whether the `.build()` method for text element returns `self`. This defaults to `false` to avoid unintentional misuse.

&nbsp;

## `SCRIBBLE_SHOW_WRAP_BOUNDARY`

*Typical value:* `false`

Controls the drawing of a rectangle that indicates the boundaries of the `.layout_wrap()`, `.layout_fit()`, and `.layout_scale()` methods

&nbsp;

## `SCRIBBLE_ATTEMPT_FONT_SCALING_FIX`

*Typical value:* `true`

Whether to try to fix font scaling due to the font texture being too big for the texture page.

&nbsp;

## `SCRIBBLE_THAI_GRAVE_ACCENTS_ARE_ZWSP`

*Typical value:* `false`

Whether to replace a grave accent (\` U+0060, decimal=96) with a zero-width space for Thai text.

&nbsp;

## `SCRIBBLE_UNDO_UNICODE_SUBSTITUTIONS`

*Typical value:* `false`

Whether to perform the following Unicode substitutions to fix copy-pasted text from e.g. Google Docs:

|Name               |   |        |Replacement     |     |                      |
|-------------------|---|--------|----------------|-----|----------------------|
|Ellipsis           |`…`|`U+2026`|Three full stops|`...`|`U+002E U+002E U+002E`|
|En dash            |`–`|`U+2013`|Hyphen          |`-`  |`U+002D`              |
|Em dash            |`—`|`U+2014`|Hyphen          |`-`  |`U+002D`              |
|Horizontal bar     |`―`|`U+2015`|Hyphen          |`-`  |`U+002D`              |
|Start single quote |`‘`|`U+2018`|Single quote    |`'`  |`U+0027`              |
|End single quote   |`’`|`U+2018`|Single quote    |`'`  |`U+0027`              |
|Start double quote |`“`|`U+201C`|Double quote    |`"`  |`U+0022`              |
|End double quote   |`”`|`U+201D`|Double quote    |`"`  |`U+0022`              |
|Low double quote   |`„`|`U+201E`|Double quote    |`"`  |`U+0022`              |
|High double quote  |`‟`|`U+201F`|Double quote    |`"`  |`U+0022`              |
|Greek question mark|`;`|`U+037E`|Semicolon       |`;`  |`U+003B`              |

&nbsp;

## `SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE`

*Typical value:* `1024`

&nbsp;

## `SCRIBBLE_INTERNAL_FONT_ADD_MARGIN`

*Typical value:* `1`
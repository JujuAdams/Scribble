# Configuration

&nbsp;

## `__scribble_config_behaviours()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This script holds a number of macros that customise the behaviour of Scribble. `__scribble_config_behaviours()` never needs to be directly called in code, but the script and the macros it contains must be present in a project for Scribble to work.

?> You should edit this script to customise Scribble for your own purposes.

&nbsp;

|Macro                                   |Typical value     |Purpose                                                                                                                                                                                     |
|----------------------------------------|------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`SCRIBBLE_HASH_NEWLINE`                 |`false`           |Replaces hashes `#` with newlines `\n` to emulate GMS1's newline behaviour                                                                                                                  |
|`SCRIBBLE_FIX_ESCAPED_NEWLINES`         |`false`           |Replaces newline literals (`\\n`) with an actual newline (`\n`)                                                                                                                             |
|`SCRIBBLE_COLORIZE_SPRITES`             |`true`            |Whether to use colourization for sprites. This includes `[rainbow]` and `[cycle]`                                                                                                           |
|`SCRIBBLE_ADD_SPRITE_ORIGINS`           |`false`           |Whether to use sprite origins when drawing an in-line sprite. Setting this to `false` will vertically centre sprites on each line of text                                                   |
|`SCRIBBLE_MISSING_CHARACTER`            |`"?"`             |Character to use when another character is missing from a font                                                                                                                              |
|`SCRIBBLE_BGR_COLOR_HEX_CODES`          |`false`           |Set to `true` to use GameMaker's `#BBGGRR` format for in-line hex code colors. `false` uses the industry standard `#RRGGBB` format                                                          |
|`SCRIBBLE_BOUNDING_BOX_USES_PAGE`       |`true`            |Whether to use text element sizes (`false`) or page sizes (`true`) for bounding box calculations                                                                                            |
|`SCRIBBLE_TAB_WIDTH`                    |`4`               |Width of a horizontal tab, as a number of spaces                                                                                                                                            |
|`SCRIBBLE_INCREMENTAL_FREEZE`           |`true`            |Controls if spaces and tabs have a fixed, unchanging size. Setting this to `false` will ensure that spaces are always the same size, which is useful for monospaced fonts                   |
|`SCRIBBLE_FIXED_WHITESPACE_WIDTH`       |`false`           |Controls if spaces and tabs have a fixed, unchanging size. Setting this to true will ensure that spaces are always the same size, which is useful for monospaced fonts                      |
|`SCRIBBLE_PIN_ALIGNMENT_USES_PAGE_SIZE` |`true`            |Sets whether pin alignments use the size of the page for positioning, or the size of the text element (the bounding box across all pages)                                                   |
|`SCRIBBLE_ALLOW_TEXT_GETTER`            |`false`           |Set to `true` to enable the `.get_text()` method on text elements. This will apply to all text elements and carries a performance penalty                                                   |
|`SCRIBBLE_ALLOW_GLYPH_DATA_GETTER`      |`false`           |Set to `true` to enable the `.get_glyph_data()` method on text elements (and a few other features too). This will apply to all text elements and carries a performance penalty              |
|`SCRIBBLE_AUTOFIT_INLINE_SPRITES`       |`false`           |Whether to automatically scale sprites to fit into the line of text. This is based on the font height of the current font                                                                   |
|`SCRIBBLE_AUTOFIT_INLINE_SURFACES`      |`false`           |Whether to automatically scale surfaces to fit into the line of text. This is based on the font height of the current font                                                                  |
|`SCRIBBLE_USE_KERNING`                  |`true`            |Whether to adjust the horizontal distance between glyphs depending on special per-font rules. Set to `false` for legacy pre-8.2 behaviour                                                   |
|`SCRIBBLE_SPRITE_BILINEAR_FILTERING`    |`undefined`       |Bilinear filtering state to force for inline sprite (and surfaces too). Set to `undefined` to use the current global bilinear filtering state                                               |
|`SCRIBBLE_DELAY_LAST_CHARACTER`         |`false`           |Whether the last character in a string should trigger a per-character delay                                                                                                                 |
|`SCRIBBLE_USE_ASCENDER_OFFSET`          |`true`            |Whether to use ascender offsets when calculating glyph y-offsets. Set this macro to `false` for compatibility with legacy codebases                                                         |
|`SCRIBBLE_USE_FONT_ALIGNMENT_OFFSETS`   |`true`            |Whether to allow use of `scribble_font_set_*align_offset()`. Set this macro to `false` for a slight performance improvement                                                                 |
|`SCRIBBLE_USE_SPRITE_WHITELIST`         |`false`           |Whether to require explicit whitelisting of sprites (via `scribble_whitelist_sprite()`)                                                                                                     |
|`SCRIBBLE_USE_SOUND_WHITELIST`          |`false`           |Whether to require explicit whitelisting of sounds (via `scribble_whitelist_sound()`)                                                                                                       |
|**Advanced Features**                   |                  |                                                                                                                                                                                            |
|`SCRIBBLE_TICK_SIZE`                    |`1`               |Animation tick size per step. The default value for this macro (`delta_time / 16666`) ensures that animations are smooth and consistent at all framerates                                   |
|`SCRIBBLE_DEFAULT_UNIQUE_ID`            |`"default"`       |Default value to use for text element unique IDs. This is used when no unique ID is specified                                                                                               |
|`SCRIBBLE_VERBOSE`                      |`false`           |Enables verbose console output to aid with debugging                                                                                                                                        |
|`SCRIBBLE_BEZIER_ACCURACY`              |`20`              |Controls how accurately text fits Beziér curves. Higher is more accurate but slower                                                                                                         |
|`SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE`     |`true`            |Whether to trim off empty left-hand space when moving a word to a new line. This can cause issues with spritefonts in some situations                                                       |
|`SCRIBBLE_NEWLINES_PAD_LEFT_SPACE`      |`true`            |Whether to pad extra space left-hand space when moving a word to a new line                                                                                                                 |
|`SCRIBBLE_FIT_TO_BOX_ITERATIONS`        |`7`               |Number of iterations to fit text when using the `.fit_to_box()` method. Higher values are slower but more accurate                                                                          |
|`SCRIBBLE_SAFELY_WRAP_TIME`             |`true`            |Whether to apply workaround for low GPU floating point accuracy                                                                                                                             |
|`SCRIBBLE_IGNORE_PAUSE_BEFORE_PAGEBREAK`|`true`            |Disables `[pause]` events immediately before pagebreaks, though only if there are no other events between the pause and the pagebreak                                                       |
|`SCRIBBLE_INCREMENTAL_FREEZE`           |`true`            |Whether text models should freeze their vertex buffers one frame after the text model is created. This leads to increased performance, especially with large amounts of text                |
|`SCRIBBLE_SPRITEFONT_IGNORE_ORIGIN`     |`false`           |Set to `true` to ignore a sprite origin's contribution to its spritefont glyph x/y offsets                                                                                                  |
|`SCRIBBLE_SPRITEFONT_LEGACY_HEIGHT`     |`false`           |Version 8 uses GameMaker's native spritefont dimensions. Older versions used the tight bounding box leading to narrower lines. Set this macro to `true` to use the tighter legacy behaviour |
|`SCRIBBLE_SDF_BORDER_TRIM`              |`0`               |Edge trimming around the bounding box for SDF glyphs (in pixels). This is useful for tidying up any glitches when scaling                                                                   |
|`SCRIBBLE_ALWAYS_DOUBLE_DRAW`           |`false`           |Whether to force double-draw behaviour. This is useful for fixing problems with SDF glyph border overlap                                                                                    |
|`SCRIBBLE_AUDIO_PLAY_FUNCTION`          |`audio_play_sound`|What function to use to play audio from Scribble. This function is called using the same parameters as `audio_play_sound()`: `SCRIBBLE_AUDIO_PLAY_FUNCTION(sound, 1, false, gain, 0, pitch)`|
|`SCRIBBLE_COMMAND_TAG_OPEN`             |`ord("[")`        |Character used to open a command tag. First 127 ASCII chars only                                                                                                                            |
|`SCRIBBLE_COMMAND_TAG_CLOSE`            |`ord("]")`        |Character used to close a command tag. First 127 ASCII chars only                                                                                                                           |
|`SCRIBBLE_COMMAND_TAG_ARGUMENT`         |`ord(",")`        |Character used to delimit a command parameter inside a command tag. First 127 ASCII chars only                                                                                              |
|`SCRIBBLE_DRAW_RETURNS_SELF`            |`false`           |Whether the `.draw()` method for text element returns `self`. This defaults to `false` to avoid unintentional misuse                                                                        |
|`SCRIBBLE_BUILD_RETURNS_SELF`           |`false`           |Whether the `.build()` method for text element returns `self`. This defaults to `false` to avoid unintentional misuse                                                                       |
|`SCRIBBLE_SHOW_WRAP_BOUNDARY`           |`false`           |Set to `true` to call `.debug_draw_bbox()` for all text elements. This is useful for debugging wrapping boundaries                                                                          |
|`SCRIBBLE_ATTEMPT_FONT_SCALING_FIX `    |`true`            |Whether to try to fix font scaling due to the font texture being too big for the texture page                                                                                               |
|`SCRIBBLE_THAI_GRAVE_ACCENTS_ARE_ZWSP`  |`false`           |Whether to replace grave accents with zero-width spaces when drawing Thai characters                                                                                                        |
|`SCRIBBLE_UNDO_UNICODE_SUBSTITUTIONS`   |`false`           |Whether to undo common aesthetic Unicode substitutions. See below for more detail                                                                                                           |

The following table describes the reverse substitutions that Scribble will perform if `SCRIBBLE_UNDO_UNICODE_SUBSTITUTIONS` is set to `true`:

|Input               |   |Input hex code|Output          |   |Output hex code|             
|--------------------|---|--------------|----------------|---|---------------|
|Ellipsis            |`…`|`2026`        |Three full stops|`.`|`002E`         |
|En dash             |`–`|`2013`        |Hyphen          |`-`|`002D`         |
|Em dash             |`—`|`2014`        |Hyphen          |`-`|`002D`         |
|Horizontal bar      |`―`|`2015`        |Hyphen          |`-`|`002D`         |
|Start single quote  |`‘`|`2018`        |Single quote    |`'`|`0027`         |
|End single quote    |`’`|`2018`        |Single quote    |`'`|`0027`         |
|Start double quote  |`“`|`201C`        |Double quote    |`"`|`0022`         |
|End double quote    |`”`|`201D`        |Double quote    |`"`|`0022`         |
|Low double quote    |`„`|`201E`        |Double quote    |`"`|`0022`         |
|High double quote   |`‟`|`201F`        |Double quote    |`"`|`0022`         |
|Greek question mark |`;`|`037E`        |Semicolon       |`;`|`003B`         |

&nbsp;

## `__scribble_config_defaults()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This script holds a number of macros that customise the default text animation properties for Scribble. `__scribble_config_defaults()` never needs to be directly called in code, but the script and the macros it contains must be present in a project for Scribble to work.

?> You should edit this script to customise Scribble for your own purposes.

|Macro                                |Typical value|Purpose                                                                                                                                                                                                     |
|-------------------------------------|-------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`SCRIBBLE_DEFAULT_COLOR`             |`c_white`    |Default vertex colour when drawing text models. This can be overwritten by the `.starting_format()` text element method. This will not affect `draw_text_scribble()` (which instead uses `draw_get_color()`)|
|`SCRIBBLE_DEFAULT_HALIGN`            |`fa_left`    |Default horizontal alignment for text. This can be changed using the `.align()` text element method. This will not affect `draw_text_scribble()` (which instead uses `draw_get_halign()`)                   |
|`SCRIBBLE_DEFAULT_VALIGN`            |`fa_top`     |Default vertical alignment for text. This can be changed using the `.align()` text element method. This will not affect `draw_text_scribble()` (which instead uses `draw_get_valign()`)                     |
|`SCRIBBLE_DEFAULT_SPRITE_SPEED`      |`0.1`        |The default animation speed for sprites inserted into text                                                                                                                                                  |
|`SCRIBBLE_DEFAULT_DELAY_DURATION`    |`450`        |Default duration of the `[delay]` command, in milliseconds                                                                                                                                                  |
|`SCRIBBLE_SLANT_GRADIENT`            |`0.25`       |The x-axis displacement when using the `[slant]` tag as a proportion of the glyph height                                                                                                                    |
|`SCRIBBLE_DEFAULT_Z`                 |`0`          |Default z-position when drawing text models. This can be overwritten by the `.z()` text element method                                                                                                      |
|`SCRIBBLE_DEFAULT_WAVE_SIZE`         |`4`          |Default wave amplitude, in pixels                                                                                                                                                                           |
|`SCRIBBLE_DEFAULT_WAVE_FREQUENCY`    |`50`         |Default wave frequency. Larger values create more "humps" over a certain number of characters                                                                                                               |
|`SCRIBBLE_DEFAULT_WAVE_SPEED`        |`0.2`        |Default wave speed. Larger numbers cause characters to move up and down more rapidly                                                                                                                        |
|`SCRIBBLE_DEFAULT_SHAKE_SIZE`        |`2`          |Default shake amplitude, in pixels                                                                                                                                                                          |
|`SCRIBBLE_DEFAULT_SHAKE_SPEED`       |`0.4`        |Default shake speed. Larger values cause characters to move around more rapidly                                                                                                                             |
|`SCRIBBLE_DEFAULT_RAINBOW_WEIGHT`    |`0.5`        |Default rainbow blend weight. `0` does not show any rainbow effect at all, and `1` will blend a glyph's colour fully with the rainbow colour                                                                |
|`SCRIBBLE_DEFAULT_RAINBOW_SPEED`     |`0.01`       |Default rainbow speed. Larger values cause characters to change colour more rapidly                                                                                                                         |
|`SCRIBBLE_DEFAULT_WOBBLE_ANGLE`      |`40`         |Default maximum wobble angle. Larger values cause glyphs to oscillate further to the left and right                                                                                                         |
|`SCRIBBLE_DEFAULT_WOBBLE_FREQ`       |`0.15`       |Default wobble frequency. Larger values cause glyphs to oscillate faster                                                                                                                                    |
|`SCRIBBLE_DEFAULT_PULSE_SCALE`       |`0.4`        |Default pulse scale offset. A value of `0` will cause no visible scaling changes for a glyph, a value of `1` will cause a glyph to double in size                                                           |
|`SCRIBBLE_DEFAULT_PULSE_SPEED`       |`0.1`        |Default pulse speed. Larger values cause glyph scales to pulse faster                                                                                                                                       |
|`SCRIBBLE_DEFAULT_WHEEL_SIZE`        |`1`          |Default wheel amplitude, in pixels                                                                                                                                                                          |
|`SCRIBBLE_DEFAULT_WHEEL_FREQUENCY`   |`0.5`        |Default wheel frequency. Larger values create more "humps" over a certain number of characters                                                                                                              |
|`SCRIBBLE_DEFAULT_WHEEL_SPEED`       |`0.2`        |Default wheel speed. Larger numbers cause characters to move up and down more rapidly                                                                                                                       |
|`SCRIBBLE_DEFAULT_CYCLE_SPEED`       |`0.5`        |Default cycle speed. Larger numbers cause characters to change colour more rapidly                                                                                                                          |
|`SCRIBBLE_DEFAULT_CYCLE_SATURATION`  |`180`        |Default cycle colour saturation, from `0` to `255`. Colour cycles using the HSV model to create colours                                                                                                     |
|`SCRIBBLE_DEFAULT_CYCLE_VALUE`       |`255`        |Default cycle colour value, from `0` to `255`. Colour cycles using the HSV model to create colours                                                                                                          |
|`SCRIBBLE_DEFAULT_JITTER_MIN_SCALE`  |`0.8`        |Default jitter minimum scale. Unlike `SCRIBBLE_DEFAULT_PULSE_SCALE` this is **not** an offset                                                                                                               |
|`SCRIBBLE_DEFAULT_JITTER_MAX_SCALE`  |`1.2`        |Default jitter maximum scale. Unlike `SCRIBBLE_DEFAULT_PULSE_SCALE` this is **not** an offset                                                                                                               |
|`SCRIBBLE_DEFAULT_JITTER_SPEED`      |`0.4`        |Default jitter speed. Larger values cause glyph scales to fluctuate faster                                                                                                                                  |
|`SCRIBBLE_DEFAULT_BLINK_ON_DURATION` |`150`        |Default duration that blinking text should stay on for, in milliseconds                                                                                                                                     |
|`SCRIBBLE_DEFAULT_BLINK_OFF_DURATION`|`150`        |Default duration that blinking text should turn off for, in milliseconds                                                                                                                                    |
|`SCRIBBLE_DEFAULT_BLINK_TIME_OFFSET` |`0`          |Default blink time offset, in milliseconds                                                                                                                                                                  |

&nbsp;

## `__scribble_config_colours()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This script holds custom colours that you can reference by name for many Scribble functions. `__scribble_config_colours()` should never be directly called in your code. If you'd like to modify colours at runtime, use [`scribble_color_set()`](colour-functions).

?> This function is called on boot to initialise the library, and you should edit this script to customise Scribble for your own purposes.

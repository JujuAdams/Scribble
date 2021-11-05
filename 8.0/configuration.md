# Configuration

&nbsp;

## `__scribble_config_macros()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This script holds a number of macros that customise the behaviour of Scribble. `__scribble_config_macros()` never needs to be directly called in code, but the script and the macros it contains must be present in a project for Scribble to work.

?> You should edit this script to customise Scribble for your own purposes.

&nbsp;

|Macro                                  |Typical value|Purpose                                                                                                                                                                                    |
|---------------------------------------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`SCRIBBLE_HASH_NEWLINE`                |`false`      |Replaces hashes `#` with newlines `\n` to emulate GMS1's newline behaviour                                                                                                                 |
|`SCRIBBLE_FIX_ESCAPED_NEWLINES`        |`false`      |Replaces newline literals (`\\n`) with an actual newline (`\n`)                                                                                                                            |
|`SCRIBBLE_COLORIZE_SPRITES`            |`true`       |Whether to use colourization for sprites. This includes `[rainbow]` and `[cycle]`                                                                                                          |
|`SCRIBBLE_ADD_SPRITE_ORIGINS`          |`false`      |Whether to use sprite origins when drawing an in-line sprite. Setting this to `false` will vertically centre sprites on each line of text                                                  |
|`SCRIBBLE_SPRITEFONT_ALIGN_GLYPHS_LEFT`|`false`      |Set to `true` to trim off empty space on the left-hand side of a spritefont, even for non-proportional spritefonts. This is GameMaker's native behaviour                                   |
|`SCRIBBLE_MISSING_CHARACTER`           |`"?"`        |Character to use when another character is missing from a font                                                                                                                             |
|`SCRIBBLE_BGR_COLOR_HEX_CODES`         |`false`      |Set to `true` to use GameMaker's `#BBGGRR` format for in-line hex code colors. `false` uses the industry standard `#RRGGBB` format                                                         |
|`SCRIBBLE_DEFAULT_SPRITE_SPEED`        |`0.1`        |The default animation speed for sprites inserted into text. A value of `0.1` will advance 1 frame every 10 steps                                                                           |
|`SCRIBBLE_DEFAULT_DELAY_DURATION`      |`450`        |Default duration of the `[delay]` command, in milliseconds                                                                                                                                 |
|`SCRIBBLE_INCLUDED_FILES_SUBDIRECTORY` |`""`         |The directory to look in for font .yy files, relative to the root folder that Included Files are stored in                                                                                 |
|`SCRIBBLE_BOX_ALIGN_TO_PAGE`           |`false`      |Whether to use text element sizes (`false`) or page sizes (`true`)                                                                                                                         |
|`SCRIBBLE_SAFELY_WRAP_TIME`            |`true`       |Whether to apply workaround for low GPU floating point accuracy                                                                                                                            |
|**Advanced Features**                  |             |                                                                                                                                                                                           |
|`SCRIBBLE_TICK_SIZE`                   |`1`          |Animation tick size per step. The default value for this macro (`delta_time / 16666`) ensures that animations are smooth and consistent at all framerates                                  |
|`SCRIBBLE_SLANT_AMOUNT`                |`0.25`       |The x-axis displacement when using the `[slant]` tag                                                                                                                                       |
|`SCRIBBLE_DEFAULT_UNIQUE_ID`           |`"default"`  |Default value to use for text element unique IDs. This is used when no unique ID is specified                                                                                              |
|`SCRIBBLE_VERBOSE`                     |`false`      |Enables verbose console output to aid with debugging                                                                                                                                       |
|`SCRIBBLE_BEZIER_ACCURACY`             |`20`         |Controls how accurately text fits Beziér curves. Higher is more accurate but slower                                                                                                        |
|`SCRIBBLE_NEWLINES_TRIM_LEFT_SPACE`    |`true`       |Whether to trim off empty left-hand space when moving a word to a new line. This can cause issues with spritefonts in some situations                                                      |
|`SCRIBBLE_FIT_TO_BOX_ITERATIONS`       |`3`          |Number of iterations to fit text when using the `.fit_to_box()` method. Higher values are slower but more accurate                                                                         |
|`SCRIBBLE_COMMAND_TAG_OPEN`            |`ord("[")`   |Character used to open a command tag. First 127 ASCII chars only                                                                                                                           |
|`SCRIBBLE_COMMAND_TAG_CLOSE`           |`ord("]")`   |Character used to close a command tag. First 127 ASCII chars only                                                                                                                          |
|`SCRIBBLE_COMMAND_TAG_ARGUMENT`        |`ord(",")`   |Character used to delimit a command parameter inside a command tag. First 127 ASCII chars only                                                                                             |

&nbsp;

## `__scribble_config_colours()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This script holds custom colours that you can reference by name for many Scribble functions. `__scribble_config_colours()` never needs to be directly called in your code.

This function is called on boot to initialise the library, and you should edit this script to customise Scribble for your own purposes.

&nbsp;

## `__scribble_config_default_template()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

All text drawn with [`scribble()`](scribble-methods) will use these settings until otherwise overwritten.

?> This function is called on boot to initialise the library, and you should edit this script to customise Scribble for your own purposes.

&nbsp;

## `__scribble_config_animation()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This script holds a number of macros that customise the default text animation properties for Scribble. `__scribble_config_animation()` never needs to be directly called in code, but the script and the macros it contains must be present in a project for Scribble to work.

?> You should edit this script to customise Scribble for your own purposes.

|Macro                                     |Typical value|Purpose                                                                                                                                                                                    |
|------------------------------------------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`SCRIBBLE_ANIM_DEFAULT_WAVE_SIZE`         |`4`          |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_WAVE_FREQUENCY`    |`50`         |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_WAVE_SPEED`        |`0.2`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_SHAKE_SIZE`        |`2`          |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_SHAKE_SPEED`       |`0.4`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_RAINBOW_WEIGHT`    |`0.5`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_RAINBOW_SPEED`     |`0.01`       |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_WOBBLE_ANGLE`      |`40`         |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_WOBBLE_FREQ`       |`0.15`       |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_PULSE_SCALE`       |`0.4`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_PULSE_SPEED`       |`0.1`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_WHEEL_SIZE`        |`1`          |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_WHEEL_FREQUENCY`   |`0.5`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_WHEEL_SPEED`       |`0.2`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_CYCLE_SPEED`       |`0.5`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_CYCLE_SATURATION`  |`180`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_CYCLE_VALUE`       |`255`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_JITTER_MIN_SCALE`  |`0.8`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_JITTER_MAX_SCALE`  |`1.2`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_JITTER_SPEED`      |`0.4`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_BLINK_ON_DURATION` |`150`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_BLINK_OFF_DURATION`|`150`        |                                                                                                                                                                                           |
|`SCRIBBLE_ANIM_DEFAULT_BLINK_TIME_OFFSET` |`0`          |                                                                                                                                                                                           |
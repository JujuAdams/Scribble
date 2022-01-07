`__scribble_macros()`

**Returns:** N/A (`0`)

|Argument|Name|Purpose|
|--------|----|-------|
|None    |    |       |

This script holds a number of macros that customise the behaviour of Scribble. `__scribble_macros()` never needs to be directly called in code, but the script and the macros it contains must be present in a project for Scribble to work.

**You should edit this script to customise Scribble for your own purposes.**

&nbsp;

|Macro                                   |Typical value|Purpose                                                                                                                                                                                   |
|----------------------------------------|-------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`SCRIBBLE_HASH_NEWLINE`                 |`false`      |Replaces hashes (#) with newlines (ASCII chr10) to emulate GMS1's newline behaviour                                                                                                       |
|`SCRIBBLE_COLORIZE_SPRITES`             |`true`       |Whether to apply the text color to non-animated sprites (animated sprites are always blended white)                                                                                       |
|`SCRIBBLE_ADD_SPRITE_ORIGINS`           |`false`      |Whether to use sprite origins when drawing an in-line sprite. Setting this to `false` will vertically centre sprites on each line of text                                                 |
|`SCRIBBLE_SPRITEFONT_ALIGN_GLYPHS_LEFT` |`false`      |Set to `true` to trim off empty space on the left-hand side of a spritefont, even for non-proportional spritefonts. This is GameMaker's native behaviour                                  |
|`SCRIBBLE_MISSING_CHARACTER`            |`"?"`        |Character to use when another character is missing from a font                                                                                                                            |
|`SCRIBBLE_BGR_COLOR_HEX_CODES`          |`false`      |Set to `true` to use GameMaker's `#BBGGRR` format for in-line hex code colors. `false` uses the industry standard `#RRGGBB` format                                                        |
|`SCRIBBLE_DEFAULT_SPRITE_SPEED`         |`0.1`        |The default animation speed for sprites inserted into text                                                                                                                                |
|`SCRIBBLE_DEFAULT_DELAY_DURATION`       |`450`        |Default duration of the `[delay]` command, in milliseconds                                                                                                                                |
|**Advanced Features**                   |             |                                                                                                                                                                                          |
|`SCRIBBLE_STEP_SIZE`                    |`1`          |The animation step size. The default command uses `delta_time` to ensure that animations are smooth at all framerates                                                                     |
|`SCRIBBLE_SLANT_AMOUNT`                 |`0.24`       |The x-axis displacement when using the `[slant]` tag                                                                                                                                      |
|`SCRIBBLE_CREATE_GLYPH_LTRB_ARRAY`      |`false`      |Outputs an array of glyph LTRB bounding boxes                                                                                                                                             |
|`SCRIBBLE_CREATE_CHARACTER_ARRAY`       |`false`      |Outputs an array of character codes                                                                                                                                                       |
|`SCRIBBLE_DEFAULT_OCCURANCE_NAME`       |`"default"`  |Default value to use for autotyper occurances                                                                                                                                             |
|`SCRIBBLE_CACHE_TIMEOUT`                |`15000`      |How long to wait (in milliseconds) before the cache automatically destroys a text element. Set to `0` (or less) to turn this off - you'll need to manually call `scribble_flush()` instead|
|`SCRIBBLE_VERBOSE`                      |`false`      |Outputs more information to the debug console                                                                                                                                             |
|`SCRIBBLE_COMMAND_TAG_OPEN`             |`ord("[")`   |Character used to open a command tag. First 127 ASCII chars only                                                                                                                          |
|`SCRIBBLE_COMMAND_TAG_CLOSE`            |`ord("]")`   |Character used to close a command tag. First 127 ASCII chars only                                                                                                                         |
|`SCRIBBLE_COMMAND_TAG_ARGUMENT`         |`ord(",")`   |Character used to delimit a command parameter inside a command tag. First 127 ASCII chars only                                                                                            |
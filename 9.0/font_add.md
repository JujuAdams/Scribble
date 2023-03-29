# `font_add()`

&nbsp;

Scribble supports GameMaker's native `font_add()` function by wrapping in some bespoke logic. To add dynamic fonts with Scribble, please use `scribble_font_add()`.

&nbsp;

## `scribble_font_add()`

**Full Signature:** `scribble_font_add(name, filename, size, glyphRange, SDF, [spread], [bold=false], [italic=false])`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                           |
|------------|--------|----------------------------------|
|`name`      |string  |                                  |
|`filename`  |string  |                                  |
|`size`      |number  |                                  |
|`glyphRange`|        |                                  |
|`SDF`       |boolean |                                  |
|`[spread]`  |number  |                                  |
|`[bold]`    |boolean |                                  |
|`[italic]`  |boolean |                                  |

&nbsp;

## `scribble_font_fetch()`

**Full Signature:** `scribble_font_add(name, glyphRange)`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                           |
|------------|--------|----------------------------------|
|`name`      |string  |                                  |
|`glyphRange`|        |                                  |
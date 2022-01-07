`scribble_set_starting_format(fontName, fontColor, textHAlign)`

**Returns:** N/A (`0`)

|Argument|Name          |Purpose                                                                                                        |
|--------|--------------|---------------------------------------------------------------------------------------------------------------|
|0       |`fontName`    |Name of the starting font, as a string. This is the font that is set when `[]` or `[/font]` is used in a string|
|1       |`fontColor`   |Starting colour. This is the font that is set when `[]` or `[/color]` is used in a string                      |
|2       |`textHAlign`  |Starting horizontal alignment of text. This is the alignment that is set when `[]` is used in a string         |

This script sets part of Scribble's global state. All text drawn with [`scribble_draw()`](scribble_draw) or cached with [`scribble_cache()`](scribble_cache) will use these settings until they're overwritten, either by calling this script again or by calling [`scribble_reset()`](scribble_reset) or [`scribble_set_state()`](scribble_set_state).
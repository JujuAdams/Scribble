`scribble_set_line_height(min, max)`

**Returns:** N/A (`0`)

|Argument|Name |Purpose                                                                                                                               |
|--------|-----|--------------------------------------------------------------------------------------------------------------------------------------|
|0       |`min`|Minimum line height for each line of text. Use a negative number (the default) for the height of a space character of the default font|
|1       |`max`|Maximum line height for each line of text. Use a negative number (the default) for no limit                                           |

This script sets part of Scribble's global state. All text drawn with [`scribble_draw()`](scribble_draw) or cached with [`scribble_cache()`](scribble_cache) will use these settings until they're overwritten, either by calling this script again or by calling [`scribble_reset()`](scribble_reset) or [`scribble_set_state()`](scribble_set_state).
`scribble_set_blend(color, alpha)`

**Returns:** N/A (`0`)

|Argument|Name   |Purpose                                                                         |
|--------|-------|--------------------------------------------------------------------------------|
|0       |`color`|Blend colour used when drawing text, applied multiplicatively                   |
|1       |`alpha`|Alpha used when drawing text, 0 being fully transparent and 1 being fully opaque|

The blend colour/alpha is applied at the end of the drawing pipeline. This is a little different to the interaction between [`draw_set_color()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Colour_And_Alpha/draw_set_colour.htm) and [`draw_text()` functions](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/Text.htm). Scribble's blend colour is instead similar to [`draw_sprite_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Sprites_And_Tiles/draw_sprite_ext.htm)'s behaviour: The blend colour/alpha is applied multiplicatively with the source colour, in this case the source colour is whatever colour has been set using formatting tags in the input text string.

This script sets part of Scribble's global state. All text drawn with [`scribble_draw()`](scribble_draw) or cached with [`scribble_cache()`](scribble_cache) will use these settings until they're overwritten, either by calling this script again or by calling [`scribble_reset()`](scribble_reset) or [`scribble_set_state()`](scribble_set_state).
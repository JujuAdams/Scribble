`scribble_set_blend(color, alpha)`

**Returns:** N/A (`0`)

|Argument|Name   |Purpose                                                                         |
|--------|-------|--------------------------------------------------------------------------------|
|0       |`color`|Blend colour used when drawing text, applied multiplicatively                   |
|1       |`alpha`|Alpha used when drawing text, 0 being fully transparent and 1 being fully opaque|

The blend colour/alpha is applied at the end of the drawing pipeline. This is a little different to the interaction between [`draw_set_color()`](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/colour/draw_set_colour.html) and [`draw_text()` functions](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/text/). Scribble's blend colour is instead similar to [`draw_sprite_ext()`](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/sprites_and_tiles/draw_sprite_ext.html)'s behaviour: The blend colour/alpha is applied multiplicatively with the source colour, in this case the source colour is whatever colour has been set using formatting tags in the input text string.

This script sets part of Scribble's global state. All text drawn with [`scribble_draw()`](scribble_draw) or cached with [`scribble_cache()`](scribble_cache) will use these settings until they're overwritten, either by calling this script again or by calling [`scribble_reset()`](scribble_reset) or [`scribble_set_state()`](scribble_set_state).
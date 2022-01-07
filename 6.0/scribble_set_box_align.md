`scribble_set_box_align(halign, valign)`

**Returns:** N/A (`0`)

|Argument|Name    |Purpose                                                               |
|--------|--------|----------------------------------------------------------------------|
|0       |`halign`|Horizontal alignment of the **entire textbox** relative to the draw coordinate. Accepts `fa_left`, `fa_right`, and `fa_center`|
|1       |`valign`|Vertical alignment of the **entire textbox** relative to the draw coordinate. Accepts `fa_top`, `fa_bottom`, and `fa_middle`|

This script sets part of Scribble's global state. All text drawn with [`scribble_draw()`](scribble_draw) or cached with [`scribble_cache()`](scribble_cache) will use these settings until they're overwritten, either by calling this script again or by calling [`scribble_reset()`](scribble_reset) or [`scribble_set_state()`](scribble_set_state).
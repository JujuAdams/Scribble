`scribble_set_transform(xscale, yscale, angle)`

**Returns:** N/A (`0`)

|Argument|Name    |Purpose                           |
|--------|--------|----------------------------------|
|0       |`xscale`|x scale of the text element       |
|1       |`yscale`|y scale of the text element       |
|2       |`angle` |rotation angle of the text element|

The transform operates relative to the origin of the text element i.e. rotation will happen using the origin as the centre of rotation. [`scribble_set_box_align()`](scribble_set_box_align) can be used to draw text offset from the origin.

This script sets part of Scribble's global state. All text drawn with [`scribble_draw()`](scribble_draw) or cached with [`scribble_cache()`](scribble_cache) will use these settings until they're overwritten, either by calling this script again or by calling [`scribble_reset()`](scribble_reset) or [`scribble_set_state()`](scribble_set_state).
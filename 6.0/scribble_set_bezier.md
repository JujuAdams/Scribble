`scribble_set_bezier(x1, y1, x2, y2, x3, y3, x4, y4)`

**Returns:** N/A (`0`)

|Argument|Name|Purpose                             |
|--------|----|------------------------------------|
|0       |`x1`|Parameter for the cubic Bézier curve|
|1       |`y1`|"                                   |
|2       |`x2`|"                                   |
|3       |`y2`|"                                   |
|4       |`x3`|"                                   |
|5       |`y3`|"                                   |
|6       |`x4`|"                                   |
|7       |`y4`|"                                   |

This function defines a [cubic Bézier curve](https://en.wikipedia.org/wiki/B%C3%A9zier_curve) to shape text to. The four x/y coordinate pairs provide a smooth curve that Scribble uses as a guide to position and rotate glyphs.

**The curve is positioned relative to the coordinate specified when calling** [`scribble_draw()`](scribble_draw) **so that the first Bézier coordinate is at the draw coordinate**. This enables you to move a curve without re-adjusting the values set in `scribble_set_bezier()` (which would regenerate the text element, likely causing performance problems).

If used in conjunction with [`scribble_set_wrap()`](scribble_set_wrap), the total length of the curve is used to wrap text horizontally and overrides the value specified in [`scribble_set_wrap()`](scribble_set_wrap). `scribble_set_bezier()` will not work with `[fa_right]` or `[fa_center]` alignment. Instead, you should use `[pin_right]` and `[pin_center]`.
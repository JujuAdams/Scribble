# Bezier Curves

&nbsp;

## `.bezier()`

**Text Element Method:** `.bezier(x1, y1, x2, y2, x3, y3, x4, y4)`

**Returns**: The text element

|Name|Datatype|Purpose                             |
|----|--------|------------------------------------|
|`x1`|number  |Parameter for the cubic Bézier curve|
|`y1`|number  |As above                            |
|`x2`|number  |As above                            |
|`y2`|number  |As above                            |
|`x3`|number  |As above                            |
|`y3`|number  |As above                            |
|`x4`|number  |As above                            |
|`y4`|number  |As above                            |

This function defines a [cubic Bézier curve](https://en.wikipedia.org/wiki/B%C3%A9zier_curve) to shape text to. The four x/y coordinate pairs provide a smooth curve that Scribble uses as a guide to position and rotate glyphs.

**The curve is positioned relative to the coordinate specified when calling** [`.draw()`](scribble) **so that the first Bézier coordinate is at the draw coordinate**. This enables you to move a curve without re-adjusting the values set in `.bezier()` (which would regenerate the text element, likely causing performance problems).

If used in conjunction with `.wrap()`, the total length of the curve is used to wrap text horizontally and overrides the value specified in `.wrap()`. `.bezier()` will not work with `[fa_right]` or `[fa_center]` alignment. Instead, you should use `[pin_right]` and `[pin_center]`.

This function can also be executed with zero arguments (e.g. `scribble("text").bezier()`) to turn off the Bézier curve for this text element.

!> This method is a regenerator. If the value is changed then the text element will be regenerated, potentially leading to degraded performance.
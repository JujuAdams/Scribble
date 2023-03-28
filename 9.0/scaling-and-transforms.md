# Position, Scaling, and Transforms

&nbsp;

## `scribble_font_scale(fontName, scale)`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                                |
|----------|--------|---------------------------------------|
|`fontName`|string  |Name of the font to modify, as a string|
|`scale`   |number  |Scaling factor to apply                |

Scales every glyph in a font (including the space character) by the given factor. This directly modifies glyph properties for the font.

?> Existing text elements that use the targetted font will not be immediately updated - you will need to refresh those text elements.

&nbsp;

## `[scale,<factor>]`

**Command tag.** Set text (and in-line sprite) scale.

&nbsp;

## `[scaleStack,<factor>]`

**Command tag.** Set text (and in-line sprite) scale.

&nbsp;

## `[/scale]` `[/s]`

**Command tag.** Reset scale to x1.

&nbsp;

## `[slant]` `[/slant]`

**Command tag.** Set/unset italic emulation. The size of the x offset is controlled by [`SCRIBBLE_SLANT_AMOUNT`](configuration).

&nbsp;

## `.scale(factor)`

**Returns**: The text element

|Name    |Datatype|Purpose                                                                         |
|--------|--------|--------------------------------------------------------------------------------|
|`factor`|real    |Scaling factor to apply to the text element. `1.0` represents no change in scale|

Adds a scaling factor to a text element. This is applied **before** text layout and multiplicatively with `[scale]` tags; as a result, setting a scale with the method will affect text wrapping (if enabled).

!> This method is a *regenerator*. If the value is changed then the text element will be regenerated, potentially leading to degraded performance. Try not to change the colour of text using this method often.

&nbsp;

## `.post_transform(xscale, yscale, angle)`

**Returns**: The text element

|Name    |Datatype|Purpose                           |
|--------|--------|----------------------------------|
|`xscale`|real    |x scale of the text element       |
|`yscale`|real    |y scale of the text element       |
|`angle` |real    |rotation angle of the text element|

Rotates and scales a text element relative to the origin (set by [`.origin()`](scribble-methods?id=originx-y)). This transformation is applied **after** text layout and should be used to animate e.g. pop-in animations. If you'd like to apply a scaling factor before text layout, please use `.scale()`.

!> This method is a *regenerator*. If the value is changed then the text element will be regenerated, potentially leading to degraded performance. Try not to change the colour of text using this method often.

&nbsp;

## `.origin(x, y)`

**Returns**: The text element

|Name|Datatype|Purpose                                   |
|----|--------|------------------------------------------|
|`x` |real    |x-coordinate of the origin, in model space|
|`y` |real    |y-coordinate of the origin, in model space|

Sets the origin relative to the top-left corner of the text element. You can think of this similarly to a standard sprite's origin as set in the GameMaker IDE. Using this function with [`.get_width()`](scribble-methods?id=get_width) and [`.get_height()`](scribble-methods?id=get_height) will allow you to align the entire textbox as you see fit. Please note that this function may interact in unexpected ways with in-line alignment commands so some trial and error is necessary to get the effect you're looking for.

&nbsp;

## `.padding(left, top, right, bottom)` *regenerator*

**Returns**: The text element

|Name    |Datatype |Purpose                                                                            |
|--------|--------|------------------------------------------------------------------------------------|
|`left`  |number  |Extra space on the left-hand side of the textbox. Positive values create more space |
|`top`   |number  |Extra space on the top of the textbox. Positive values create more space            |
|`right` |number  |Extra space on the right-hand side of the textbox. Positive values create more space|
|`bottom`|number  |Extra space on the bottom of the textbox. Positive values create more space         |

&nbsp;

## `.skew(skewX, skewY)`

**Returns**: The text element

|Name   |Datatype|Purpose                                                                                                 |
|-------|--------|--------------------------------------------------------------------------------------------------------|
|`skewX`|real    |Skew factor contributed by x-coordinate of glyphs in the text element. A value is `0` confers no skewing|
|`skewY`|real    |Skew factor contributed by y-coordinate of glyphs in the text element. A value of `0` confers no skewing|

Skews glyph positions relative to the origin (set by [`.origin()`](scribble-methods?id=originx-y)).

&nbsp;

## `.line_height(min, max)` *regenerator*

**Returns**: The text element

|Name |Datatype|Purpose                                                                                                                               |
|-----|--------|--------------------------------------------------------------------------------------------------------------------------------------|
|`min`|number  |Minimum line height for each line of text. Use a negative number (the default) for the height of a space character of the default font|
|`max`|number  |Maximum line height for each line of text. Use a negative number (the default) for no limit                                           |

Sets limits on the height of each line for the text element. This is useful when mixing and matching fonts that aren't necessarily perfectly sized to each other.

&nbsp;

## `.line_spacing(spacing)` *regenerator*

**Returns**: The text element

|Name     |Datatype     |Purpose                                                                                             |
|---------|-------------|----------------------------------------------------------------------------------------------------|
|`spacing`|number/string|The spacing from one line of text to the next. Can be a number, or a percentage string e.g. `"100%"`|

If a number is passed to this method then a fixed line spacing is used. If a string is passed to this method then it must be a percentage string indication the fraction of the line height to use for spacing (`"100%"` being normal spacing, `"200%"` being double spacing). The default value is `"100%"`

?> The term "spacing" is being used a little inaccurately here. The value that is being adjusted is more properly called ["leading"](https://99designs-blog.imgix.net/blog/wp-content/uploads/2014/06/Leading1.png?auto=format&q=60&fit=max&w=930) (as in the metal).

&nbsp;
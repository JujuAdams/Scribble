# `scribble()` Methods

&nbsp;

`scribble()` is the heart of Scribble Deluxe and is responsible for managing the underlying systems.

When you call `scribble()`, the function searches Scribble's internal cache and will return the text element that matches the string you gave the function (and also matches the unique ID too, if you specified one). If the cache doesn't contain a matching string then a new text element is created and returned instead.

**Even small changes in a string may cause a new text element to be generated automatically.** Scribble Deluxe is pretty fast, but you don't want to use it for text that changes rapidly (e.g. health points, money, or score) as this will cause Scribble to do a lot of work, potentially slowing down your game.

Each text element can be altered by calling methods. Most methods return the text element itself. This allows you to chain methods together, achieving a [fluent interface](https://en.wikipedia.org/wiki/Fluent_interface). Some methods are marked as "regenerator methods". Setting new, different values for a piece of text using a regenerator method will cause Scribble to regenerate the underlying vertex buffers. For the sake of performance, avoid frequently changing values for regenerator methods as this will cause performance problems.

Don't worry about clearing up after yourself when you draw text - Scribble automatically manages memory for you. If you *do* want to manually control how memory is used, please use the [`.flush()`](scribble-methods?id=flush) method and [`scribble_flush_everything()`](misc-functions?id=scribble_flush_everything). Please be aware that it is not possible to serialise/deserialise Scribble text elements for e.g. a save system.

&nbsp;

## `scribble(string, [uniqueID])`

**Returns:** A text element that contains the string (a struct, an instance of `__scribble_class_element`)

|Name        |Datatype      |Purpose               |
|------------|--------------|----------------------|
|`string`    |string        |String to draw        |
|`[uniqueID]`|string or real|ID to reference a specific unique occurrence of a text element. Defaults to [`SCRIBBLE_DEFAULT_UNIQUE_ID`](configuration)|

Scribble allows for many kinds of inline formatting tags. Please read the [Text Formatting](text-formatting) article for more information.

?> Scribble text elements have **no publicly accessible variables**. Do not directly read or write variables, use the setter and getter methods provided instead.

Text element methods are broken down into several categories. There's a lot here; feel free to swing by the [Discord server](https://discord.gg/8krYCqr) if you'd like some pointers on what to use and when. As noted above, **be careful when adjusting regenerator methods** as it's easy to cause to performance problems.

&nbsp;

# Basics

## `.draw(x, y, [typist])`

**Returns**: N/A (`undefined`)

|Name      |Datatype|Purpose                          |
|----------|--------|---------------------------------|
|`x`       |real    |x position in the room to draw at|
|`y`       |real    |y position in the room to draw at|
|`[typist]`|typist  |Optional. Typist being used to render the text element. See [`scribble_typist()`](typist-methods) for more information.|

Draws your text! This function will automatically build the required text model if required. For very large amounts of text this may cause a slight hiccup in your framerate - to avoid this, split your text into smaller pieces or manually call the [`.build()`](scribble-methods?id=buildfreeze) method during a loading screen etc.

&nbsp;

## `.starting_format(fontName, colour)` *regenerator*

**Returns**: The text element

|Name      |Datatype|Purpose                                                                                                                                 |
|----------|--------|----------------------------------------------------------------------------------------------------------------------------------------|
|`fontName`|string  |Name of the starting font, as a string. This is the font that is set when `[/]` or `[/font]` is used in a string                        |
|`colour`  |integer |Starting colour in the standard GameMaker 24-bit BGR format. This is the colour that is set when `[/]` or `[/color]` is used in a string|

Sets the starting font and text colour for your text. The values that are set with `.starting_format()` are applied if you use the [`[/] or [/f] or [/c]` command tags](text-formatting) to reset your text format.

&nbsp;

## `.align(halign, valign)` *regenerator*

**Returns**: The text element

|Name    |Datatype                                                                                                                  |Purpose                                                                                               |
|--------|--------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
|`halign`|[halign constant](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/draw_set_halign.htm)|Starting horizontal alignment of **each line** of text. Accepts `fa_left`, `fa_right`, and `fa_center`|
|`valign`|[valign constant](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/draw_set_valign.htm)|Starting vertical alignment of the **entire textbox**. Accepts `fa_top`, `fa_bottom`, and `fa_middle` |

Sets the starting horizontal and vertical alignment for your text. You can change alignment using in-line [command tags](text-formatting) as well, though do note there are some limitations when doing so.

&nbsp;

## `.blend(colour, alpha)`

**Returns**: The text element

|Name    |Datatype|Purpose                                                                         |
|--------|--------|--------------------------------------------------------------------------------|
|`colour`|integer |Blend colour used when drawing text, applied multiplicatively                   |
|`alpha` |real    |Alpha used when drawing text, 0 being fully transparent and 1 being fully opaque|

Sets the blend colour/alpha, which is applied at the end of the drawing pipeline. This is a little different to the interaction between [`draw_set_color()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Colour_And_Alpha/draw_set_colour.htm) and [`draw_text()` functions](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/Text.htm). Scribble's blend colour is instead similar to [`draw_sprite_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Sprites_And_Tiles/draw_sprite_ext.htm)'s behaviour: The blend colour/alpha is applied multiplicatively with the source colour, in this case the source colour is whatever colour has been set using formatting tags in the input text string.

&nbsp;

## `.gradient(colour, blendFactor)`

**Returns**: The text element

|Name         |Datatype|Purpose                                                                                                                                          |
|-------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------|
|`colour`     |integer |Colour of the **bottom** of the gradient for each glyph                                                                                          |
|`blendFactor`|real    |Blending factor for the gradient, from `0` (no gradient applied) to `1` (base blend colour of the bottom of each glyph is replaced with `colour`)|

Sets up a gradient blend for each glyph in the text element. The base blend colour (defined by a combination of `.blend()` and in-line colour modification) is the top of the gradient and the colour defined by this method is the bottom of the gradient.

&nbsp;

## `.flash(colour, blendFactor)`

**Returns**: The text element

|Name         |Datatype|Purpose                                                  |
|-------------|--------|---------------------------------------------------------|
|`colour`     |integer |Flash colour, in the standard GameMaker 24-bit BGR format|
|`blendFactor`|real    |Blending factor for the flash, from 0 to 1               |

Forces the colour of all text (and sprites) to change to the given specified colour. This will override any effects (rainbow / colour cycling), gradient, or other colour effects.

&nbsp;

&nbsp;

&nbsp;

# Layout

## `.scale(factor)` *regenerator*

**Returns**: The text element

|Name    |Datatype|Purpose                                                                         |
|--------|--------|--------------------------------------------------------------------------------|
|`factor`|real    |Scaling factor to apply to the text element. `1.0` represents no change in scale|

Adds a scaling factor to a text element. This is applied **before** text layout and multiplicatively with `[scale]` tags; as a result, setting a scale with the method will affect text wrapping (if enabled).

## `.origin(x, y)`

**Returns**: The text element

|Name|Datatype|Purpose                                   |
|----|--------|------------------------------------------|
|`x` |real    |x-coordinate of the origin, in model space|
|`y` |real    |y-coordinate of the origin, in model space|

Sets the origin relative to the top-left corner of the text element. You can think of this similarly to a standard sprite's origin as set in the GameMaker IDE. Using this function with [`.get_width()`](scribble-methods?id=get_width) and [`.get_height()`](scribble-methods?id=get_height) will allow you to align the entire textbox as you see fit. Please note that this function may interact in unexpected ways with in-line alignment commands so some trial and error is necessary to get the effect you're looking for.

&nbsp;

## `.transform(xscale, yscale, angle)`

**Returns**: The text element

|Name    |Datatype|Purpose                           |
|--------|--------|----------------------------------|
|`xscale`|real    |x scale of the text element       |
|`yscale`|real    |y scale of the text element       |
|`angle` |real    |rotation angle of the text element|

Rotates and scales a text element relative to the origin (set by [`.origin()`](scribble-methods?id=originx-y)).

!> This transformation is applied **after** text layout and should be used to animate e.g. pop-in animations. If you'd like to apply a scaling factor before text layout, please use `.scale()`

&nbsp;

## `.skew(skewX, skewY)`

**Returns**: The text element

|Name   |Datatype|Purpose                                                                                                 |
|-------|--------|--------------------------------------------------------------------------------------------------------|
|`skewX`|real    |Skew factor contributed by x-coordinate of glyphs in the text element. A value is `0` confers no skewing|
|`skewY`|real    |Skew factor contributed by y-coordinate of glyphs in the text element. A value of `0` confers no skewing|

Skews glyph positions relative to the origin (set by [`.origin()`](scribble-methods?id=originx-y)).

&nbsp;

## `.scale_to_box(maxWidth, maxHeight, [maximise])`

**Returns**: The text element

|Name        |Datatype|Purpose                                                                                                  |
|------------|--------|---------------------------------------------------------------------------------------------------------|
|`maxWidth`  |real    |Maximum width of the bounding box to fit the text into. Use a negative number (the default) for no limit |
|`maxHeight` |real    |Maximum height of the bounding box to fit the text into. Use a negative number (the default) for no limit|
|`[maximise]`|boolean |Allows the scaling algorithm to increase the scale as well as decreasing. Defaults to `false`            |

Scales the text element such that it always fits inside the maximum width and height specified. Scaling is equal in both the x and y axes. This behaviour does not recalculate text wrapping so will not re-flow text. `.scale_to_box()` is a simple scaling operation therefore, and one that is best used for single lines of text (e.g. for buttons).

&nbsp;

## `.wrap(maxWidth, [maxHeight], [characterWrap])` *regenerator*

**Returns**: The text element

|Name             |Datatype|Purpose                                                                                                                                         |
|-----------------|--------|------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`       |integer |Maximum width for the whole textbox. Use a negative number (the default) for no limit                                                           |
|`[maxHeight]`    |integer |Maximum height for the whole textbox. Use a negative number (the default) for no limit                                                          |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for tight textboxes and some East Asian languages|

Instructs Scribble to fit text inside a box by automatically inserting line breaks and page breaks where necessary. Scribble's text wrapping operates in a very similar way to GameMaker's native [`draw_text_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/draw_text_ext.htm). If text exceeds the horizontal maximum width then text will be pushed onto the next line. If text exceeds the maximum height of the textbox then a new page will be created (see [`.page()`](scribble-methods?id=pagepage) and [`.get_page()`](scribble-methods?id=get_page)). Very long sequences of glyphs without spaces will be split across multiple lines.

&nbsp;

## `.fit_to_box(maxWidth, maxHeight, [characterWrap])` *regenerator*

**Returns**: The text element

|Name             |Datatype|Purpose                                                                                                                                              |
|-----------------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`       |integer |Maximum width for the whole textbox                                                                                                                  |
|`maxHeight`      |integer |Maximum height for the whole textbox                                                                                                                 |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for very tight textboxes and some East Asian languages|

Fits text to a box by inserting line breaks and scaling text but **will not** insert any page breaks. Text will take up as much space as possible without starting a new page. The macro `SCRIBBLE_FIT_TO_BOX_ITERATIONS` controls how many iterations to perform (higher is slower but more accurate).

!> N.B. This function is slow and should be used sparingly. It is recommended you manually cache text elements when using `.fit_to_box()`.

&nbsp;

## `.pin_guide_width(width)` *regenerator*

**Returns**: The text element

|Name   |Datatype|Purpose                                                                                                                         |
|-------|--------|--------------------------------------------------------------------------------------------------------------------------------|
|`width`|integer |Width to use for pin-type alignments. Use a negative number (the default) to use the width of the text instead of a fixed number|

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

## `.padding(left, top, right, bottom)` *regenerator*

**Returns**: The text element

|Name    |Datatype |Purpose                                                                            |
|--------|--------|------------------------------------------------------------------------------------|
|`left`  |number  |Extra space on the left-hand side of the textbox. Positive values create more space |
|`top`   |number  |Extra space on the top of the textbox. Positive values create more space            |
|`right` |number  |Extra space on the right-hand side of the textbox. Positive values create more space|
|`bottom`|number  |Extra space on the bottom of the textbox. Positive values create more space         |

&nbsp;

## `.bezier(x1, y1, x2, y2, x3, y3, x4, y4)` *regenerator*

**Returns**: The text element

|Name|Datatype|Purpose                             |
|----|--------|------------------------------------|
|`x1`|real    |Parameter for the cubic Bézier curve|
|`y1`|real    |"                                   |
|`x2`|real    |"                                   |
|`y2`|real    |"                                   |
|`x3`|real    |"                                   |
|`y3`|real    |"                                   |
|`x4`|real    |"                                   |
|`y4`|real    |"                                   |

This function defines a [cubic Bézier curve](https://en.wikipedia.org/wiki/B%C3%A9zier_curve) to shape text to. The four x/y coordinate pairs provide a smooth curve that Scribble uses as a guide to position and rotate glyphs.

**The curve is positioned relative to the coordinate specified when calling** [`.draw()`](scribble-methods?id=drawx-y) **so that the first Bézier coordinate is at the draw coordinate**. This enables you to move a curve without re-adjusting the values set in `.bezier()` (which would regenerate the text element, likely causing performance problems).

If used in conjunction with [`.wrap()`](scribble-methods?id=wrapmaxwidth-maxheight-characterwrap-regenerator), the total length of the curve is used to wrap text horizontally and overrides the value specified in [`.wrap()`](scribble-methods?id=wrapmaxwidth-maxheight-characterwrap-regenerator). `.bezier()` will not work with `[fa_right]` or `[fa_center]` alignment. Instead, you should use `[pin_right]` and `[pin_center]`.

This function can also be executed with zero arguments (e.g. `scribble("text").bezier()`) to turn off the Bézier curve for this text element.

&nbsp;

## `.right_to_left(state)` *regenerator*

**Returns**: The text element

|Name    |Datatype|Purpose                                            |
|--------|--------|---------------------------------------------------|
|`state` |boolean |Whether the overall text direction is right-to-left|

Hints to the text parser whether the overall text direction is right-to-left (`true`) or left-to-right (`false`). This method also accepts an input of `undefined` to use the default behaviour whereby Scribble attempts to figure out the overall text direction based on the first glyph in the string.

&nbsp;

&nbsp;

&nbsp;

# Regions

## `.region_detect(elementX, elementY, pointerX, pointerY)`

**Returns:** String, the name of the region that is being pointed to, or `undefined` if no region is being pointed to

|Name      |Datatype|Purpose                                                                                                    |
|----------|--------|-----------------------------------------------------------------------------------------------------------|
|`elementX`|number  |x position of the text element in the room (usually the same as the coordinate you'd specify for `.draw()`)|
|`elementY`|number  |y position of the text element in the room (usually the same as the coordinate you'd specify for `.draw()`)|
|`pointerX`|number  |x position of the mouse/cursor                                                                             |
|`pointerY`|number  |y position of the mouse/cursor                                                                             |

This function returns the name of a region if one is being hovered over. You can define a region in your text by using the `[region,<name>]` and `[/region]` formatting tags.

!> Using this function requires that `SCRIBBLE_ALLOW_GLYPH_DATA_GETTER` be set to `true`.

&nbsp;

## `.region_set_active(name, colour, blendAmount)`

**Returns:** N/A (`undefined`)

|Name         |Datatype|Purpose                                                                |
|-------------|--------|-----------------------------------------------------------------------|
|`name`       |string  |Name of the region to highlight. Use `undefined` to highlight no region|
|`colour`     |integer |Colour to highlight the region (a standard GameMaker BGR colour)       |
|`blendAmount`|number  |Blend factor to apply for the highlighted region                       |

This function expects the name of a region that has been defined in your text using the `[region,<name>]` and `[/region]` formatting tags. You can get the name of the region that the player is currently highlighting with their cursor by using `.region_detect()`.

&nbsp;

## `.region_get_active()`

**Returns:** String, the name of the active region, or `undefined` if no region is active

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

&nbsp;

&nbsp;

# Dimensions

## `.get_left(x)`

**Returns:** Real, the left position of the text element's axis-aligned bounding box in the room

|Name|Datatype|Purpose                                   |
|----|--------|------------------------------------------|
|`x` |real    |x position of the text element in the room|

This function takes into account the transformation and padding applied to the text element.

If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

&nbsp;

## `.get_top(y)`

**Returns:** Real, the top position of the text element's axis-aligned bounding box in the room

|Name|Datatype|Purpose                                   |
|----|--------|------------------------------------------|
|`y` |real    |y position of the text element in the room|

This function takes into account the transformation and padding applied to the text element.

If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

&nbsp;

## `.get_right(x)`

**Returns:** Real, the right position of the text element's axis-aligned bounding box in the room

|Name|Datatype|Purpose                                   |
|----|--------|------------------------------------------|
|`x` |real    |x position of the text element in the room|

This function takes into account the transformation and padding applied to the text element.

If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

&nbsp;

## `.get_bottom(y)`

**Returns:** Real, the bottom position of the text element's axis-aligned bounding box in the room

|Name|Datatype|Purpose                                   |
|----|--------|------------------------------------------|
|`y` |real    |y position of the text element in the room|

This function takes into account the transformation and padding applied to the text element.

If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

&nbsp;

## `.get_width()`

**Returns:** Real, width of the text element in pixels (ignoring rotation and scaling)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

!> This function returns the untransformed width of the text element. This will **not** take into account rotation or scaling applied by the `.transform()` method but will take into account padding.

&nbsp;

## `.get_height()`

**Returns:** Real, height of the text element in pixels (ignoring rotation and scaling)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

!> This functions returns the untransformed height of the text element. This will **not** take into account rotation or scaling applied by the `.transform()` method but will take into account padding.

&nbsp;

## `.get_bbox(x, y)`

**Returns:** Struct containing the positions of the bounding box for a text element

|Name|Datatype|Purpose               |
|----|--------|----------------------|
|`x` |real    |x position in the room|
|`y` |real    |y position in the room|

This functions returns the **transformed** width and height of the text element. This **will** take into account rotation or scaling applied by the `.transform()` method as well as padding. If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

The struct returned by `.get_bbox()` contains the following member variables:

|Variable        |Purpose                                      |
|----------------|---------------------------------------------|
|`x`             |x position passed into the `.get_bbox()` call|
|`y`             |y position passed into the `.get_bbox()` call|
|**Axis-aligned**|                                             |
|`left`          |Axis-aligned lefthand boundary               |
|`top`           |Axis-aligned top boundary                    |
|`right`         |Axis-aligned righthand boundary              |
|`bottom`        |Axis-aligned bottom boundary                 |
|`width`         |Axis-aligned width of the bounding box       |
|`height`        |Axis-aligned height of the bounding box      |
|**Oriented**    |                                             |
|`x0`            |x position of the top-left corner            |
|`y0`            |y position of the top-left corner            |
|`x1`            |x position of the top-right corner           |
|`y1`            |y position of the top-right corner           |
|`x2`            |x position of the bottom-left corner         |
|`y2`            |y position of the bottom-left corner         |
|`x3`            |x position of the bottom-right corner        |
|`y3`            |y position of the bottom-right corner        |

&nbsp;

## `.get_bbox_revealed(x, y, [typist])`

**Returns:** Struct containing the positions of the bounding box for a text element

|Name    |Datatype|Purpose                                                                                                                     |
|--------|--------|----------------------------------------------------------------------------------------------------------------------------|
|`x`     |number  |x position in the room                                                                                                      |
|`y`     |number  |y position in the room                                                                                                      |
|`typist`|typist  |Typist being used to render the text element. If not specified, the manual reveal value is used instead (set by `.reveal()`)|

The struct returned by `.get_bbox_revealed()` contains the same member variables as `.get_bbox()`; see above for details. Only text that is visible will be considered for calculating the bounding boxes.

This functions returns the **transformed** width and height of the text element. This **will** take into account rotation or scaling applied by the `.transform()` method as well as padding.

&nbsp;

&nbsp;

&nbsp;

# Other Getters

## `.get_wrapped()`

**Returns:** Boolean, whether the text has wrapped onto a new line using the [`.wrap()` feature](scribble-methods?id=wrapmaxwidth-maxheight-characterwrap-regenerator)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Will return `true` only if the [`.wrap()` feature](scribble-methods?id=wrapmaxwidth-maxheight-characterwrap-regenerator) is used. Manual newlines (`\n`) included in the input string will **not** cause this function to return `true`.

&nbsp;

## `.get_text([page])`

**Returns:** String, the parsed string for the given page

|Name    |Datatype|Purpose                                                                  |
|--------|--------|-------------------------------------------------------------------------|
|`[page]`|integer |Page to get the raw text from. If not specified, the current page is used|

The string that is returned is the raw text that is drawn i.e. all command tags and events have been stripped out. Sprites and surfaces are represented by a single glyph with the Unicode value of `26` ([`0x001A` "substitute character"](https://unicode-table.com/en/001A/)).

&nbsp;

## `.get_glyph_data(glyphIndex, [page])`

**Returns:** Struct, containing layout details for the glyph on the given page (see below)

|Name        |Datatype|Purpose                                                                    |
|------------|--------|---------------------------------------------------------------------------|
|`glyphIndex`|integer |Index of the glyph whose data will be returned                             |
|`[page]`    |integer |Page to get the glyph data from. If not specified, the current page is used|

The struct that is returned has the following member variables:

|Name      |Datatype|Purpose                                                       |
|----------|--------|--------------------------------------------------------------|
|`unicode` |integer |The Unicode character code for the glyph. Sprites and surfaces are represented by a single glyph with the Unicode value of `26` ([`0x001A` "substitute character"](https://unicode-table.com/en/001A/))                     |
|`left`    |number  |Left x-position of the glyph, relative to the model's origin  |
|`top`     |number  |Top y-position of the glyph, relative to the model's origin   |
|`right`   |number  |Right x-position of the glyph, relative to the model's origin |
|`bottom`  |number  |Bottom y-position of the glyph, relative to the model's origin|

&nbsp;

## `.get_glyph_count([page])`

**Returns:** Integer, the number of glyphs on the given page

|Name        |Datatype|Purpose                                                                     |
|------------|--------|----------------------------------------------------------------------------|
|`[page]`    |integer |Page to get the glyph count from. If not specified, the current page is used|

&nbsp;

## `.get_line_count([page])`

**Returns:** Integer, how many lines of text are on the given page

|Name    |Datatype|Purpose                                                                                  |
|--------|--------|-----------------------------------------------------------------------------------------|
|`[page]`|Integer |Page to retrieve the number of lines for. Defaults to the current page that's being shown|

&nbsp;

&nbsp;

&nbsp;

# Pages

## `.page(page)`

**Returns**: The text element

|Name  |Datatype|Purpose                                          |
|------|--------|-------------------------------------------------|
|`page`|integer |Page to display, starting at 0 for the first page|

Changes which page Scribble is display for the text element. Pages are created when using the [`.wrap()` method](scribble-methods?id=wrapmaxwidth-maxheight-characterwrap-regenerator) or when inserting [`[/page] command tags`](text-formatting) into your input string. Pages are 0-indexed.

Please note that changing the page will reset any typewriter animations started by a [typist](typist-methods) associated with the text element.

&nbsp;

## `.get_page()`

**Returns:** Integer, page that the text element is currently on, starting at `0` for the first page

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Returns which page Scribble is showing, as set by [`.page()`](scribble-methods?id=pagepage). Pages are 0-indexed; this function will return `0` for the first page.

&nbsp;

## `.get_page_count()`

**Returns:** Integer, total number of pages for the text element

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Returns the total number of pages that this text element contains. In rare cases, this function can return 0.

&nbsp;

## `.on_last_page()`

**Returns:** Boolean, whether the current page is the last page for the text element

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Convenience function.

&nbsp;

&nbsp;

&nbsp;

# Typewriter

?> The old typewriter methods [have been deprecated](legacy-typewriter). Instead, please use [`scribble_typist()`](typist-methods). You may also use the following two functions for very simple typewriter effects.

## `.reveal(character)`

**Returns:** The text element

|Name       |Datatype|Purpose                           |
|-----------|--------|----------------------------------|
|`character`|number  |The number of characters to reveal|

&nbsp;

## `.get_reveal()`

**Returns:** Number, the amount of characters revealled, as set by `.reveal()`

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

&nbsp;

&nbsp;

# Animation

!> Most of the old animation methods have been moved to global scope. Please see the [Animation Properties](animation-properties) page for details.

## `.animation_speed(speed)`

**Returns**: The text element

|Name   |Datatype|Purpose                                                                                               |
|-------|--------|------------------------------------------------------------------------------------------------------|
|`speed`|number  |The animation speed multiplier where `1` is normal speed, `2` is double speed, and `0.5` is half speed|

Setting the animation speed value to `0` will pause animation effects. This value can even be negative to play effects backwards!

?> This setting does not impact [typists](typist-methods). Instead, please use the [`.pause()`](typist-methods?id=pause) typist method to pause typists.

&nbsp;

## `.get_animation_speed()`

**Returns**: The current animation speed

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

The value returned from this function defaults to `1`.

&nbsp;

&nbsp;

&nbsp;

# Outlines & Shadows

## `.shadow(colour, alpha)`

**Returns**: The text element

|Name    |Datatype|Purpose                                                                                                  |
|--------|--------|---------------------------------------------------------------------------------------------------------|
|`colour`|integer |The colour of the shadow, as a standard GameMaker 24-bit BGR format                                      |
|`alpha` |number  |Opacity of the shadow, `0.0` being transparent and `1.0` being fully opaque                              |

Sets the colour, alpha, and offset for a shadow for a font created by `scribble_font_bake_outline_and_shadow()`. This method will not affect other kinds of fonts. Setting the alpha to `0` will prevent the shadow from being drawn at all.

?> This method is intended for use only with fonts created by `scribble_font_bake_outline_and_shadow()`. If you'd like to add shadows to SDF fonts, use the SDF-specific variant `.sdf_shadow()` explained below.

&nbsp;

## `.outline(colour)`

**Returns**: The text element

|Name    |Datatype|Purpose                                                                 |
|--------|--------|------------------------------------------------------------------------|
|`colour`|integer |Colour of the glyph's outline, as a standard GameMaker 24-bit BGR format|

Sets the colour of an outline for a font created by `scribble_font_bake_outline_and_shadow()`. This method will not affect other kinds of fonts.

?> This method is intended for use only with fonts created by `scribble_font_bake_outline_and_shadow()`. If you'd like to add outlines to SDF fonts, use the SDF-specific variant `.sdf_outline()` explained below.

&nbsp;

## `.sdf_shadow(colour, alpha, xoffset, yoffset, [softness])`

**Returns**: The text element

|Name      |Datatype|Purpose                                                                                                  |
|----------|--------|---------------------------------------------------------------------------------------------------------|
|`colour`  |integer |The colour of the shadow, as a standard GameMaker 24-bit BGR format                                      |
|`alpha`   |number  |Opacity of the shadow, `0.0` being transparent and `1.0` being fully opaque                              |
|`xoffset` |number  |x-coordinate of the shadow, relative to the parent glyph                                                 |
|`yoffset` |number  |y-coordinate of the shadow, relative to the parent glyph                                                 |
|`softness`|number  |Optional. Larger values give a softer edge to the shadow. If not specified, this will default to `0.1` (which draws an antialiased but clean shadow edge)|

Sets the colour, alpha, and offset for a procedural SDF shadow. Setting the alpha to `0` will prevent the shadow from being drawn at all. If you find that your shadow(s) are being clipped or cut off when using large offset values, increase the SDF spread for the font.

?> This method is intended for use only with SDF fonts. If you'd like to add a shadow to standard fonts or spritefonts, use `scribble_font_bake_outline_and_shadow()` and the non-SDF variant `.outline()` explained above.

&nbsp;

## `.sdf_outline(colour, thickness)`

**Returns**: The text element

|Name       |Datatype|Purpose                                                                 |
|-----------|--------|------------------------------------------------------------------------|
|`colour`   |integer |Colour of the glyph's outline, as a standard GameMaker 24-bit BGR format|
|`thickness`|real    |Thickness of the outline, in pixels                                     |

Sets the colour and thickness for a procedural SDF outline. Setting the thickness to `0` will prevent the outline from being drawn at all. If you find that your glyphs have filled (or partially filled) backgrounds, increase the SDF spread for the font.

?> This method is intended for use only with SDF fonts. If you'd like to add an outline to standard fonts or spritefonts, use `scribble_font_bake_outline_and_shadow()` and the non-SDF variant `.outline()` explained above.

&nbsp;

&nbsp;

&nbsp;

# Cache Management

## `.build(freeze)`

**Returns**: N/A (`undefined`)

|Name    |Datatype|Purpose                                   |
|--------|--------|------------------------------------------|
|`freeze`|boolean |Whether to freeze generated vertex buffers|

Forces Scribble to build the text model for this text element. Calling this method twice will do nothing even if e.g. a macro command tag would return a different value (please use `.refresh()` instead). You should call this function if you're pre-caching (a.k.a. "stashing") text elements e.g. during a loading screen. Freezing vertex buffers will speed up rendering considerably but has a large up-front cost.

As this function returns `undefined`, the intended use of this function is:

```
///Create
element = scribble("Example test").wrap(200); //Create a new text element, and wrap it to maximum 200px wide
element.build(true); //Now build the text element

///Draw
element.draw(x, y);
```

## `.refresh()`

**Returns**: N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Forces Scribble to rebuild the text model for this text element. This is particularly useful for situations where a stashed text element needs to update e.g. a macro command tag would return a different value.

&nbsp;

## `.flush()`

**Returns**: N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Forces Scribble to remove this text element from the internal cache, invalidating the text element. If you have manually cached a reference to a flushed text element, that text element will no longer be able to be drawn. Given that Scribble actively garbage collects used memory it is uncommon that you'd want to ever use this function, but if you want to tightly manage your memory, this function is available.

&nbsp;

&nbsp;

&nbsp;

# Preprocessor

## `.preprocessor(function)` *regenerator*

**Returns**: The text element

|Name      |Datatype|Purpose                                                                                                                                                           |
|----------|--------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`function`|function|The function to execute as a preprocessor. Set to `undefined` to use the global default preprocessor, or set to `SCRIBBLE_NO_PREPROCESS` to force no preprocessing|

A preprocessor function allows you to adjust a string being drawn by Scribble using custom code that goes beyond what Scribble can natively employ. A preprocessor function takes one argument which is the input string defined when calling `scribble()`. This string is literally the string passed to `scribble()` so it will include command tags. A preprocessor function will need to return the modified string using the standard `return` command.

Without intervention, a text element will use the global default preprocessor function as set by `scribble_default_preprocessor_set()`. Updating the global default preprocessor function will **not** automatically regenerate existing text elements so be careful how you use it (intention is to set-and-forget when the game starts).

A preprocessor function is called before Scribble does any processing, including Scribble macros, so it is maximally flexible. **The preprocessor function is only called once when a text element is cached.** This means that using a preprocessor to draw a variable that is liable to update during the lifetime of a text element will not lead to sastisfactory results. Because the preprocessor function is called when the text element is cached, the value that is found in the variable is "frozen" into the text model and will not change until the text element is regenerated by some means. *(If you want to have live updating variables, just modify the input string like you would with any other normal text drawing command.)*

An example pass-through preprocessor function (a function that does not modify the string) looks like this:

```gml
function(_string)
{
    return _string;
}
```

A more complicated preprocessor function that replaces `$123$` to follow the pattern `[spr_money][c_green]123[/c]` looks like this:

```gml
function(_string)
{
    var _split = string_split(_string, "$");
    var _i = array_length(_split)-2;
    repeat((array_length(_split)-1) div 2)
    {
        array_insert(_split, _i,   "[spr_money][c_green]");
        array_insert(_split, _i+1, "[/c]");
        _i -= 2;
    }
    
    return string_concat_ext(_split);
}
```

&nbsp;

&nbsp;

&nbsp;

# Miscellaneous

## `.get_events(position, [page])`

**Returns**: An array containing structs that describe typewrite events for the given character

|Name      |Datatype|Purpose                                                                    |
|----------|--------|---------------------------------------------------------------------------|
|`position`|integer |Character to get events for. See below for more details                    |
|`[page]`  |integer |The page to get events for. If not specified, the current page will be used|

To match GameMaker's native string behaviour for functions such as `string_copy()`, character positions are 1-indexed such that the character at position 1 in the string `"abc"` is `a`. Events are indexed such that an event placed immediately before a character has an index one less than the character. Events placed immediately after a character have an index equal to the character e.g. `"[event index 0]X[event index 1]"`.

The returned array contains structs that themselves contain the following member variables:

|Member Variable|Datatype        |Purpose                                                                                                  |
|---------------|----------------|---------------------------------------------------------------------------------------------------------|
|`.position`    |integer         |The character position for this event. This should (!) be the same as the index provided to get the event|
|`.name`        |string          |Name of the event e.g. `[ping, Hello!]` will set `.name` to `"ping"`                                     |
|`.data`        |array of strings|Contains the arguments provided for the event. Arguments will always be returned as strings e.g. `[move to, 20, -5]` will set `.data` to `["20", "-5"]`|

&nbsp;

## `.template(function, [executeOnlyOnChange])`

**Returns**: The text element

|Name                   |Datatype                       |Purpose                                                                            |
|-----------------------|-------------------------------|-----------------------------------------------------------------------------------|
|`function`             |function, or array of functions|Function to execute to set Scribble behaviour for this text element                |
|`[executeOnlyOnChange]`|boolean                        |Whether to only execute the template function if it has changed. Defaults to `true`|

Executes a function in the scope of this text element. If that function contains method calls then the methods will be applied to this text element. For example:

```
function example_template()
{
    wrap(150);
    blend(c_red, 1);
}

scribble("This text is red and will be wrapped inside a box that's 150px wide.").template(example_template).draw(10, 10);
```

&nbsp;

## `.ignore_command_tags(state)` *regenerator*

**Returns**: The text element

|Name   |Datatype|Purpose                       |
|-------|--------|------------------------------|
|`state`|boolean |Whether to ignore command tags|

Directs Scribble to ignore all [command tags](text-formatting) in the string and instead render them as plaintext.

&nbsp;

## `.randomize_animation(state)` *regenerator*

**Returns**: The text element

|Name   |Datatype|Purpose                                                |
|-------|--------|-------------------------------------------------------|
|`state`|boolean |Whether to randomize the order that glyphs are animated|

Setting this method to `true` will also randomize any and all effects. This includes typewriter effects achieved with typists or `.reveal()`, and also animated formatting via command tags such as `[shake]` `[rainbow]` etc.

&nbsp;

## `.z(z)`

**Returns**: The text element

|Name|Datatype|Purpose                                     |
|----|--------|--------------------------------------------|
|`z` |number  |The z coordinate to draw the text element at|

Controls the z coordinate to draw the text element at. This is largely irrelevant in 2D games, but this functionality is occasionally useful nonetheless. The z coordinate defaults to [`SCRIBBLE_DEFAULT_Z`](https://github.com/JujuAdams/Scribble/blob/docs/8.0/configuration.md).

&nbsp;

## `.get_z()`

**Returns**: Number, the z-position of the text element as set by `.z()`

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

## `.overwrite(string)` *regenerator*

**Returns**: The text element

|Name    |Datatype|Purpose                                     |
|--------|--------|--------------------------------------------|
|`string`|string  |New string to display using the text element|

Replaces the string in an existing text element.

!> This function may cause a recaching of the underlying text model so should be used sparingly. Do not be surprised if this method resets associated typists, invalidates text element state, or causes outright crashes.

&nbsp;

## `.pre_update_typist(typist)`

**Returns**: The text element

|Name     |Datatype|Purpose                                                                                                     |
|---------|--------|------------------------------------------------------------------------------------------------------------|
|`[typist]`|typist |Typist being used to render the text element. See [`scribble_typist()`](typist-methods) for more information|

Updates a typist associated with the text element. You will typically not need to call this method, but it is occasionally useful for resolving order-of-execution issues.

&nbsp;
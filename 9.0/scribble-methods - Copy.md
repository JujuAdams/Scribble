# `scribble()` Methods

&nbsp;

`scribble()` is the heart of Scribble and is responsible for managing the underlying systems.

When you call `scribble()`, the function searches Scribble's internal cache and will return the text element that matches the string you gave the function (and also matches the unique ID too, if you specified one). If the cache doesn't contain a matching string then a new text element is created and returned instead.

**Even small changes in a string may cause a new text element to be generated automatically.** Scribble is pretty fast, but you don't want to use it for text that changes rapidly (e.g. health points, money, or score) as this will cause Scribble to do a lot of work, potentially slowing down your game.

Each text element can be altered by calling methods, a new feature in [GMS2.3.0](https://www.yoyogames.com/blog/549/gamemaker-studio-2-3-new-gml-features). Most methods return the text element itself. This allows you to chain methods together, achieving a [fluent interface](https://en.wikipedia.org/wiki/Fluent_interface). Some methods are marked as "regenerator methods". Setting new, different values for a piece of text using a regenerator method will cause Scribble to regenerate the underlying vertex buffers. For the sake of performance, avoid frequently changing values for regenerator methods as this will cause performance problems.

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

## `.draw(x, y)`

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

&nbsp;

&nbsp;

# Positioning and Scaling

## `.right_to_left(state)` *regenerator*

**Returns**: The text element

|Name    |Datatype|Purpose                                            |
|--------|--------|---------------------------------------------------|
|`state` |boolean |Whether the overall text direction is right-to-left|

Hints to the text parser whether the overall text direction is right-to-left (`true`) or left-to-right (`false`). This method also accepts an input of `undefined` to use the default behaviour whereby Scribble attempts to figure out the overall text direction based on the first glyph in the string.

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

&nbsp;

&nbsp;

# Layout

## `.layout_free()` *regenerator*

**Returns**: The text element

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Resets any layout that has been set. A "free" layout will not constrain text positioning. Any `[/page]` tags will be respected, however, creating new pages of text that you can choose to display using the `.page()` method.

&nbsp;

## `.layout_guide(width)` *regenerator*

**Returns**: The text element

|Name   |Datatype|Purpose                                                                                                                         |
|-------|--------|--------------------------------------------------------------------------------------------------------------------------------|
|`width`|integer |Width to use for pin-type alignments. Use a negative number (the default) to use the width of the text instead of a fixed number|

A "guide" layout will not perform any text wrapping, but if text is determined to use predominantly a right-to-left orientation then the width set by this method will be used as the initial right-hand position of the text.

&nbsp;

## `.layout_wrap(maxWidth, [characterWrap])` *regenerator*

**Returns**: The text element

|Name             |Datatype|Purpose                                                                                                                                         |
|-----------------|--------|------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`       |number  |Maximum width for the whole textbox. Use a negative number (the default) for no limit                                                           |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for tight textboxes and some East Asian languages|

Instructs Scribble to fit text inside a box by automatically inserting line breaks where necessary. Scribble's text wrapping operates in a very similar way to GameMaker's native [`draw_text_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/draw_text_ext.htm). If text exceeds the horizontal maximum width then text will be pushed onto the next line. Very long sequences of glyphs without spaces will be split across multiple lines.

&nbsp;

## `.layout_wrap_split_pages(maxWidth, [maxHeight], [characterWrap])` *regenerator*

**Returns**: The text element

|Name             |Datatype|Purpose                                                                                                                                         |
|-----------------|--------|------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`       |number  |Maximum width for the whole textbox. Use a negative number (the default) for no limit                                                           |
|`maxHeight`      |number  |Maximum height for the whole textbox. Use a negative number (the default) for no limit                                                          |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for tight textboxes and some East Asian languages|

Instructs Scribble to fit text inside a box by automatically inserting line breaks and page breaks where necessary. Scribble's text wrapping operates in a very similar way to GameMaker's native [`draw_text_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/draw_text_ext.htm). If text exceeds the horizontal maximum width then text will be pushed onto the next line. If text exceeds the maximum height of the textbox then a new page will be created (see [`.page()`](scribble-methods?id=pagepage) and [`.get_page()`](scribble-methods?id=get_page)). Very long sequences of glyphs without spaces will be split across multiple lines.

&nbsp;

## `.layout_scale(maxWidth, maxHeight, [maxScale])`

**Returns**: The text element

|Name        |Datatype|Purpose                                                                                                               |
|------------|--------|----------------------------------------------------------------------------------------------------------------------|
|`maxWidth`  |number  |Maximum width of the bounding box to fit the text into. Use a negative number (the default) for no limit              |
|`maxHeight` |number  |Maximum height of the bounding box to fit the text into. Use a negative number (the default) for no limit             |
|`[maxScale]`|number  |Maximum scale that can be used which allows the algorithm to make text bigger. Defaults to `1`, no upscaling permitted|

Scales the text element such that it always fits inside the maximum width and height specified. Scaling is equal in both the x and y axes. This behaviour does not recalculate text wrapping so will not re-flow text. `.layout_scale()` is a simple scaling operation therefore, and one that is best used for single lines of text (e.g. for buttons).

&nbsp;

## `.layout_fit(maxWidth, maxHeight, [characterWrap], [maxScale])` *regenerator*

**Returns**: The text element

|Name        |Datatype|Purpose                                                                                                                                                   |
|------------|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`  |number  |Maximum width of the bounding box to fit the text into. Use a negative number (the default) for no limit                                                  |
|`maxHeight` |number  |Maximum height of the bounding box to fit the text into. Use a negative number (the default) for no limit                                                 |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for very tight textboxes and some East Asian languages|
|`[maxScale]`|number  |Maximum scale that can be used which allows the algorithm to make text bigger. Defaults to `1`, no upscaling permitted                                    |

Fits text to a box by inserting line breaks and scaling text but **will not** insert any page breaks. Text will take up as much space as possible without starting a new page. The macro `SCRIBBLE_FIT_TO_BOX_ITERATIONS` controls how many iterations to perform (higher is slower but more accurate).

!> N.B. This function is slow and should be used sparingly. Try not to change the `maxWidth` and `maxHeight` once text has been drawn.

&nbsp;

## `.layout_scroll(maxWidth, maxHeight, [characterWrap])` *regenerator*

**Returns**: The text element

|Name             |Datatype|Purpose                                                                                                                                         |
|-----------------|--------|------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`       |number  |Maximum width for the whole textbox. Use a negative number (the default) for no limit                                                           |
|`maxHeight`      |number  |Maximum height for the whole textbox. Use a negative number (the default) for no limit                                                          |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for tight textboxes and some East Asian languages|

Instructs Scribble to fit text inside a box by automatically inserting line breaks where necessary. Scribble's text wrapping operates in a very similar way to GameMaker's native [`draw_text_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/draw_text_ext.htm). If text exceeds the horizontal maximum width then text will be pushed onto the next line. Very long sequences of glyphs without spaces will be split across multiple lines.

Unlike other layout methods, `.layout_scroll()` will not create a new page if the `[/page]` command tag is used. Instead, Scribble will append new pages underneath previous pages. Any text that overflows the maximum height of the textbox will be visually clipped. You can then scroll between pages using the relevant functions.

&nbsp;

## `.layout_scroll_split_pages(maxWidth, maxHeight, [characterWrap])` *regenerator*

**Returns**: The text element

|Name             |Datatype|Purpose                                                                                                                                         |
|-----------------|--------|------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`       |number  |Maximum width for the whole textbox. Use a negative number (the default) for no limit                                                           |
|`maxHeight`      |number  |Maximum height for the whole textbox. Use a negative number (the default) for no limit                                                          |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for tight textboxes and some East Asian languages|

Instructs Scribble to fit text inside a box by automatically inserting line breaks and page breaks where necessary. Scribble's text wrapping operates in a very similar way to GameMaker's native [`draw_text_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/draw_text_ext.htm). If text exceeds the horizontal maximum width then text will be pushed onto the next line. Very long sequences of glyphs without spaces will be split across multiple lines.

Unlike other layout methods, `.layout_scroll_split_pages()` will not create a new page if the `[/page]` command tag is used. Instead, Scribble will append new pages underneath previous pages. Any text that overflows the maximum height of the textbox will be visually clipped and marked as a new page as though you'd added a `[/page]` tag manually yourself. You can then scroll between pages using the relevant functions.

&nbsp;

&nbsp;

&nbsp;

# MSDF

?> MSDF fonts require special considerations. Please read [the MSDF article](msdf-fonts) for more information.

## `.msdf_shadow(colour, alpha, xoffset, yoffset, [softness])`

**Returns**: The text element

|Name      |Datatype|Purpose                                                                                                  |
|----------|--------|---------------------------------------------------------------------------------------------------------|
|`colour`  |integer |The colour of the shadow, as a standard GameMaker 24-bit BGR format                                      |
|`alpha`   |number  |Opacity of the shadow, `0.0` being transparent and `1.0` being fully opaque                              |
|`xoffset` |number  |x-coordinate of the shadow, relative to the parent glyph                                                 |
|`yoffset` |number  |y-coordinate of the shadow, relative to the parent glyph                                                 |
|`softness`|number  |Optional. Larger values give a softer edge to the shadow. If not specified, this will default to `0.1` (which draws an antialiased but clean shadow edge)|

Sets the colour, alpha, and offset for a procedural MSDF shadow. Setting the alpha to `0` will prevent the shadow from being drawn at all. If you find that your shadow(s) are being clipped or cut off when using large offset values, [regenerate your MSDF fonts](msdf-fonts) using a larger `pxrange`.

?> This method will only affect [MSDF fonts](msdf-fonts). If you'd like to add shadows to standard fonts or spritefonts, you may want to consider [baking this effect](fonts?id=scribble_font_bake_shadowsourcefontname-newfontname-dx-dy-shadowcolor-shadowalpha-separation-smooth).

&nbsp;

## `.msdf_border(colour, thickness)`

**Returns**: The text element

|Name       |Datatype|Purpose                                                                |
|-----------|--------|-----------------------------------------------------------------------|
|`colour`   |integer |Colour of the glyph's border, as a standard GameMaker 24-bit BGR format|
|`thickness`|real    |Thickness of the border, in pixels                                     |

Sets the colour and thickness for a procedural MSDF border. Setting the thickness to `0` will prevent the border from being drawn at all. If you find that your glyphs have filled (or partially filled) backgrounds, [regenerate your MSDF fonts](msdf-fonts) using a larger `pxrange`.

?> This method will only affect [MSDF fonts](msdf-fonts). If you'd like to add outlines to standard fonts or spritefonts, you may want to consider [baking this effect](fonts?id=scribble_font_bake_outline_4dirsourcefontname-newfontname-color-smooth).

&nbsp;

## `.msdf_feather(thickness)`

**Returns**: The text element

|Name       |Datatype|Purpose                             |
|-----------|--------|------------------------------------|
|`thickness`|real    |Feather thickness, in pixels        |

Changes the softness/hardness of the MSDF font outline. You may find you have to fiddle with this number to correct for screen scaling but, normally, this feature will not be needed. The feather thickness defaults to `1.0`.

?> This method will only affect [MSDF fonts](msdf-fonts).

&nbsp;

&nbsp;

&nbsp;

# Miscellaneous

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
# `scribble()` Methods

&nbsp;

`scribble()` is the heart of Scribble and is responsible for managing the underlying systems.

When you call `scribble()`, the function searches Scribble's internal cache and will return the text element that matches the string you gave the function (and also matches the unique ID too, if you specified one). If the cache doesn't contain a matching string then a new text element is created and returned instead.

**Even small changes in a string may cause a new text element to be generated automatically.** Scribble is pretty fast, but you don't want to use it for text that changes rapidly (e.g. health points, money, or score) as this will cause Scribble to do a lot of work, potentially slowing down your game.

Each text element can be altered by calling methods, a new feature in [GMS2.3.0](https://www.yoyogames.com/blog/549/gamemaker-studio-2-3-new-gml-features). Most methods return the text element itself. This allows you to chain methods together, achieving a [fluent interface](https://en.wikipedia.org/wiki/Fluent_interface). Some methods are marked as "regenerator methods". Setting new, different values for a piece of text using a regenerator method will cause Scribble to regenerate the underlying vertex buffers. For the sake of performance, avoid frequently changing values for regenerator methods as this will cause performance problems.

Don't worry about clearing up after yourself when you draw text - Scribble automatically manages memory for you. If you *do* want to manually control how memory is used, please use the [`.flush()`](scribble-methods?id=flush) method and [`scribble_flush_everything()`](misc-functions?id=scribble_flush_everything). Please be aware that it is not possible to serialise/deserialise Scribble text elements for e.g. a save system.

&nbsp;

## `scribble([string], [uniqueID])`

**Returns:** A text element that contains the string (a struct, an instance of `__scribble_class_element`)

|Name        |Datatype      |Purpose               |
|------------|--------------|----------------------|
|`[string]`  |string        |String to draw        |
|`[uniqueID]`|string or real|ID to reference a specific unique occurrence of a text element. Defaults to [`SCRIBBLE_DEFAULT_UNIQUE_ID`](configuration)|

If no string is specified (i.e. the function used with arguments), this function will return a **unique** text element that contains no text data (even if no unique ID is given). The text in any text element, including empty ones, can be overwritten using the [`.overwrite()`](scribble-methods?id=overwritestring-regenerator) method.

Scribble allows for many kinds of inline formatting tags. Please read the [Text Formatting](text-formatting) article for more information.

?> Scribble text elements have **no publicly accessible variables**. Do not directly read or write variables, use the setter and getter methods provided instead.

Text element methods are broken down into several categories. There's a lot here; feel free to swing by the [Discord server](https://discord.gg/8krYCqr) if you'd like some pointers on what to use and when. As noted above, **be careful when adjusting regenerator methods** as it's easy to cause to performance problems.

&nbsp;

# Basics

## `.draw(x, y)`

**Returns**: N/A (`undefined`)

|Name|Datatype|Purpose                          |
|----|--------|---------------------------------|
|`x` |real    |x position in the room to draw at|
|`y` |real    |y position in the room to draw at|

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
|`halign`|[halign constant](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/text/draw_set_halign.html)|Starting horizontal alignment of **each line** of text. Accepts `fa_left`, `fa_right`, and `fa_center`|
|`valign`|[valign constant](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/text/draw_set_valign.html)|Starting vertical alignment of the **entire textbox**. Accepts `fa_top`, `fa_bottom`, and `fa_middle` |

Sets the starting horizontal and vertical alignment for your text. You can change alignment using in-line [command tags](Text-Formatting) as well, though do note there are some limitations when doing so.

&nbsp;

# Colour

## `.blend(colour, alpha)`

**Returns**: The text element

|Name    |Datatype|Purpose                                                                         |
|--------|--------|--------------------------------------------------------------------------------|
|`colour`|integer |Blend colour used when drawing text, applied multiplicatively                   |
|`alpha` |real    |Alpha used when drawing text, 0 being fully transparent and 1 being fully opaque|

Sets the blend colour/alpha, which is applied at the end of the drawing pipeline. This is a little different to the interaction between [`draw_set_color()`](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/colour/draw_set_colour.html) and [`draw_text()` functions](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/text/). Scribble's blend colour is instead similar to [`draw_sprite_ext()`](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/sprites_and_tiles/draw_sprite_ext.html)'s behaviour: The blend colour/alpha is applied multiplicatively with the source colour, in this case the source colour is whatever colour has been set using formatting tags in the input text string.

&nbsp;

## `.fog(colour, alpha)`

**Returns**: The text element

|Name    |Datatype|Purpose                                                |
|--------|--------|-------------------------------------------------------|
|`colour`|integer |Fog colour, in the standard GameMaker 24-bit BGR format|
|`alpha` |real    |Blending factor for the fog, from 0 to 1               |

Forces the colour of all text (and sprites) to change to the given specified colour.

&nbsp;

## `.gradient(colour, blendFactor)`

**Returns**: The text element

|Name         |Datatype|Purpose                                                                                                                                          |
|-------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------|
|`colour`     |integer |Colour of the **bottom** of the gradient for each glyph                                                                                          |
|`blendFactor`|real    |Blending factor for the gradient, from `0` (no gradient applied) to `1` (base blend colour of the bottom of each glyph is replaced with `colour`)|

Sets up a gradient blend for each glyph in the text element. The base blend colour (defined by a combination of `.blend()` and in-line colour modification) is the top of the gradient and the colour defined by this method is the bottom of the gradient.

&nbsp;

&nbsp;

&nbsp;

# Shape, Wrapping, and Positioning

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

&nbsp;

## `.scale_to_box(maxWidth, maxHeight)`

**Returns**: The text element

|Name       |Datatype|Purpose                                                                                                  |
|-----------|--------|---------------------------------------------------------------------------------------------------------|
|`maxWidth` |real    |Maximum width of the bounding box to fit the text into. Use a negative number (the default) for no limit |
|`maxHeight`|real    |Maximum height of the bounding box to fit the text into. Use a negative number (the default) for no limit|

Scales the text element such that it always fits inside the maximum width and height specified. Scaling is equal in both the x and y axes. This behaviour does not recalculate text wrapping so will not re-flow text. `.scale_to_box()` is a simple scaling operation therefore, and one that is best used for single lines of text (e.g. for buttons).

&nbsp;

## `.wrap(maxWidth, [maxHeight], [characterWrap])` *regenerator*

**Returns**: The text element

|Name             |Datatype|Purpose                                                                                                                                         |
|-----------------|--------|------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`       |integer |Maximum width for the whole textbox. Use a negative number (the default) for no limit                                                           |
|`[maxHeight]`    |integer |Maximum height for the whole textbox. Use a negative number (the default) for no limit                                                          |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for tight textboxes and some East Asian languages|

Instructs Scribble to fit text inside a box by automatically inserting line breaks and page breaks where necessary. Scribble's text wrapping operates in a very similar way to GameMaker's native [`draw_text_ext()`](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/text/draw_text_ext.html). If text exceeds the horizontal maximum width then text will be pushed onto the next line. If text exceeds the maximum height of the textbox then a new page will be created (see [`.page()`](scribble-methods?id=pagepage) and [`.get_page()`](scribble-methods?id=get_page)). Very long sequences of glyphs without spaces will be split across multiple lines.

&nbsp;

## `.fit_to_box(maxWidth, maxHeight, [characterWrap])` *regenerator*

**Returns**: The text element

|Name             |Datatype|Purpose                                                                                                                                              |
|-----------------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`       |integer |Maximum width for the whole textbox                                                                                                                  |
|`maxHeight`      |integer |Maximum height for the whole textbox                                                                                                                 |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for very tight textboxes and some East Asian languages|

Fits text to a box by inserting line breaks and scaling text but **will not** insert any page breaks. Text will take up as much space as possible without starting a new page. The macro `SCRIBBLE_FIT_TO_BOX_ITERATIONS` controls how many iterations to perform (higher is slower but more accurate).

!> N.B. This function is very slow and should be used sparingly. It is recommended you manually cache text elements when using `.fit_to_box()`.

&nbsp;

## `.line_height(min, max)` *regenerator*

**Returns**: The text element

|Name |Datatype|Purpose                                                                                                                               |
|-----|--------|--------------------------------------------------------------------------------------------------------------------------------------|
|`min`|integer |Minimum line height for each line of text. Use a negative number (the default) for the height of a space character of the default font|
|`max`|integer |Maximum line height for each line of text. Use a negative number (the default) for no limit                                           |

Sets limits on the height of each line for the text element. This is useful when mixing and matching fonts that aren't necessarily perfectly sized to each other.

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

# Getters

## `.get_bbox([x], [y], [leftPad], [topPad], [rightPad], [bottomPad])`

**Returns:** Struct containing the positions of the bounding box for a text element

|Name         |Datatype|Purpose                                                                                            |
|-------------|--------|---------------------------------------------------------------------------------------------------|
|`[x]`        |real    |x position in the room. Defaults to 0                                                              |
|`[y]`        |real    |y position in the room. Defaults to 0                                                              |
|`[leftPad]`  |real    |Extra space on the left-hand side of the textbox. Positive values create more space. Defaults to 0 |
|`[topPad]`   |real    |Extra space on the top of the textbox. Positive values create more space. Defaults to 0            |
|`[rightPad]` |real    |Extra space on the right-hand side of the textbox. Positive values create more space. Defaults to 0|
|`[bottomPad]`|real    |Extra space on the bottom of the textbox. Positive values create more space. Defaults to 0         |

The struct returned by `.get_bbox()` contains the following member variables:

|Variable        |Purpose                                |
|----------------|---------------------------------------|
|**Axis-aligned**|                                       |
|`left`          |Axis-aligned lefthand boundary         |
|`top`           |Axis-aligned top boundary              |
|`right`         |Axis-aligned righthand boundary        |
|`bottom`        |Axis-aligned bottom boundary           |
|`width`         |Axis-aligned width of the bounding box |
|`height`        |Axis-aligned height of the bounding box|
|**Oriented**    |                                       |
|`x0`            |x position of the top-left corner      |
|`y0`            |y position of the top-left corner      |
|`x1`            |x position of the top-right corner     |
|`y1`            |y position of the top-right corner     |
|`x2`            |x position of the bottom-left corner   |
|`y2`            |y position of the bottom-left corner   |
|`x3`            |x position of the bottom-right corner  |
|`y3`            |y position of the bottom-right corner  |

&nbsp;

## `.get_width()`

**Returns:** Real, width of the text element in pixels (ignoring rotation and scaling)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Returns the raw width of the text element. This will **not** take into account rotation or scaling - this function returns the width value that Scribble uses internally.

&nbsp;

## `.get_height()`

**Returns:** Real, height of the text element in pixels (ignoring rotation and scaling)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Returns the raw height of the text element. This will **not** take into account rotation or scaling - this function returns the height value that Scribble uses internally.

&nbsp;

## `.get_wrapped()`

**Returns:** Boolean, whether the text has wrapped onto a new line using the [`.wrap()` feature](scribble-methods?id=wrapmaxwidth-maxheight-characterwrap-regenerator)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Will return `true` only if the [`.wrap()` feature](scribble-methods?id=wrapmaxwidth-maxheight-characterwrap-regenerator) is used. Manual newlines (`\n`) included in the input string will **not** cause this function to return `true`.

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

Please note that changing the page will reset any typewriter animations i.e. those started by [`.typewriter_in()`](scribble-methods?id=typewriter_inspeed-smoothness) and [`typewriter_out()`](scribble-methods?id=typewriter_outspeed-smoothness-backwards).

&nbsp;

## `.get_page()`

**Returns:** Integer, page that the text element is currently on, starting at `0` for the first page

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Returns which page Scribble is showing, as set by [`.page()`](scribble-methods?id=pagepage). Pages are 0-indexed; this function will return `0` for the first page.

&nbsp;

## `.get_pages()`

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

!> The old animation methods have been moved to global scope. Please see the [Animation Properties](animation-properties) page for details.

&nbsp;

&nbsp;

&nbsp;

# MSDF

?> MSDF fonts require special considerations. Please read [the MSDF article](msdf-fonts) for more information.

## `.msdf_shadow(colour, alpha, xoffset, yoffset)`

**Returns**: The text element

|Name     |Datatype|Purpose                                                                    |
|---------|--------|---------------------------------------------------------------------------|
|`colour` |integer |The colour of the shadow, as a standard GameMaker 24-bit BGR format        |
|`alpha`  |real    |Opacity of the shadow, `0.0` being transparent and `1.0` being fully opaque|
|`xoffset`|real    |x-coordinate of the shadow, relative to the parent glyph                   |
|`yoffset`|real    |y-coordinate of the shadow, relative to the parent glyph                   |

Sets the colour, alpha, and offset for a procedural MSDF shadow. Setting the alpha to `0` will prevent the shadow from being drawn at all. If you find that your shadow(s) are being clipped or cut off when using large offset values, [regenerate your MSDF fonts](msdf-fonts) using a larger `pxrange`.

&nbsp;

## `.msdf_border(colour, thickness)`

**Returns**: The text element

|Name       |Datatype|Purpose                                                                |
|-----------|--------|-----------------------------------------------------------------------|
|`colour`   |integer |Colour of the glyph's border, as a standard GameMaker 24-bit BGR format|
|`thickness`|real    |Thickness of the border, in pixels                                     |

Sets the colour and thickness for a procedural MSDF border. Setting the thickness to `0` will prevent the border from being drawn at all. If you find that your glyphs have filled (or partially filled) backgrounds, [regenerate your MSDF fonts](msdf-fonts) using a larger `pxrange`.

&nbsp;

## `.msdf_feather(thickness)`

**Returns**: The text element

|Name       |Datatype|Purpose                             |
|-----------|--------|------------------------------------|
|`thickness`|real    |Feather thickness, in pixels        |

Changes the softness/hardness of the MSDF font outline. You may find you have to fiddle with this number to correct for screen scaling but, normally, this feature will not be needed. The feather thickness defaults to `1.0`.

&nbsp;

&nbsp;

&nbsp;

# Cache Management

## `.build(freeze)`

**Returns**: N/A (`undefined`)

|Name    |Datatype|Purpose                                   |
|--------|--------|------------------------------------------|
|`freeze`|boolean |Whether to freeze generated vertex buffers|

Forces Scribble to build the text model for this text element. You should call this function if you're pre-caching text elements e.g. during a loading screen. Freezing vertex buffers will speed up rendering considerably but has a large up-front cost (Scribble generally defaults to **not** freezing vertex buffers to prevent hiccups when rendering text).

As this function returns `undefined`, the intended use of this function is:

```
///Create
element = scribble("Example test").wrap(200); //Create a new text element, and wrap it to maximum 200px wide
element.build(true); //Now build the text element

///Draw
element.draw(x, y);
```

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

# Miscellaneous

## `.events_get(position, [page])`

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

|Name                   |Datatype                       |Purpose                                                                             |
|-----------------------|-------------------------------|------------------------------------------------------------------------------------|
|`function`             |function, or array of functions|Function to execute to set Scribble behaviour for this text element                 |
|`[executeOnlyOnChange]`|boolean                        |Whether to only execute the template function if it has changed. Defaults to `false`|

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

## `.overwrite(string)` *regenerator*

**Returns**: The text element

|Name    |Datatype|Purpose                                     |
|--------|--------|--------------------------------------------|
|`string`|string  |New string to display using the text element|

Replaces the string in an existing text element whilst maintaining the animation, typewriter, and page state. This function may cause a recaching of the underlying text model so should be used sparingly.

&nbsp;

## `.ignore_command_tags(state)` *regenerator*

**Returns**: The text element

|Name   |Datatype|Purpose|
|-------|--------|-------|
|`state`|boolean |       |

Directs Scribble to ignore all [command tags](text-formatting) in the string.

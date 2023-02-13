# Quick Functions

?> The functions on this page are intended as quick and easy functions to get you started with Scribble as fast as possible. Scribble is capable of much more, unlocked by using [`scribble()` methods](scribble-methods) and Scribble's many other functions.

&nbsp;

## `draw_text_scribble(x, y, string)`

**Returns**: N/A (`undefined`)

|Name    |Datatype|Purpose                           |
|--------|--------|----------------------------------|
|`x`     |number  |x-coordinate to draw the string at|
|`y`     |number  |y-coordinate to draw the string at|
|`string`|string  |String to draw                    |

Draws a string to the screen, much like GameMaker's native `draw_text_ext()`, but instead using Scribble's own text renderer. This allows you to use Scribble [in-line text formatting commands]() with using the [`scribble()` function](scribble-methods) itself. Font, text colour, and alignment are collected from GameMaker's native function (i.e. `draw_set_font()` will affect the font used for `draw_text_scribble()`).

!> Do not use a "`string_copy()` typewriter" with Scribble, an example being [this tutorial](https://www.yoyogames.com/en/blog/coffee-break-tutorial-easy-typewriter-dialogue-gml). Instead, use `draw_text_scribble_ext()`'s `charCount` argument to control how much text to draw.

&nbsp;

## `draw_text_scribble_ext(x, y, string, width, [charCount])`

**Returns**: N/A (`undefined`)

|Name         |Datatype|Purpose                                                                                       |
|-------------|--------|----------------------------------------------------------------------------------------------|
|`x`          |number  |x-coordinate to draw the string at                                                            |
|`y`          |number  |y-coordinate to draw the string at                                                            |
|`string`     |string  |String to draw                                                                                |
|`width`      |number  |Maximum width of the string. Any text that exceeds this width is wrapped down to the next line|
|`[charCount]`|integer |Optional, the number of characters to draw. If not specified, the entire string is drawn      |

Draws a string to the screen, much like GameMaker's native `draw_text_ext()`, but instead using Scribble's own text renderer. This allows you to use Scribble [in-line text formatting commands]() with using the [`scribble()` function](scribble-methods) itself. Font, text colour, and alignment are collected from GameMaker's native function (i.e. `draw_set_font()` will affect the font used for `draw_text_scribble()`). `draw_text_scribble_ext()` additionally allows you to specify a maximum width for your text for the purposes of automatic line wrapping.

!> Do not use a "`string_copy()` typewriter" with Scribble, an example being [this tutorial](https://www.yoyogames.com/en/blog/coffee-break-tutorial-easy-typewriter-dialogue-gml). Instead, use the `charCount` argument to control how much text to draw.

&nbsp;

## `string_width_scribble(string)`

**Returns**: Number, width of the string

|Name    |Datatype|Purpose         |
|--------|--------|----------------|
|`string`|string  |String to target|

&nbsp;

## `string_height_scribble(string)`

**Returns**: Number, width of the string

|Name    |Datatype|Purpose         |
|--------|--------|----------------|
|`string`|string  |String to target|

&nbsp;

## `string_width_scribble_ext(string)`

**Returns**: Number, width of the string


|Name    |Datatype|Purpose                                                                                       |
|--------|--------|----------------------------------------------------------------------------------------------|
|`string`|string  |String to target                                                                              |
|`width` |number  |Maximum width of the string. Any text that exceeds this width is wrapped down to the next line|

&nbsp;

## `string_height_scribble_ext(string)`

**Returns**: Number, width of the string


|Name    |Datatype|Purpose                                                                                       |
|--------|--------|----------------------------------------------------------------------------------------------|
|`string`|string  |String to target                                                                              |
|`width` |number  |Maximum width of the string. Any text that exceeds this width is wrapped down to the next line|
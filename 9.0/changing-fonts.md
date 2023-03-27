# Changing Fonts

&nbsp;

## `scribble_font_set_default(fontName)`

**Returns:** N/A (`undefined`)

|Name       |Datatype|Purpose                                                                                                                                                                                            |
|-----------|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`fontName` |string  |Name of the font to set as the default, as a string                                                                                                                                                |

This function sets the default font to use for future [`scribble()`](scribble-methods) calls.

&nbsp;

## `.font(fontName)` *regenerator*

**Returns**: The text element

|Name      |Datatype|Purpose                                                                                                         |
|----------|--------|----------------------------------------------------------------------------------------------------------------|
|`fontName`|string  |Name of the starting font, as a string. This is the font that is set when `[/]` or `[/font]` is used in a string|

Sets the starting font and text colour for your text. The values that are set with `.starting_format()` are applied if you use the [`[/] or [/f] or [/c]` command tags](text-formatting) to reset your text format.

&nbsp;

## `[<name of font>]`

**Command tag.** Set the font for subsequent characters.

&nbsp;

## `[/font]` `[/f]`

**Command tag.** Reset font.
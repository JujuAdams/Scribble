`scribble_set_glyph_property(fontName, character, property, value, [relative])`

**Returns:** N/A (`0`)

|Argument|Name        |Purpose                      |
|--------|------------|-----------------------------|
|0       |`fontName`  |The target font, as a string|
|1       |`character` |Target character, as a string|
|2       |`property`  |Property to return, see below|
|3       |`value`     |The value to set|
|[4]     |`[relative]`|Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to `false`, overwriting the existing value|

Fonts can often be tricky to render correctly, and this script allows you to change certain properties. Properties can be adjusted at any time, but existing/cached Scribble text elements will not be updated to match new properties.

Three properties are available:

|Macro                      | Property                                   |
|---------------------------|--------------------------------------------|
|`SCRIBBLE_GLYPH.X_OFFSET`  |x coordinate offset to draw the glyph       |
|`SCRIBBLE_GLYPH.Y_OFFSET`  |y coordinate offset to draw the glyph       |
|`SCRIBBLE_GLYPH.SEPARATION`|Distance between this glyph's right edge and the left edge of the next glyph. This can be a negative value!|
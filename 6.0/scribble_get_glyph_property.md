`scribble_get_glyph_property(fontName, character, property)`

**Returns:** Real-value for the specified property

|Argument|Name       |Purpose                      |
|--------|-----------|-----------------------------|
|0       |`fontName` |The target font, as a string |
|1       |`character`|Target character, as a string|
|2       |`property` |Property to return, see below|

Three properties are available:

|Macro                      | Property                                   |
|---------------------------|--------------------------------------------|
|`SCRIBBLE_GLYPH.X_OFFSET`  |x coordinate offset to draw the glyph       |
|`SCRIBBLE_GLYPH.Y_OFFSET`  |y coordinate offset to draw the glyph       |
|`SCRIBBLE_GLYPH.SEPARATION`|Distance between this glyph's right edge and the left edge of the next glyph. This can be a negative value!|
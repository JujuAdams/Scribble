# Glyph Properties

&nbsp;

## `scribble_glyph_set()`

**Global Function:** `scribble_glyph_set(fontName, character, property, value, [relative])`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                      |
|------------|--------|-----------------------------|
|`fontName`  |string  |The target font, as a string |
|`character` |string  |Target character, as a string|
|`property`  |integer |Property to return, see below|
|`value`     |integer |The value to set (or add)    |
|`[relative]`|boolean |Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to `false`, overwriting the existing value|

Fonts can often be tricky to render correctly, and this script allows you to change certain properties. Properties can be adjusted at any time, but existing and cached Scribble text elements will not be updated to match new properties.

The following properties are available for modification:

|Macro                      | Property                                   |
|---------------------------|--------------------------------------------|
|`SCRIBBLE_GLYPH.WIDTH`     |Width of the glyph, in pixels. Changing this value will visually stretch the glyph|
|`SCRIBBLE_GLYPH.HEIGHT`    |Height of the glyph, in pixels. Changing this value will visually stretch the glyph|
|`SCRIBBLE_GLYPH.X_OFFSET`  |x-coordinate offset to draw the glyph       |
|`SCRIBBLE_GLYPH.Y_OFFSET`  |y-coordinate offset to draw the glyph       |
|`SCRIBBLE_GLYPH.SEPARATION`|Distance between this glyph's right edge and the left edge of the next glyph<br>**N.B.** This can be a negative value|

&nbsp;

## `scribble_glyph_get()`

**Global Function:** `scribble_glyph_get(fontName, character, property)`

**Returns:** Real-value for the specified property

|Name       |Datatype|Purpose                      |
|-----------|--------|-----------------------------|
|`fontName` |string  |The target font, as a string |
|`character`|string  |Target character, as a string|
|`property` |integer |Property to return, see below|

Three properties are available:

|Macro                      | Property                                   |
|---------------------------|--------------------------------------------|
|`SCRIBBLE_GLYPH.WIDTH`     |Width of the glyph, in pixels               |
|`SCRIBBLE_GLYPH.HEIGHT`    |Height of the glyph, in pixels              |
|`SCRIBBLE_GLYPH.X_OFFSET`  |x-coordinate offset to draw the glyph       |
|`SCRIBBLE_GLYPH.Y_OFFSET`  |y-coordinate offset to draw the glyph       |
|`SCRIBBLE_GLYPH.SEPARATION`|Distance between this glyph's right edge and the left edge of the next glyph<br>**N.B.** This can be a negative value|
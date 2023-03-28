# Miscellaneous

&nbsp;

## `scribble_font_has_character(fontName, character)`

**Returns:** Boolean, indicating whether the given character is found in the font

|Name       |Datatype|Purpose                           |
|-----------|--------|----------------------------------|
|`fontName` |string  |Name of the font to target        |
|`character`|string  |Character to test for, as a string|

&nbsp;

## `scribble_font_get_glyph_ranges(fontName, [hex])`

**Returns:** Array of arrays, the ranges of glyphs available to the given font

|Name      |Datatype|Purpose                                                                                |
|----------|--------|---------------------------------------------------------------------------------------|
|`fontName`|string  |Name of the font to target                                                             |
|`[hex]`   |boolean |Whether to return ranges as hex codes. If not specified, decimal codes will be returned|

Returns an array of arrays, the nested arrays being comprised of two elements. The 0th element of a nested array is the minimum value for the range, the 1st element of a nested array is the maximum value for the range. Ranges that only contain one glyph will have their minimum and maximum values set to the same number.

&nbsp;

## `scribble_font_force_bilinear_filtering(fontName, state)`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                                              |
|----------|--------|-----------------------------------------------------|
|`fontName`|string  |Name of the font to modify, as a string              |
|`state`   |boolean |Whether the font should use bilinear filtering or not|

By default, standard fonts and spritefonts will use whatever texture filtering GPU state has been set. MSDF fonts default to forcing bilinear filtering when they are drawn. `scribble_font_force_bilinear_filtering()` allows you to override this behaviour if you wish, forcing all glyphs for a given font to be drawn with the specified bilinear filtering state. Setting the `state` argument to `undefined` will cause glyphs for the font to inherit whatever GPU state has been set (the default behaviour for standard fonts and spritefonts).
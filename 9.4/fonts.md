# Fonts

&nbsp;

## `scribble_font_set_default(fontName)`

**Returns:** N/A (`undefined`)

|Name       |Datatype|Purpose                                                                                                                                                                                            |
|-----------|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`fontName` |string  |Name of the font to set as the default, as a string                                                                                                                                                |

This function sets the default font to use for future [`scribble()`](scribble-methods) calls.

&nbsp;

## `scribble_font_rename(oldName, newName)`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                   |
|------------|--------|--------------------------|
|`oldName`   |string  |Name of the font to rename|
|`newName`   |string  |New name for the font     |

&nbsp

## `scribble_font_duplicate(fontName, newName)`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                      |
|----------|--------|-----------------------------|
|`fontName`|string  |Name of the font to duplicate|
|`newName` |string  |Name for the new font        |

&nbsp;

## `scribble_font_delete(fontName)`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                   |
|----------|--------|--------------------------|
|`fontName`|string  |Name of the font to delete|

&nbsp;

## `scribble_font_exists(fontName)`

**Returns:** Boolean, whether a Scribble font with the given name exists

|Name      |Datatype|Purpose                      |
|----------|--------|-----------------------------|
|`fontName`|string  |Name of the font to check for|

&nbsp;

## `scribble_font_set_style_family(regular, bold, italic, boldItalic)`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                                      |
|------------|--------|---------------------------------------------|
|`regular`   |string  |Name of font to use for the regular style    |
|`bold`      |string  |Name of font to use for the bold style       |
|`italic`    |string  |Name of font to use for the italic style     |
|`boldItalic`|string  |Name of font to use for the bold-italic style|

Associates four fonts together for use with `[r]` `[b]` `[i]` `[bi]` font tags. Use `undefined` for any style you don't want to set a font for.

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

## `scribble_font_set_halign_offset(fontName, hAlign, offset)`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                                  |
|----------|--------|-----------------------------------------|
|`fontName`|string  |Name of the font to modify, as a string  |
|`hAlign`  |constant|Horizontal alignment to target, see below|
|`offset`  |number  |x-axis offset to apply                   |

This function sets up a fixed offset for a font when used with a particular alignment. Valid constants for the `hAlign` argument are:

- `fa_left`
- `fa_center`
- `fa_right`
- `fa_justify`
- `"pin_left"`
- `"pin_centre"`
- `"pin_center"`
- `"pin_right"`
- `"fa_justify"`

?> The macro `SCRIBBLE_USE_FONT_ALIGNMENT_OFFSETS` must be set to `true` to use this function. This will incur a slight performance penalty when building text elements.

?> Existing text elements that use the targetted font will not be immediately updated - you will need to refresh those text elements.

&nbsp;

## `scribble_font_set_valign_offset(fontName, vAlign, offset)`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                                |
|----------|--------|---------------------------------------|
|`fontName`|string  |Name of the font to modify, as a string|
|`vAlign`  |constant|Vertical alignment to target, see below|
|`offset`  |number  |x-axis offset to apply                 |

This function sets up a fixed offset for a font when used with a particular alignment. Valid constants for the `vAlign` argument are:

- `fa_top`
- `fa_middle`
- `fa_bottom`

?> The macro `SCRIBBLE_USE_FONT_ALIGNMENT_OFFSETS` must be set to `true` to use this function. This will incur a slight performance penalty when building text elements.

?> Existing text elements that use the targetted font will not be immediately updated - you will need to refresh those text elements.

&nbsp;

## `scribble_glyph_set(fontName, character, property, value, [relative])`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                                                                                                                                    |
|------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------|
|`fontName`  |string  |The target font, as a string                                                                                                               |
|`character` |string  |Target character, as a string. You may use the GameMaker constant `all` to adjust all characters in a font                                 |
|`property`  |integer |Property to return, see below                                                                                                              |
|`value`     |integer |The value to set (or add)                                                                                                                  |
|`[relative]`|boolean |Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to `false`, overwriting the existing value|

Fonts can often be tricky to render correctly, and this script allows you to change certain properties. Properties can be adjusted at any time, but existing and cached Scribble text elements will not be updated to match new properties.

The following properties are available for modification:

|Macro                       | Property                                                                                                                       |
|----------------------------|--------------------------------------------------------------------------------------------------------------------------------|
|`SCRIBBLE_GLYPH.WIDTH`      |Width of the glyph, in pixels. Changing this value will visually stretch the glyph                                              |
|`SCRIBBLE_GLYPH.HEIGHT`     |Height of the glyph, in pixels. Changing this value will visually stretch the glyph                                             |
|`SCRIBBLE_GLYPH.X_OFFSET`   |x-coordinate offset to draw the glyph                                                                                           |
|`SCRIBBLE_GLYPH.Y_OFFSET`   |y-coordinate offset to draw the glyph                                                                                           |
|`SCRIBBLE_GLYPH.SEPARATION` |Horizontal distance between this glyph's right edge and the left edge of the next glyph<br>**N.B.** This can be a negative value|
|`SCRIBBLE_GLYPH.FONT_HEIGHT`|Vertical distance between lines of text                                                                                         |

&nbsp;

## `scribble_glyph_get(fontName, character, property)`

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
|`SCRIBBLE_GLYPH.SEPARATION`|Distance between this glyph's right edge and the left edge of the next glyph<br>**N.B.** This can be a negative value

&nbsp;

## `scribble_kerning_pair_set(fontName, firstChar, secondChar, value, [relative])`

**Returns:** Number, the new kerning offset

|Name        |Datatype|Purpose                                                                                                                                    |
|------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------|
|`fontName`  |string  |The target font, as a string                                                                                                               |
|`firstChar` |string  |First character in the pair                                                                                                                |
|`secondChar`|string  |Second character in the pair                                                                                                               |
|`value`     |number  |The value to set (or add)                                                                                                                  |
|`[relative]`|boolean |Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to `false`, overwriting the existing value|

&nbsp;

## `scribble_kerning_pair_get(fontName, firstChar, secondChar)`

**Returns:** Number, the kerning offset for the given pair of characters

|Name        |Datatype|Purpose                     |
|------------|--------|----------------------------|
|`fontName`  |string  |The target font, as a string|
|`firstChar` |string  |First character in the pair |
|`secondChar`|string  |Second character in the pair|

If there is no kerning offset defined for the given pair of characters (either set automatically by the font or manually via `scribble_kerning_pair_set()`), a value of `0` is returned.

&nbsp;

## `scribble_font_bake_outline_and_shadow(sourceFontName, newFontName, shadowX, shadowY, outlineMode, separation, smooth, [textureSize=2048])`

**Returns:** N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                                       |
|----------------|--------|--------------------------------------------------------------------------------------------------------------|
|`sourceFontName`|string  |Name of the source font, as a string                                                                          |
|`newFontName`   |string  |Name of the new font to create, as a string                                                                   |
|`shadowX`       |number  |x-axis displacement for the shadow                                                                            |
|`shadowY`       |number  |y-axis displacement for the shadow                                                                            |
|`outlineMode`   |integer |Type of outline to create, a member of the `SCRIBBLE_OUTLINE` enum                                            |
|`separation`    |integer |Change in every glyph's `SCRIBBLE_GLYPH.SEPARATION` value                                                     |
|`smooth`        |boolean |Whether or not to interpolate the shadow. Set to `false` for pixel fonts, set to `true` for anti-aliased fonts|
|`[textureSize]` |integer |Size of the texture to use. Defaults to 2048x2048                                                             |

`scribble_font_bake_outline_and_shadow()` creates a new font using a source font. The new font will include a drop shadow with the given displacement and will include an outline based on one of the following modes:

|Mode              |                                                    |
|------------------|----------------------------------------------------|
|`.NO_OUTLINE`     |No outline is added                                 |
|`.FOUR_DIR`       |One-pixel thick outline in the 4 cardinal directions|
|`.EIGHT_DIR`      |One-pixel thick outline in the 8 compass directions |
|`.EIGHT_DIR_THICK`|Two-pixel thick outline in the 8 compass directions |

You can change the colour of the outline by using the `.outline()` text element method. You can change the colour and alpha of the shadow by using the `.shadow()` text element method.

&nbsp;

## `scribble_font_bake_shader(sourceFontName, newFontName, shader, leftPad, topPad, rightPad, bottomPad, separationDelta, smooth, [textureSize=2048])`

**Returns:** N/A (`undefined`)

|Name             |Datatype|Purpose                                                                            |
|-----------------|--------|-----------------------------------------------------------------------------------|
|`sourceFontName` |string  |Name, as a string, of the font to use as a basis for the effect                    |
|`newFontName`    |string  |Name of the new font to create, as a string                                        |
|`shader`         |[shader](https://manual.yoyogames.com/The_Asset_Editors/Shaders.htm)   |Shader to use                                                                      |
|`emptyBorderSize`|integer |Border around the outside of every output glyph, in pixels. A value of 2 is typical|
|`leftPad`        |integer |Left padding around the outside of every glyph. Positive values give more space. e.g. For a shader that adds a border of 2px around the entire glyph, **all** padding arguments should be set to `2`|
|`topPad`         |integer |Top padding                                                                        |
|`rightPad`       |integer |Right padding                                                                      |
|`bottomPad`      |integer |Bottom padding                                                                     |
|`separationDelta`|integer |Change in every glyph's [`SCRIBBLE_GLYPH.SEPARATION`](scribble_set_glyph_property) value. For a shader that adds a border of 2px around the entire glyph, this value should be 4px|
|`smooth`         |boolean |Whether or not to interpolate the output texture. Set to `false` for pixel fonts, set to `true` for anti-aliased fonts|
|`[textureSize]`  |integer |Size of the texture to use. Defaults to 2048x2048                                  |

`scribble_bake_shader()` creates a new font using a source font. The source font is rendered to a surface, then passed through the given shader using whatever uniforms that have been set for that shader.

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

By default, standard fonts and spritefonts will use whatever texture filtering GPU state has been set. SDF fonts default to forcing bilinear filtering when they are drawn. `scribble_font_force_bilinear_filtering()` allows you to override this behaviour if you wish, forcing all glyphs for a given font to be drawn with the specified bilinear filtering state. Setting the `state` argument to `undefined` will cause glyphs for the font to inherit whatever GPU state has been set (the default behaviour for standard fonts and spritefonts).

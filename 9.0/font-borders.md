# Font Borders

&nbsp;

## `scribble_font_bake_outline_4dir(sourceFontName, newFontName, color, smooth)`

**Returns:** N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                                        |
|----------------|--------|---------------------------------------------------------------------------------------------------------------|
|`sourceFontName`|string  |Name of the source font, as a string                                                                           |
|`newFontName`   |string  |Name of the new font to create, as a string                                                                    |
|`outlineColor`  |integer |Colour of the outline                                                                                          |
|`smooth`        |boolean |Whether or not to interpolate the outline. Set to `false` for pixel fonts, set to `true` for anti-aliased fonts|
|`[surfaceSize]` |integer |Size of the surface to use. Defaults to 2048x2048                                                              |

`scribble_bake_outline_4dir()` creates a new font using a source font. The new font will include a one-pixel thick border in the 4 cardinal directions around each input glyph.

&nbsp;

## `scribble_font_bake_outline_8dir(sourceFontName, newFontName, color, smooth)`

**Returns:** N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                                        |
|----------------|--------|---------------------------------------------------------------------------------------------------------------|
|`sourceFontName`|string  |Name of the source font, as a string                                                                           |
|`newFontName`   |string  |Name of the new font to create, as a string                                                                    |
|`outlineColor`  |integer |Colour of the outline                                                                                          |
|`smooth`        |boolean |Whether or not to interpolate the outline. Set to `false` for pixel fonts, set to `true` for anti-aliased fonts|
|`[surfaceSize]` |integer |Size of the surface to use. Defaults to 2048x2048                                                              |

`scribble_bake_outline_8dir()` creates a new font using a source font. The new font will include a 1-pixel thick border in the 8 compass directions around each input glyph. For a thicker variation on this shader, try `scribble_font_bake_outline_8dir_2px()`.

&nbsp;

## `scribble_font_bake_outline_8dir_2px(sourceFontName, newFontName, color, smooth)`

**Returns:** N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                                        |
|----------------|--------|---------------------------------------------------------------------------------------------------------------|
|`sourceFontName`|string  |Name of the source font, as a string                                                                           |
|`newFontName`   |string  |Name of the new font to create, as a string                                                                    |
|`outlineColor`  |integer |Colour of the outline                                                                                          |
|`smooth`        |boolean |Whether or not to interpolate the outline. Set to `false` for pixel fonts, set to `true` for anti-aliased fonts|
|`[surfaceSize]` |integer |Size of the surface to use. Defaults to 2048x2048                                                              |

`scribble_bake_outline_8dir()` creates a new font using a source font. The new font will include a 2-pixel thick border in the 8 compass directions around each input glyph. This is useful for more cartoony text, especially high resolution anti-aliased text.

&nbsp;

## `scribble_font_bake_shadow(sourceFontName, newFontName, dX, dY, shadowColor, shadowAlpha, separation, smooth)`

**Returns:** N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                                       |
|----------------|--------|--------------------------------------------------------------------------------------------------------------|
|`sourceFontName`|string  |Name of the source font, as a string                                                                          |
|`newFontName`   |string  |Name of the new font to create, as a string                                                                   |
|`dX`            |number  |x-axis displacement for the shadow                                                                            |
|`dY`            |number  |y-axis displacement for the shadow                                                                            |
|`shadowColor`   |integer |Colour of the shadow                                                                                          |
|`shadowAlpha`   |number  |Alpha of the shadow  from `0.0` to `1.0`                                                                      |
|`separation`    |integer |Change in every glyph's [`SCRIBBLE_GLYPH.SEPARATION`](scribble_set_glyph_property) value                      |
|`smooth`        |boolean |Whether or not to interpolate the shadow. Set to `false` for pixel fonts, set to `true` for anti-aliased fonts|

`scribble_font_bake_shadow()` creates a new font using a source font. The new font will include a drop shadow with the given displacement, and using the given colour and alpha.

&nbsp;

## `scribble_font_bake_shader(sourceFontName, newFontName, shader, leftPad, topPad, rightPad, bottomPad, separationDelta, smooth, [surfaceSize])`

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
|`[surfaceSize]`  |integer |Size of the surface to use. Defaults to 2048x2048                                  |

`scribble_bake_shader()` creates a new font using a source font. The source font is rendered to a surface, then passed through the given shader using whatever uniforms that have been set for that shader.
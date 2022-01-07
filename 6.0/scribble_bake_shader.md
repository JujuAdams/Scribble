`scribble_bake_shader(sourceFontName, newFontName, shader, leftPad, topPad, rightPad, bottomPad, separationDelta, smooth, [surfaceSize])`

**Returns:** N/A (`0`)

|Argument|Name             |Purpose                                                                            |
|--------|-----------------|-----------------------------------------------------------------------------------|
|0       |`sourceFontName` |Name, as a string, of the font to use as a basis for the effect                    |
|1       |`newFontName`    |Name of the new font to create, as a string                                        |
|2       |`shader`         |Shader to use                                                                      |
|3       |`emptyBorderSize`|Border around the outside of every output glyph, in pixels. A value of 2 is typical|
|4       |`leftPad`        |Left padding around the outside of every glyph. Positive values give more space. e.g. For a shader that adds a border of 2px around the entire glyph, **all** padding arguments should be set to `2`|
|5       |`topPad`         |Top padding                                                                        |
|6       |`rightPad`       |Right padding                                                                      |
|7       |`bottomPad`      |Bottom padding                                                                     |
|8       |`separationDelta`|Change in every glyph's [`SCRIBBLE_GLYPH.SEPARATION`](scribble_set_glyph_property) value. For a shader that adds a border of 2px around the entire glyph, this value should be 4px|
|9       |`smooth`         |Whether or not to interpolate the output texture. Set to `false` for pixel fonts, set to `true` for anti-aliased fonts|
|[10]    |`[surfaceSize]`  |Size of the surface to use. Defaults to 2048x2048                                  |

`scribble_bake_shader()` creates a new font using a source font. The source font is passed through the given shader, character by character, using the parameters provided.
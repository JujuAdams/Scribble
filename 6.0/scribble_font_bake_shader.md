`scribble_font_bake_shader(sourceFontName, newFontName, shader, emptyBorderSize, leftPad, topPad, rightPad, bottomPad, glyphSeparation, smooth, [textureSize])`

**Returns:** N/A (`0`)

|Argument|Name             |Purpose                                                                                                                    |
|--------|-----------------|---------------------------------------------------------------------------------------------------------------------------|
|0       |`sourceFontName` |String name of the spritefont to add                                                                                       |
|1       |`newFontName`    |String from which sprite sub-image order is taken                                                                          |
|2       |`shader`         |Shader to use to generate the effect                                                                                       |
|3       |`emptyBorderSize`|Empty space to leave between glyphs, and between glyphs and the edge of the texture. A value of at least `2` is recommended|
|4       |`leftPad`        |Additional lefthand pixels of useful glyph image data                                                                      |
|5       |`topPad`         |Additional upper pixels of useful glyph image data                                                                         |
|6       |`rightPad`       |Additional righthand pixels of useful glyph image data                                                                     |
|7       |`bottomPad`      |Additional lower pixels of useful glyph image data                                                                         |
|8       |`glyphSeparation`|Additional space to leave between glyphs, in pixels                                                                        |
|9       |`smooth`         |Boolean indicating if texture interpolation should be used                                                                 |
|[10]    |`[textureSize]`  |Size of the final texture page. Defaults to 2048x2048                                                                      |

Spritefont shaders usually look best with the `smooth` argument set to `false` to keep the crisp pixel-perfect feel. Normal fonts usually look best with `smooth` set to `true` to compliment GameMaker's native text anti-aliasing.
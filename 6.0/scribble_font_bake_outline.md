`scribble_font_bake_outline(sourceFontName, newFontName, size, samples, color, smooth)`

**Returns:** N/A (`0`)

|Argument|Name            |Purpose                                                                                                 |
|--------|----------------|--------------------------------------------------------------------------------------------------------|
|0       |`sourceFontName`|Name of the font to use as the source. This font must already have been added to Scribble               |
|1       |`newFontName`   |Name of the new new font to create                                                                      |
|2       |`size`          |Thickness of the outline. Accepts integer values greater than or equal to 1                             |
|3       |`samples`       |Number of radial samples e.g. a value of `4` will sample every 90°, a value of `8` will sample every 45°|
|4       |`color`         |Color of the outline using standard GameMaker 24-bit colors                                             |
|5       |`smooth`        |Boolean indicating if texture interpolation should be used                                              |

This function targets an existing Scribble font, adds an outline, and stores the result as an entirely new Scribble font.

Spritefont outlines usually look best with the `smooth` argument set to `false` and the `samples` argument set to `4` or `8` to keep the crisp pixel-perfect feel. Normal fonts usually look best with `smooth` set to `true` to compliment GameMaker's native text anti-aliasing.
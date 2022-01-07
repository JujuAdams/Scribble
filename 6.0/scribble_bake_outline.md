`scribble_bake_outline(sourceFontName, newFontName, thickness, samples, color, smooth)`

**Returns:** N/A (`0`)

|Argument|Name            |Purpose                                                                                                       |
|--------|----------------|--------------------------------------------------------------------------------------------------------------|
|0       |`sourceFontName`|Name of the source font, as a string                                                                          |
|1       |`newFontName`   |Name of the new font to create, as a string                                                                   |
|2       |`thickness`     |Number of layers to use to generate the border e.g. a value of `2` will give a 2px border                     |
|3       |`samples`       |Number of samples to use for the border per layer                                                             |
|4       |`color`         |Colour of the border                                                                                          |
|5       |`smooth`        |Whether or not to interpolate the border. Set to `false` for pixel fonts, set to `true` for anti-aliased fonts|

`scribble_bake_outline()` creates a new font using a source font. The source font is passed through the `shd_scribble_bake_outline`, character by character, using the parameters provided.
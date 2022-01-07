`scribble_font_combine(destinationFontName, sourceFontName, preferSource)`

**Returns:** N/A (`0`)

|Argument|Name                 |Purpose                                                                                                          |
|--------|---------------------|-----------------------------------------------------------------------------------------------------------------|
|0       |`destinationFontName`|Name of the font to add to, as a string                                                                          |
|1       |`sourceFontName`     |Name of the font to add from, as a string                                                                        |
|2       |`preferSource`       |Set to `true` to overwrite destination data if the source and destination fonts have data for the same glyph|

The destination font will be converted to a dictionary look-up. This may slightly impact performance when caching text.
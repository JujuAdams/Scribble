# Font Shadows

&nbsp;

## `scribble_font_bake_shadow()`

**Global Function:** `scribble_font_bake_shadow(sourceFontName, newFontName, dX, dY, smooth, separation, [surfaceSize=2048])`

**Returns:** N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                                       |
|----------------|--------|--------------------------------------------------------------------------------------------------------------|
|`sourceFontName`|string  |Name of the source font, as a string                                                                          |
|`newFontName`   |string  |Name of the new font to create, as a string                                                                   |
|`dX`            |number  |x-axis displacement for the shadow                                                                            |
|`dY`            |number  |y-axis displacement for the shadow                                                                            |
|`smooth`        |boolean |Whether or not to interpolate the shadow. Set to `false` for pixel fonts, set to `true` for anti-aliased fonts|
|`separation`    |integer |Change in every glyph's [`SCRIBBLE_GLYPH.SEPARATION`](scribble_set_glyph_property) value                      |
|`[surfaceSize]` |integer |Size of the surface to use. Defaults to 2048x2048                                                              |

`scribble_font_bake_shadow()` creates a new font using a source font. The new font will include a drop shadow with the given displacement, and using the given colour and alpha.

&nbsp;

## `.shadow()`

**Text Element Method:** `.shadow(colour, alpha)`

**Returns**: The text element

|Name    |Datatype         |Purpose                                                                                                                                                                                                                                   |
|--------|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`colour`|integer or string|Basic text colour as either:<br>- standard GameMaker 24-bit BGR format<br>- name of a GameMaker colour constant<br>- name of a colour added to `__scribble_config_colours()`<br>- name of a colour added by calling `scribble_color_set()`|
|`alpha` |number           |Opacity of the shadow, `0.0` being transparent and `1.0` being fully opaque                                                                                                                                                               |

Sets the colour, alpha, and offset for a procedural SDF shadow. Setting the alpha to `0` will prevent the shadow from being drawn at all.

?> This method will only affect SDF fonts. If you'd like to add shadows to other types of fonts, you may want to consider using a outline baking function.
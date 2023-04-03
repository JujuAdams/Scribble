# SDF Fonts

&nbsp;

Signed-Distance Field fonts, a.k.a. "SDF fonts", are a type of font that looks much nicer when scaled up and down. Normal fonts will typically look either blurry or unpleasantly pixellated when scaled. SDF fonts allow for text to be rendered at any size without needing to generate a unique font for each size. This effectively means SDF fonts are resolution-independent, making them useful for software UIs in general, but essential for mobile game development. SDFs reduce the texture memory usage of your game whilst also being easier to use and maintain. With Scribble, SDF fonts are rendered at the same speed as normal fonts. SDF fonts are supported for all of Scribble's target platforms.

?> At the time of writing, GameMaker only supports SDF fonts via `font_add()`. Scribble therefore only supports SDF fonts via the [`scribble_font_add()` feature](font_add).

Scribble expands upon GameMaker's barebones SDF rendering by adding procedural borders and drop shadows.

&nbsp;

## `.sdf_shadow()`

**Text Element Method:** `.sdf_shadow(colour, alpha, xoffset, yoffset, [softness=0.1])`

**Returns**: The text element

|Name      |Datatype|Purpose                                                                                                  |
|----------|--------|---------------------------------------------------------------------------------------------------------|
|`colour`  |integer |The colour of the shadow, as a standard GameMaker 24-bit BGR format                                      |
|`alpha`   |number  |Opacity of the shadow, `0.0` being transparent and `1.0` being fully opaque                              |
|`xoffset` |number  |x-coordinate of the shadow, relative to the parent glyph                                                 |
|`yoffset` |number  |y-coordinate of the shadow, relative to the parent glyph                                                 |
|`softness`|number  |Optional. Larger values give a softer edge to the shadow. If not specified, this will default to `0.1` (which draws an antialiased but clean shadow edge)|

Sets the colour, alpha, and offset for a procedural SDF shadow. Setting the alpha to `0` will prevent the shadow from being drawn at all.

?> This method will only affect SDF fonts. If you'd like to add shadows to other types of fonts, you may want to consider using a border baking function.

&nbsp;

## `.sdf_border()`

**Text Element Method:** `.sdf_border(colour, thickness)`

**Returns**: The text element

|Name       |Datatype         |Purpose                                                                                                                                                                                                                                   |
|-----------|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`colour`   |integer or string|Basic text colour as either:<br>- standard GameMaker 24-bit BGR format<br>- name of a GameMaker colour constant<br>- name of a colour added to `__scribble_config_colours()`<br>- name of a colour added by calling `scribble_color_set()`|
|`thickness`|number           |Thickness of the border, in pixels                                                                                                                                                                                                        |

This function adds a coloured border around your text. Setting the thickness to `0` will prevent the border from being drawn at all. The coloured border will not be colourised or tinted due to the use of other functionality.

?> This method will only affect SDF fonts. If you'd like to add outlines to standard fonts or spritefonts, you may want to consider using a shadow baking function.

&nbsp;

## `.sdf_feather()`

**Text Element Method:** `.sdf_feather(thickness)`

**Returns**: The text element

|Name       |Datatype|Purpose                             |
|-----------|--------|------------------------------------|
|`thickness`|number  |Feather thickness, in pixels        |

Changes the softness/hardness of the SDF font outline. You may find you have to fiddle with this number to correct for screen scaling but, normally, this feature will not be needed. The feather thickness defaults to `1.0`.

?> This method will only affect SDF fonts.

&nbsp;

## `scribble_sdf_thickness_offset()`

**Global Function:** `scribble_sdf_thickness_offset(offset)`

**Returns:** N/A (`undefined`)

|Name    |Datatype|Purpose                                                                         |
|--------|--------|--------------------------------------------------------------------------------|
|`offset`|number  |The global MSDF font thickness offset to apply. The default offset values is `0`|

Applies a global thickness adjustment to SDF fonts. An offset less than `0` will make SDF glyphs thinner, an offset greater than `0` will make SDF glyphs thicker. The offset value is very sensitive and values of `+/- 0.01` may make a significant difference to the appearance of glyphs.
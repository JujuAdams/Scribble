# SDF Fonts

&nbsp;

Scribble supports SDF fonts via `scribble_font_add()`, a wrapper for GameMaker's native `font_add()` function. Scribble expands upon GameMaker's barebones SDF rendering by adding procedural borders and drop shadows.

&nbsp;

## `.sdf_shadow(colour, alpha, xoffset, yoffset, [softness])`

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

## `.sdf_border(colour, thickness)`

**Returns**: The text element

|Name       |Datatype|Purpose                                                                |
|-----------|--------|-----------------------------------------------------------------------|
|`colour`   |integer |Colour of the glyph's border, as a standard GameMaker 24-bit BGR format|
|`thickness`|number  |Thickness of the border, in pixels                                     |

Sets the colour and thickness for a procedural SDF border. Setting the thickness to `0` will prevent the border from being drawn at all.

?> This method will only affect SDF fonts. If you'd like to add outlines to standard fonts or spritefonts, you may want to consider using a shadow baking function.

&nbsp;

## `.sdf_feather(thickness)`

**Returns**: The text element

|Name       |Datatype|Purpose                             |
|-----------|--------|------------------------------------|
|`thickness`|number  |Feather thickness, in pixels        |

Changes the softness/hardness of the SDF font outline. You may find you have to fiddle with this number to correct for screen scaling but, normally, this feature will not be needed. The feather thickness defaults to `1.0`.

?> This method will only affect SDF fonts.

&nbsp;

## `scribble_sdf_thickness_offset(offset)`

**Returns:** N/A (`undefined`)

|Name    |Datatype|Purpose                                                                         |
|--------|--------|--------------------------------------------------------------------------------|
|`offset`|number  |The global MSDF font thickness offset to apply. The default offset values is `0`|

Applies a global thickness adjustment to SDF fonts. An offset less than `0` will make SDF glyphs thinner, an offset greater than `0` will make SDF glyphs thicker. The offset value is very sensitive and values of `+/- 0.01` may make a significant difference to the appearance of glyphs.
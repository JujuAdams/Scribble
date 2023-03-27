# SDF Fonts

&nbsp;

## `.msdf_shadow(colour, alpha, xoffset, yoffset, [softness])`

**Returns**: The text element

|Name      |Datatype|Purpose                                                                                                  |
|----------|--------|---------------------------------------------------------------------------------------------------------|
|`colour`  |integer |The colour of the shadow, as a standard GameMaker 24-bit BGR format                                      |
|`alpha`   |number  |Opacity of the shadow, `0.0` being transparent and `1.0` being fully opaque                              |
|`xoffset` |number  |x-coordinate of the shadow, relative to the parent glyph                                                 |
|`yoffset` |number  |y-coordinate of the shadow, relative to the parent glyph                                                 |
|`softness`|number  |Optional. Larger values give a softer edge to the shadow. If not specified, this will default to `0.1` (which draws an antialiased but clean shadow edge)|

Sets the colour, alpha, and offset for a procedural MSDF shadow. Setting the alpha to `0` will prevent the shadow from being drawn at all. If you find that your shadow(s) are being clipped or cut off when using large offset values, [regenerate your MSDF fonts](msdf-fonts) using a larger `pxrange`.

?> This method will only affect [MSDF fonts](msdf-fonts). If you'd like to add shadows to standard fonts or spritefonts, you may want to consider [baking this effect](fonts?id=scribble_font_bake_shadowsourcefontname-newfontname-dx-dy-shadowcolor-shadowalpha-separation-smooth).

&nbsp;

## `.msdf_border(colour, thickness)`

**Returns**: The text element

|Name       |Datatype|Purpose                                                                |
|-----------|--------|-----------------------------------------------------------------------|
|`colour`   |integer |Colour of the glyph's border, as a standard GameMaker 24-bit BGR format|
|`thickness`|real    |Thickness of the border, in pixels                                     |

Sets the colour and thickness for a procedural MSDF border. Setting the thickness to `0` will prevent the border from being drawn at all. If you find that your glyphs have filled (or partially filled) backgrounds, [regenerate your MSDF fonts](msdf-fonts) using a larger `pxrange`.

?> This method will only affect [MSDF fonts](msdf-fonts). If you'd like to add outlines to standard fonts or spritefonts, you may want to consider [baking this effect](fonts?id=scribble_font_bake_outline_4dirsourcefontname-newfontname-color-smooth).

&nbsp;

## `.msdf_feather(thickness)`

**Returns**: The text element

|Name       |Datatype|Purpose                             |
|-----------|--------|------------------------------------|
|`thickness`|real    |Feather thickness, in pixels        |

Changes the softness/hardness of the MSDF font outline. You may find you have to fiddle with this number to correct for screen scaling but, normally, this feature will not be needed. The feather thickness defaults to `1.0`.

?> This method will only affect [MSDF fonts](msdf-fonts).

&nbsp;

## `scribble_msdf_thickness_offset(offset)`

**Returns:** N/A (`undefined`)

|Name    |Datatype|Purpose                                                                         |
|--------|--------|--------------------------------------------------------------------------------|
|`offset`|number  |The global MSDF font thickness offset to apply. The default offset values is `0`|

Applies a global thickness adjustment to MSDF fonts. An offset less than `0` will make MSDF glyphs thinner, an offset greater than `0` will make MSDF glyphs thicker. The offset value is very sensitive and values of `+/- 0.01` may make a significant difference to the appearance of glyphs.
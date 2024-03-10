# Outlines & Shadows

&nbsp;

Scribble allows you to bake outlines and shadows into either standard fonts or spritefonts. This is much more efficient than managing outline and shadow rendering yourself by using multiple draw calls. You can modify the colour of the outline and shadow per text element using the `.outline()` and `.shadow()` text element methods, though you cannot adjust the outlines thickness or shadow position via methods.

?> If you're using an SDF font you can use the SDF-specific outline and shadow functions to have even more control than what is offered here.

&nbsp;

## `scribble_font_bake_effects()`

**Global Function:** `scribble_font_bake_effects(sourceFontName, newFontName, outlineThickness, outlineSamples, shadowDX, shadowDY, smooth, [surfaceSize=2048])`

**Returns:** N/A (`undefined`)

|Name              |Datatype|Purpose                                                                                                                |
|------------------|--------|-----------------------------------------------------------------------------------------------------------------------|
|`sourceFontName`  |string  |Name of the source font, as a string                                                                                   |
|`newFontName`     |string  |Name of the new font to create, as a string                                                                            |
|`outlineThickness`|number  |Thickness of the outline effect                                                                                        |
|`outlineSamples`  |number  |Number of samples to use for the outline effect for each "layer" of thickness. Higher values lead to a smoother outline|
|`shadowDX`        |number  |x-axis displacement for the shadow effect                                                                              |
|`shadowDY`        |number  |y-axis displacement for the shadow effect                                                                              |
|`smooth`          |boolean |Whether or not to interpolate outline and shadow                                                                       |
|`[surfaceSize]`   |integer |Size of the surface to use. Defaults to 2048x2048                                                                      |

`scribble_font_bake_shadow()` creates a new font using a source font. This font contains special information that encodes the position of both an outline and a shadow for the new font.

!> Spritefonts will have all colour information stripped from them and their base colour will be changed to white.

&nbsp;

## `.outline()`

**Text Element Method:** `.outline(colour)`

**Returns**: The text element

|Name    |Datatype         |Purpose                                                                                                                                                                                                                                   |
|--------|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`colour`|integer or string|Basic text colour as either:<br>- standard GameMaker 24-bit BGR format<br>- name of a GameMaker colour constant<br>- name of a colour added to `__scribble_config_colours()`<br>- name of a colour added by calling `scribble_color_set()`|

Sets the colour for a baked outline. To disable the outline effect, use `undefined` for the outline colour.

&nbsp;

## `.shadow()`

**Text Element Method:** `.shadow(colour, alpha)`

**Returns**: The text element

|Name    |Datatype         |Purpose                                                                                                                                                                                                                                   |
|--------|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`colour`|integer or string|Basic text colour as either:<br>- standard GameMaker 24-bit BGR format<br>- name of a GameMaker colour constant<br>- name of a colour added to `__scribble_config_colours()`<br>- name of a colour added by calling `scribble_color_set()`|
|`alpha` |number           |Opacity of the shadow, `0.0` being transparent and `1.0` being fully opaque                                                                                                                                                               |

Sets the colour and alpha for a baked shadow. Setting the alpha to `0` will prevent the shadow from being drawn at all.
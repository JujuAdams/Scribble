# Font Outlines

&nbsp;

## `scribble_font_bake_outline_4dir()`

**Global Function:** `scribble_font_bake_outline_4dir(sourceFontName, newFontName, smooth, [surfaceSize=2048])`

**Returns:** N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                                        |
|----------------|--------|---------------------------------------------------------------------------------------------------------------|
|`sourceFontName`|string  |Name of the source font, as a string                                                                           |
|`newFontName`   |string  |Name of the new font to create, as a string                                                                    |
|`smooth`        |boolean |Whether or not to interpolate the outline. Set to `false` for pixel fonts, set to `true` for anti-aliased fonts|
|`[surfaceSize]` |integer |Size of the surface to use. Defaults to 2048x2048                                                              |

`scribble_bake_outline_4dir()` creates a new font using a source font. The new font will include a one-pixel thick outline in the 4 cardinal directions around each input glyph.

&nbsp;

## `scribble_font_bake_outline_8dir()`

**Global Function:** `scribble_font_bake_outline_8dir(sourceFontName, newFontName, smooth, [surfaceSize=2048])`

**Returns:** N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                                        |
|----------------|--------|---------------------------------------------------------------------------------------------------------------|
|`sourceFontName`|string  |Name of the source font, as a string                                                                           |
|`newFontName`   |string  |Name of the new font to create, as a string                                                                    |
|`smooth`        |boolean |Whether or not to interpolate the outline. Set to `false` for pixel fonts, set to `true` for anti-aliased fonts|
|`[surfaceSize]` |integer |Size of the surface to use. Defaults to 2048x2048                                                              |

`scribble_bake_outline_8dir()` creates a new font using a source font. The new font will include a 1-pixel thick outline in the 8 compass directions around each input glyph. For a thicker variation on this shader, try `scribble_font_bake_outline_8dir_2px()`.

&nbsp;

## `scribble_font_bake_outline_8dir_2px()`

**Global Function:** `scribble_font_bake_outline_8dir_2px(sourceFontName, newFontName, smooth, [surfaceSize=2048])`

**Returns:** N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                                        |
|----------------|--------|---------------------------------------------------------------------------------------------------------------|
|`sourceFontName`|string  |Name of the source font, as a string                                                                           |
|`newFontName`   |string  |Name of the new font to create, as a string                                                                    |
|`smooth`        |boolean |Whether or not to interpolate the outline. Set to `false` for pixel fonts, set to `true` for anti-aliased fonts|
|`[surfaceSize]` |integer |Size of the surface to use. Defaults to 2048x2048                                                              |

`scribble_bake_outline_8dir()` creates a new font using a source font. The new font will include a 2-pixel thick outline in the 8 compass directions around each input glyph. This is useful for more cartoony text, especially high resolution anti-aliased text.

&nbsp;

## `.outline()`

**Text Element Method:** `.outline(colour)`

**Returns**: The text element

|Name    |Datatype         |Purpose                                                                                                                                                                                                                                   |
|--------|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`colour`|integer or string|Basic text colour as either:<br>- standard GameMaker 24-bit BGR format<br>- name of a GameMaker colour constant<br>- name of a colour added to `__scribble_config_colours()`<br>- name of a colour added by calling `scribble_color_set()`|

This function adds a coloured outline around your text. Setting the thickness to `0` will prevent the outline from being drawn at all. The coloured outline will not be colourised or tinted due to the use of other functionality.
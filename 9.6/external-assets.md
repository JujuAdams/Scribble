# External Assets

&nbsp;

## `scribble_external_sound_add(soundID, alias)`

**Returns:** N/A (`undefined`)

|Name   |Datatype                                                          |Purpose                                                    |
|-------|------------------------------------------------------------------|-----------------------------------------------------------|
|`sound`|[sound](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm)|The sound to target                                        |
|`alias`|string                                                            |A string to use to refer to the sound in Scribble functions|

Adds a sound that can be referenced in Scribble functions using the given alias. This is intended for use with externally added sounds via `audio_create_stream()` or `audio_create_buffer_sound()`.

&nbsp;

## `scribble_external_sound_remove(alias)`

**Returns:** N/A (`undefined`)

|Name   |Datatype|Purpose                                         |
|-------|--------|------------------------------------------------|
|`alias`|string  |The external sound alias to remove from Scribble|

&nbsp;

## `scribble_external_sound_exists(alias)`

**Returns:** Boolean, whether the alias has been added by `scribble_external_sound_add()`

|Name   |Datatype|Purpose                              |
|-------|--------|-------------------------------------|
|`alias`|string  |The external sound alias to check for|

&nbsp;

## `scribble_external_sprite_add(sprite, alias)`

**Returns:** N/A (`undefined`)

|Name    |Datatype                                                            |Purpose                                                     |
|--------|--------------------------------------------------------------------|------------------------------------------------------------|
|`sprite`|[sprite](https://manual.yoyogames.com/The_Asset_Editors/Sprites.htm)|The sprite to target                                        |
|`alias` |string                                                              |A string to use to refer to the sprite in Scribble functions|

Adds a sprite that can be referenced in Scribble formatting tags using the given alias. This is intended for use with externally added sounds via `sprite_add()` or `sprite_create_from_surface()` etc.

&nbsp;

## `scribble_external_sprite_remove(alias)`

**Returns:** N/A (`undefined`)

|Name     |Datatype|Purpose                                          |
|---------|--------|-------------------------------------------------|
|`alias`  |string  |The external sprite alias to remove from Scribble|

&nbsp;

## `scribble_external_sprite_exists(alias)`

**Returns:** Boolean, whether the alias has been added by `scribble_external_sprite_add()`

|Name     |Datatype|Purpose                               |
|---------|--------|--------------------------------------|
|`alias`  |string  |The external sprite alias to check for|

&nbsp;

## `scribble_external_font_add(sprite, image, yyJSON, [fontName], [isKrutidev=false])`

**Returns:** N/A (`undefined`)

|Name         |Datatype|Purpose                                                                                                |
|--------------|--------|------------------------------------------------------------------------------------------------------|
|`sprite`      |sprite  |Sprite to use as the glyph texture atlas for the font                                                 |
|`image`       |integer |Image of the sprite to use                                                                            |
|`yyJSON`      |struct  |JSON obtained by parsing the contents of the font's .yy file                                          |
|`[fontName]`  |string  |Name of the font to use for Scribble. If not specified, the font's name is extracted from the .yy JSON|
|`[isKrutidev]`|boolean |Whether the font should be treated as a Krutidev font. If not specified, defaults to `false`          |

Adds a font to Scribble using the font texture and font .yy file stored within project files. This function is intended for use with games that would like to support moddable content or for writing external editors that need to hook into project assets.

!> This function is *not* a replacement for `font_add()` and will not inherently handle dynamic glyph creation.

&nbsp;

## `scribble_external_font_remove(fontName)`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                                              |
|----------|--------|-----------------------------------------------------|
|`fontName`|string  |The name of the external font to remove from Scribble|

Removes a font that was added using `scribble_external_font_add()`.

!> Removing a font with this function will trigger a refreshing of all text elements. This carries a performance penalty. As a result, you should not call this function often.

&nbsp;

## `scribble_external_sound_exists(fontName)`

**Returns:** Boolean, whether the named font has been added by `scribble_external_font_add()`

|Name      |Datatype|Purpose                                   |
|----------|--------|------------------------------------------|
|`fontName`|string  |The name of the external font to check for|

Returns if a font with the specified name exists and has been added as an external font using `scribble_external_font_add()`. This function will return `false` if a font exists but was *not* created by calling `scribble_external_font_add()`.
# Font Setup

&nbsp;

### `scribble_font_add(fontName, [yyPath], [texture])`

**Returns:** N/A (`undefined`)

|Name       |Datatype|Purpose                                                                                                                                                |
|-----------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------|
|`fontName` |string  |Name of the font to add, as a string                                                                                                                   |
|`[yyPath]` |string  |File path for the font's .yy file, including the .yy extension, relative to the font directory defined in [`__scribble_config_macros()`](configuration)|
|`[texture]`|texture |Custom texture to use for this font e.g. returned by `sprite_get_texture()`                                                                            |

Scribble requires that you explicitly initialise fonts for use with Scribble. This is a three-step process:

1. Add a normal GameMaker font resource through the IDE
2. Click the Regenerate button in font dialogue inside the GameMaker IDE
3. Open the fonts folder (can be done by right clicking on the font and pressing "Open in Explorer")
4. Add the font's .yy file as an Included File (via datafiles in the project directory, or by the "Included Files" menu)
5. Call `scribble_add_font()` targeting the font

Scribble needs to access information that GameMaker generates. All this information is contained in a single .yy file in the font's folder on disk inside the project directory. This file can sometimes be frustrating to locate, but fortunately there's a shortcut we can take. In the IDE, Navigate to the font resource you wish to add and right click on it. From the drop-down menu, select "Show In Explorer". A window will open showing various files for the font resource. You can drag-and-drop the .yy file into the GameMaker IDE to add it as an Included File.

_**Please note** that if you change any font properties then the associated .yy file in Included Files will need to be updated too._

&nbsp;

&nbsp;

### `scribble_font_add_all()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

A convenience function that adds every normal font in your project to Scribble. Accordingly, you must follow the instructions for [`scribble_font_add()`](font-setup?id=scribble_font_addfontname-yypath-texture) for every font in your project.

&nbsp;

&nbsp;

### `scribble_font_add_from_sprite(fontName, mapString, separation, [spaceWidth], [proportional])`

**Returns:** N/A (`undefined`)

|Name            |Datatype|Purpose                                                                                                                                        |
|----------------|--------|-----------------------------------------------------------------------------------------------------------------------------------------------|
|`fontName`      |string  |Name of the spritefont to add, as a string                                                                                                     |
|`mapString`     |string  |String from which sprite sub-image order is taken                                                                                              |
|`separation`    |integer |The space to leave between each letter                                                                                                         |
|`[spaceWidth]`  |integer |Pixel width of the space character. Defaults to emulating GameMaker's behaviour                                                                |
|`[proportional]`|boolean |Allows characters to have variable widths depending on their size. Defaults to `true`. Set to `false` to make every character's width identical|

`[spaceWidth]` can be given the value `undefined` to indicate that the default value should be used.

`scribble_font_add_from_sprite()` emulates the behaviour of [`font_add_sprite_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Fonts/font_add_sprite_ext.htm). For more information on the behaviour of [`font_add_sprite_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Fonts/font_add_sprite_ext.htm), please refer to the GameMaker Studio 2 documentation.

Sprites used for spritefonts have specific requirements that must be met for Scribble to render them properly:
1) Collision mask mode set to **Automatic**
2) Colllision mask type set to **Precise Per Frame (Slow)**
3) "Separate Texture Page" set to **off**
4) The sprite must have at least a 1 pixel transparent border around the edge
5) Origin of the sprite should be set to top-left (unless you want to bulk offset your spritefont glyphs)

If your characters are drawn partially garbled, try placing the spritefont in its own texture group.

Unlike [standard fonts](Functions-(Font-Setup)#scribble_font_addfontname-yypath-texture), spritefonts do **not** need to have any files added as Included Files. Spritefonts will **not** be added by [`scribble_font_add_all()`](font-setup?id=scribble_font_add_all).

&nbsp;

&nbsp;

### `scribble_font_add_msdf(fontName, sprite, jsonName)`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                                                                    |
|----------|--------|---------------------------------------------------------------------------|
|`fontName`|string  |Name of the font to use within Scribble e.g. to change font                |
|`sprite`  |sprite  |Sprite that contains the MSDF atlas                                        |
|`jsonName`|string  |JSON source file to read glyph data from, usually added as an Included File|

Please read [the MSDF article](msdf-fonts) for more information on generating and adding MSDF fonts to Scribble.

&nbsp;

&nbsp;

### `scribble_font_set_default(fontName)`

**Returns:** N/A (`undefined`)

|Name       |Datatype|Purpose                                                                                                                                                                                            |
|-----------|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`fontName` |string  |Name of the font to set as the default, as a string                                                                                                                                                               |

This function sets the default font to use for future [`scribble()`](scribble-methods) calls.
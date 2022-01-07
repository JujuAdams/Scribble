`scribble_add_font(fontName, [yyPath], [texture])`

**Returns:** N/A (`0`)

|Argument|Name       |Purpose                                                                                                                                                                                            |
|--------|-----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|0       |`fontName` |Name of the font to add, as a string                                                                                                                                                               |
|[1]     |`[yyPath]` |File path for the font's .yy file, including the .yy extension, relative to the font directory defined by `scribble_init()`. If not specified, Scribble will look in the root of the font directory|
|[2]     |`[texture]`|Custom texture to use for this font e.g. returned by `sprite_get_texture()`                                                                                                                        |

Scribble requires that you explicitly initialise fonts for use with Scribble. This is a three-step process:

1. Add a normal GameMaker font resource through the IDE
2. Click the `Regenerate` button in font dialogue inside the GameMaker IDE, then add the font's .yy file as an Included File (found in the font's folder in the project directory)
3. Call `scribble_add_font()` targeting the font

Scribble needs to access information that GameMaker generates. All this information is contained in a single .yy file in the font's folder on disk inside the project directory. This file can sometimes be frustrating to locate, but fortunately there's a shortcut we can take. In the IDE, Navigate to the font resource you wish to add and right click on it. From the drop-down menu, select "Show In Explorer". A window will open showing various files for the font resource. You can drag-and-drop the .yy file into the GameMaker IDE to add it as an Included File.

***Please note** that if you change any font properties then the associated .yy file in Included Files will need to be updated too.*
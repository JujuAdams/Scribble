`scribble_add_spritefont(fontName, mapString, separation, [spaceWidth], [proportional])`

**Returns:** N/A (`0`)

|Argument|Name            |Purpose                                                                                                                                        |
|--------|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
|0       |`fontName`      |Name of the spritefont to add, as a string                                                                                                     |
|1       |`mapString`     |String from which sprite sub-image order is taken                                                                                              |
|2       |`separation`    |The space to leave between each letter                                                                                                         |
|[3]     |`[spaceWidth]`  |Pixel width of the space character. Defaults to emulating GameMaker's behaviour                                                                |
|[4]     |`[proportional]`|Allows characters to have variable widths depending on their size. Defaults to `true`. Set to `false` to make every character's width identical|

`[spaceWidth]` can be given the value `undefined` to indicate that the default value should be used.

`scribble_add_spritefont()` emulates the behaviour of [`font_add_sprite_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Fonts/font_add_sprite_ext.htm). For more information on the behaviour of [`font_add_sprite_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Fonts/font_add_sprite_ext.htm), please refer to the GameMaker Studio 2 documentation.

Sprites used for spritefonts have specific requirements that must be met for Scribble to render them properly:
1) Collision mask mode set to **Automatic**
2) Colllision mask type set to **Precise Per Frame (Slow)**
3) "Separate Texture Page" set to **off**
4) The sprite must have at least a 1 pixel transparent border around the edge

If your characters are drawn partially garbled, try placing the spritefont in its own texture group.

Unlike [standard fonts](scribble_add_font), spritefonts do **not** need to have any files added as Included Files.

Spritefonts will **not** be added by using the `autoScan` feature of [`scribble_init()`](scribble_init). Each spritefont must be added manually by calling `scribble_add_spritefont()`.
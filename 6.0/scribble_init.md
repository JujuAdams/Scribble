`scribble_init(defaultFont, [fontDirectory], [autoscan])`

**Returns:** Whether initialisation was successful (a boolean)

|Argument|Name             |Purpose                                                                                                                                                                                                                                          |
|--------|-----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|0       |`defaultFont`    |Name of the default Scribble font to use, as a string                                                                                                                                                                                            |
|1       |`[fontDirectory]`|Directory to look in for font .yy files, relative to the Included Files root folder. Defaults to `""`, the root of Included Files<br><br>_**N.B.** Some platforms have weird Included Files behaviour and you may need to leave this argument as `""`_|
|2       |`[autoscan]`     |Whether or not to automatically find normal font .yy files in the font directory. Defaults to `false`<br><br>_**N.B.** The `autoscan` feature only works for normal fonts (non-spritefont)._                                                     |

This function initialises Scribble and must be called before any other Scribble function. If this function is called twice then an error will be thrown.
`scribble_add_color(name, color, [colorIsGameMakerBGR])`

**Returns:** N/A (`0`)

|Argument|Name                   |Purpose                                                                                       |
|--------|-----------------------|----------------------------------------------------------------------------------------------|
|0       |`tagName`              |Formatting tag name to use for the color, as a string                                         |
|1       |`color`                |The color itself as a 24-bit integer                                                          |
|[2]     |`[colorIsGameMakerBGR]`|Whether the colour is in GameMaker's propriatery 24-bit BGR colour format. Defaults to `false`|

This function adds a colour to Scribble's internal list. This colour can then be used as an inline command tag in Scribble strings.
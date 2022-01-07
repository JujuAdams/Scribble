`scribble_whitelist_sprite(spriteIndex, [spriteIndex], ...)`

**Returns:** N/A (`0`)

|Argument|Name              |Purpose                       |
|--------|------------------|------------------------------|
|0       |`spriteIndex`     |Sprite index to whitelist     |
|[1]     |`[spriteIndex]`   |Additional sprite to whitelist|
|...     |...               |...                           |

This function allows for specific sprites to be whitelisted for use in Scribble. If a sprite is used in a string and hasn't been whitelisted then an error will be thrown.

If this function is not called in the game, all sprites are considered permitted.
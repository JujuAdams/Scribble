`scribble_reset()`

**Returns:** N/A (`0`)

|Argument|Name|Purpose|
|--------|----|-------|
|None    |    |       |

Resets Scribble's global state. All text drawn with [`scribble_draw()`](scribble_draw) or cached with [`scribble_cache()`](scribble_cache) will use these settings until otherwise modified.

This function is called once by [`scribble_init()`](scribble_init) to initialise the library, and **you should edit this script to customise Scribble for your own purposes.**
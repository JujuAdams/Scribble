`scribble_draw(x, y, content, [occuranceName])`

**Returns:** The text element used to draw the content

|Argument|Name           |Purpose                                                                   |
|--------|---------------|--------------------------------------------------------------------------|
|0       |`x`            |x position in the room to draw at                                         |
|1       |`y`            |y position in the room to draw at                                         |
|2       |`content`      |Either:<br>1. A string to be drawn<br>2. A previously created text element via [`scribble_draw()`](https://github.com/JujuAdams/ScribbleOldDocs/wiki/(6.0.0)-scribble_draw) or [`scribble_cache()`](https://github.com/JujuAdams/ScribbleOldDocs/wiki/(6.0.0)-scribble_cache)|
|[3]     |`[occuranceName]`|ID to reference a specific unique occurance of a text element. This can be a string or a number. Defaults to [`SCRIBBLE_DEFAULT_OCCURANCE_NAME`](__scribble_macros)|

Scribble allows for many kinds of inline formatting tags. Please read the [Text Formatting](text-formatting) article for more information.

Scribble uses a cache to help manage memory. When calling `scribble_draw()` with a string, Scribble will check if that string is currently in the cache. If the string cannot be found in the cache then Scribble will generate a new text element for you and add it to the cache, and that text element will be automatically garbage collected by Scribble if it has not been drawn for a certain period of time (defined by the [`SCRIBBLE_CACHE_TIMEOUT`](__scribble_macros) macro). If you'd like to control whether a specific text element will be garbage collected, please use [`scribble_cache()`](scribble_cache).
`scribble_page_get(element, [occuranceName])`

**Returns:** Page that is currently being drawn, starting at 0 for the first page

|Argument|Name     |Purpose                                                               |
|--------|---------|----------------------------------------------------------------------|
|0       |`element`|Text element to target. This element must have been created previously by [`scribble_draw()`](scribble_draw) or [`scribble_cache()`](scribble_cache)|
|[1]     |`[occuranceName]`|ID to reference a specific unique occurance of a text element. This can be a string or a number. Defaults to [`SCRIBBLE_DEFAULT_OCCURANCE_NAME`](__scribble_macros)             |

This function is intended for use with [`scribble_page_set()`](scribble_page_set).
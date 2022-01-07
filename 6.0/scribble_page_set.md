`scribble_page_set(element, page, [occuranceName])`

**Returns:** Page that is currently being drawn, starting at 0 for the first page

|Argument|Name     |Purpose                                                               |
|--------|---------|----------------------------------------------------------------------|
|0       |`element`|Text element to target. This element must have been created previously by [`scribble_draw()`](scribble_draw) or [`scribble_cache()`](scribble_cache)|
|1       |`page`   |Page to display, starting at 0 for the first page|
|[2]     |`[occuranceName]`|ID to reference a specific unique occurance of a text element. This can be a string or a number. Defaults to [`SCRIBBLE_DEFAULT_OCCURANCE_NAME`](__scribble_macros)             |

This function is intended for use with [`scribble_page_get()`](scribble_page_get).

Please note that changing the page will reset any typewriter animations i.e. those started by [`scribble_autotype_fade_in()`](https://github.com/JujuAdams/ScribbleOldDocs/wiki/(6.0.0)-scribble_autotype_fade_in) and [`scribble_autotype_fade_out()`](https://github.com/JujuAdams/ScribbleOldDocs/wiki/(6.0.0)-scribble_autotype_fade_out).
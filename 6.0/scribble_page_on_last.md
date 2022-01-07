`scribble_page_on_last(element, [occuranceName])`

**Returns:** Boolean; whether the page that is being drawn is the last page for the text element

|Argument|Name     |Purpose                                                               |
|--------|---------|----------------------------------------------------------------------|
|0       |`element`|Text element to target. This element must have been created previously by [`scribble_draw()`](scribble_draw) or [`scribble_cache()`](scribble_cache)|
|[1]     |`[occuranceName]`|ID to reference a specific unique occurance of a text element. This can be a string or a number. Defaults to [`SCRIBBLE_DEFAULT_OCCURANCE_NAME`](__scribble_macros)             |
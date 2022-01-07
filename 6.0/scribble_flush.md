`scribble_flush([textElement])`

**Returns:** N/A (`0`)

|Argument|Name        |Purpose             |
|--------|------------|--------------------|
|[0]       |`[textElement]`|Text element to flush, or the keyword `all` indicating that all text elements should be flushed. Defaults to `all`|

All text elements created by [`scribble_cache()`](scribble_cache) that are set to **not** be garbage collected must be flushed using `scribble_flush()` to prevent memory leaks.
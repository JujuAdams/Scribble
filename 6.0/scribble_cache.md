`scribble_cache(string, [occuranceName], [garbageCollect], [freeze])`

**Returns:** A text element, as an array

|Argument|Name              |Purpose                                                                                                                                                          |
|--------|------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
|0       |`string`          |String to cache                                                                                                                                                  |
|[1]     |`[occuranceName]` |ID to reference a specific unique occurance of a text element. This can be a string or a number. Defaults to [`SCRIBBLE_DEFAULT_OCCURANCE_NAME`](__scribble_macros)                                                                             |
|[1]     |`[garbageCollect]`|Whether to automatically clean up memory allocated for the returned text element (if created). Defaults to `true`                                                |
|[2]     |`[freeze]`        |Whether to freeze text vertex buffers or not. This substantially increases the time taken to cache new strings but makes drawing much faster. Defaults to `false`|

Scribble allows for many kinds of inline formatting tags. Please read the [Text Formatting](text-formatting) article for more information.

Scribble uses a cache to help manage memory. Scribble text will be automatically garbage collected if one of two things happens:
1. [`scribble_flush()`](scribble_flush) has been called targeting the text element
2. The text is set to be garbage collected, and has not been drawn for a period of time (defined by the [`SCRIBBLE_CACHE_TIMEOUT`](__scribble_macros) macro)
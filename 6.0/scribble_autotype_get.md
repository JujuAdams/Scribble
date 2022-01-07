`scribble_autotype_get(element, [occuranceName])`

**Returns:** Real value from 0 to 2 (inclusive) that represents what proportion of text is visible

|Argument|Name        |Purpose                                                               |
|--------|------------|----------------------------------------------------------------------|
|0       |`element`   |Text element to target. This element must have been created previously by [`scribble_draw()`](scribble_draw) or [`scribble_cache()`](scribble_cache)|
|[1]     |`[occuranceName]`|ID to reference a specific unique occurance of a text element. This can be a string or a number. Defaults to [`SCRIBBLE_DEFAULT_OCCURANCE_NAME`](__scribble_macros)             |

The value returned by this function is as follows:

|Value|Visibility             |
|--------------|-----------------------|
|`= 0`|No text is visible     |
|`> 0`<br>`< 1`|Text is fading in. This value is the proportion of text that is visible<br>e.g. `0.4` is 40% visibility|
|`= 1`|Text is fully visible and the fade in animation has finished|
|`> 1`<br>`< 2`|Text is fading out. 2 minus this value is the proportion of text that is visible<br>e.g. `1.6` is 40% visibility|
|`= 2`|No text is visible and the fade out animation has finished|

If no autotype animation has been started, this function will return `1`.
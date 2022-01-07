`scribble_autotype_function(textElement, callbackFunction, [occuranceName])`

**Returns:** N/A (`0`)

|Argument|Name              |Purpose                                             |
|--------|------------------|----------------------------------------------------|
|0       |`textElement`     |Text element to target                              |
|1       |`callbackFunction`|Function to execute whenever a character is revealed|
|[2]     |`[occuranceName]` |ID to reference a specific unique occurance of a text element. This can be a string or a number. Defaults to [`SCRIBBLE_DEFAULT_OCCURANCE_NAME`](__scribble_macros)|

This function allows you to define a callback function that will be executed once per character as that character is revealed. The callback function is given two arguments: the text element that triggered the callback, and the position of the character that was just revealed.

This function is perhaps best used in conjunction with the [`SCRIBBLE_CREATE_CHARACTER_ARRAY`](__scribble_macros) macro.
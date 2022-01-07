`scribble_shader_add_property(name, index, defaultValue)`

**Returns:** N/A (`0`)

|Argument|Name          |Purpose                                                                       |
|--------|--------------|------------------------------------------------------------------------------|
|0       |`name`        |Effect name, as a string                                                      |
|1       |`index`       |Integer effect index, from `1` to `SCRIBBLE_SHADER_MAX_PROPERTIES-1` inclusive|
|2       |`defaultValue`|Default value that this property should take, set when this function or [`scribble_state_reset()`](scribble_state_reset) are run|
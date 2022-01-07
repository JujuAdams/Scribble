`scribble_occurance(element, occuranceID, [allowNew])`

**Returns:** Array that contains occurance data

|Argument|Name         |Purpose                                                                                                                                                        |
|--------|-------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
|0       |`element`    |Text element to target. This element must have been created previously by [`scribble_draw()`](scribble_draw) or [`scribble_cache()`](scribble_cache)|                                                            |
|1       |`occuranceID`|ID to reference a specific unique occurance of a text element. This can be a string or a number                                                                                                        |
|[2]     |`[allowNew]` |Set to `true` to create a new occurance if an occurance with the given ID doesn't already exist                                                                |
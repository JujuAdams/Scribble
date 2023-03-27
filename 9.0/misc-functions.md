# Miscellaneous 

&nbsp;

## `scribble_is_text_element(value)`

**Returns:** Boolean, whether the provided value is a Scribble text element

|Name   |Datatype|Purpose      |
|-------|--------|-------------|
|`value`|any     |Value to test|

&nbsp;

## `scribble_msdf_thickness_offset(offset)`

**Returns:** N/A (`undefined`)

|Name    |Datatype|Purpose                                                                         |
|--------|--------|--------------------------------------------------------------------------------|
|`offset`|number  |The global MSDF font thickness offset to apply. The default offset values is `0`|

Applies a global thickness adjustment to MSDF fonts. An offset less than `0` will make MSDF glyphs thinner, an offset greater than `0` will make MSDF glyphs thicker. The offset value is very sensitive and values of `+/- 0.01` may make a significant difference to the appearance of glyphs.

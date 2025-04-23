# Colour Functions 

&nbsp;

## `scribble_color_set(name, color)`

**Returns:** N/A (`undefined`)

|Name    |Datatype|Purpose                                                      |
|--------|--------|-------------------------------------------------------------|
|`name`  |string  |Name to use for the colour's formatting tag                  |
|`colour`|integer |Blend colour used when drawing text, applied multiplicatively|

Adds a colour to Scribble for use as a formatting tag e.g. a colour named `"c_banana"` will be available for use as the formatting tag `[c_banana]`.

If the colour is set to `undefined` then it will be deleted from Scribble.

!> Changing colours with this function will trigger a refreshing of all text elements to keep colours up to date. This carries a performance penalty. As a result, you should not change colours frequently, and this function should typically be used at the start of the game or on loading screens etc.

&nbsp;

## `scribble_color_get(name)`

**Returns:** GM-native BGR colour

|Name    |Datatype|Purpose                                    |
|--------|--------|-------------------------------------------|
|`name`  |string  |Name to use for the colour's formatting tag|

Returns the 24-bit BGR value for the given colour.

&nbsp;

## `scribble_rgb_to_bgr(RGB)`

**Returns:** GM-native BGR colour

|Name |Datatype|Purpose                                        |
|-----|--------|-----------------------------------------------|
|`RGB`|integer |Industry standard (`#RRGGBB`) 24-bit RGB colour|

Converts an RGB colour code (the industry standard) to GameMaker's native BGR format.
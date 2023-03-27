# Regions

&nbsp;

## `[region,<name>`

**Command tag.** Creates a region of text that can be detected later. Useful for tooltips and hyperlinks.

&nbsp;

## `[/region]`

**Command tag.** Ends a region.

&nbsp;

## `.region_detect(elementX, elementY, pointerX, pointerY)`

**Returns:** String, the name of the region that is being pointed to, or `undefined` if no region is being pointed to

|Name      |Datatype|Purpose                                                                                                    |
|----------|--------|-----------------------------------------------------------------------------------------------------------|
|`elementX`|number  |x position of the text element in the room (usually the same as the coordinate you'd specify for `.draw()`)|
|`elementY`|number  |y position of the text element in the room (usually the same as the coordinate you'd specify for `.draw()`)|
|`pointerX`|number  |x position of the mouse/cursor                                                                             |
|`pointerY`|number  |y position of the mouse/cursor                                                                             |

This function returns the name of a region if one is being hovered over. You can define a region in your text by using the `[region,<name>]` and `[/region]` formatting tags.

!> Using this function requires that `SCRIBBLE_ALLOW_GLYPH_DATA_GETTER` be set to `true`.

&nbsp;

## `.region_set_active(name, colour, blendAmount)`

**Returns:** N/A (`undefined`)

|Name         |Datatype|Purpose                                                                |
|-------------|--------|-----------------------------------------------------------------------|
|`name`       |string  |Name of the region to highlight. Use `undefined` to highlight no region|
|`colour`     |integer |Colour to highlight the region (a standard GameMaker BGR colour)       |
|`blendAmount`|number  |Blend factor to apply for the highlighted region                       |

This function expects the name of a region that has been defined in your text using the `[region,<name>]` and `[/region]` formatting tags. You can get the name of the region that the player is currently highlighting with their cursor by using `.region_detect()`.

&nbsp;

## `.region_get_active()`

**Returns:** String, the name of the active region, or `undefined` if no region is active

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |
# Size Getters

&nbsp;

## `.get_left(x)`

**Returns:** Real, the left position of the text element's axis-aligned bounding box in the room

|Name|Datatype|Purpose                                   |
|----|--------|------------------------------------------|
|`x` |real    |x position of the text element in the room|

This function takes into account the transformation and padding applied to the text element.

If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

&nbsp;

## `.get_top(y)`

**Returns:** Real, the top position of the text element's axis-aligned bounding box in the room

|Name|Datatype|Purpose                                   |
|----|--------|------------------------------------------|
|`y` |real    |y position of the text element in the room|

This function takes into account the transformation and padding applied to the text element.

If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

&nbsp;

## `.get_right(x)`

**Returns:** Real, the right position of the text element's axis-aligned bounding box in the room

|Name|Datatype|Purpose                                   |
|----|--------|------------------------------------------|
|`x` |real    |x position of the text element in the room|

This function takes into account the transformation and padding applied to the text element.

If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

&nbsp;

## `.get_bottom(y)`

**Returns:** Real, the bottom position of the text element's axis-aligned bounding box in the room

|Name|Datatype|Purpose                                   |
|----|--------|------------------------------------------|
|`y` |real    |y position of the text element in the room|

This function takes into account the transformation and padding applied to the text element.

If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

&nbsp;

## `.get_width()`

**Returns:** Real, width of the text element in pixels (ignoring rotation and scaling)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

!> This function returns the untransformed width of the text element. This will **not** take into account rotation or scaling applied by the `.transform()` method but will take into account padding.

&nbsp;

## `.get_height()`

**Returns:** Real, height of the text element in pixels (ignoring rotation and scaling)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

!> This functions returns the untransformed height of the text element. This will **not** take into account rotation or scaling applied by the `.transform()` method but will take into account padding.

&nbsp;

## `.get_bbox(x, y)`

**Returns:** Struct containing the positions of the bounding box for a text element

|Name|Datatype|Purpose               |
|----|--------|----------------------|
|`x` |real    |x position in the room|
|`y` |real    |y position in the room|

This functions returns the **transformed** width and height of the text element. This **will** take into account rotation or scaling applied by the `.transform()` method as well as padding. If `SCRIBBLE_BOUNDING_BOX_USES_PAGE` is set to `true`, only text on the current page will be included in the bounding box.

The struct returned by `.get_bbox()` contains the following member variables:

|Variable        |Purpose                                      |
|----------------|---------------------------------------------|
|`x`             |x position passed into the `.get_bbox()` call|
|`y`             |y position passed into the `.get_bbox()` call|
|**Axis-aligned**|                                             |
|`left`          |Axis-aligned lefthand boundary               |
|`top`           |Axis-aligned top boundary                    |
|`right`         |Axis-aligned righthand boundary              |
|`bottom`        |Axis-aligned bottom boundary                 |
|`width`         |Axis-aligned width of the bounding box       |
|`height`        |Axis-aligned height of the bounding box      |
|**Oriented**    |                                             |
|`x0`            |x position of the top-left corner            |
|`y0`            |y position of the top-left corner            |
|`x1`            |x position of the top-right corner           |
|`y1`            |y position of the top-right corner           |
|`x2`            |x position of the bottom-left corner         |
|`y2`            |y position of the bottom-left corner         |
|`x3`            |x position of the bottom-right corner        |
|`y3`            |y position of the bottom-right corner        |

&nbsp;

## `.get_bbox_revealed(x, y, [typist])`

**Returns:** Struct containing the positions of the bounding box for a text element

|Name    |Datatype|Purpose                                                                                                                     |
|--------|--------|----------------------------------------------------------------------------------------------------------------------------|
|`x`     |number  |x position in the room                                                                                                      |
|`y`     |number  |y position in the room                                                                                                      |
|`typist`|typist  |Typist being used to render the text element. If not specified, the manual reveal value is used instead (set by `.reveal()`)|

The struct returned by `.get_bbox_revealed()` contains the same member variables as `.get_bbox()`; see above for details. Only text that is visible will be considered for calculating the bounding boxes.

This functions returns the **transformed** width and height of the text element. This **will** take into account rotation or scaling applied by the `.transform()` method as well as padding.
`scribble_get_bbox(x, y, content, [leftPad], [topPad], [rightPad], [bottomPad])`

**Returns:** 14-element array containing the positions of the bounding box for a text element. See below

|Argument|Name           |Purpose                                                                                            |
|--------|---------------|---------------------------------------------------------------------------------------------------|
|0       |`x`            |x position in the room                                                                             |
|1       |`y`            |y position in the room                                                                             |
|2       |`content`      |Either:<br>1. A string<br>2. A previously created text element via [`scribble_draw()`](scribble_draw) or [`scribble_cache()`](scribble_cache)|
|[3]     |`[leftPad]`    |Extra space on the left-hand side of the textbox. Positive values create more space. Defaults to 0 |
|[4]     |`[topPad]`     |Extra space on the top of the textbox. Positive values create more space. Defaults to 0            |
|[5]     |`[rightPad]`   |Extra space on the right-hand side of the textbox. Positive values create more space. Defaults to 0|
|[6]     |`[bottomPad]`  |Extra space on the bottom of the textbox. Positive values create more space. Defaults to 0         |

The array returned by scribble_get_bbox() has 14 elements as defined by the enum `SCRIBBLE_BBOX`:

|Element         |Purpose                                    |
|----------------|-------------------------------------------|
|**Axis-aligned**|                                           |
|`L`             |Axis-aligned lefthand boundary             |
|`T`             |Axis-aligned top boundary                  |
|`R`             |Axis-aligned righthand boundary            |
|`B`             |Axis-aligned bottom boundary               |
|`W`             |Axis-aligned width of the bounding box     |
|`H`             |Axis-aligned height of the bounding box    |
|**Oriented**    |                                           |
|`X0`            |x position of the top-left corner          |
|`Y0`            |y position of the top-left corner          |
|`X1`            |x position of the top-right corner         |
|`Y1`            |y position of the top-right corner         |
|`X2`            |x position of the bottom-left corner       |
|`Y2`            |y position of the bottom-left corner       |
|`X3`            |x position of the bottom-right corner      |
|`Y3`            |y position of the bottom-right corner      |
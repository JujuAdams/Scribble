# Alignment
 
&nbsp;

## `.align()`

**Global Function:** `.align(halign, valign)`

**Returns**: The text element

|Name    |Datatype                                                                                                                  |Purpose                                                                                               |
|--------|--------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
|`halign`|[halign constant](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/draw_set_halign.htm)|Starting horizontal alignment of **each line** of text. Accepts `fa_left`, `fa_right`, and `fa_center`|
|`valign`|[valign constant](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/draw_set_valign.htm)|Starting vertical alignment of the **entire textbox**. Accepts `fa_top`, `fa_bottom`, and `fa_middle` |

Sets the starting horizontal and vertical alignment for your text. You can change alignment using in-line [command tags](text-formatting) as well, though do note there are some limitations when doing so.

!> This method is a *regenerator*. If the value is changed then the text element will be regenerated, potentially leading to degraded performance.

&nbsp;

## `[fa_left]`

**Command tag.**

Horizontally align this line of text to the left of the [`.draw()`](scribble-methods?id=drawx-y) coordinate.

&nbsp;

## `[fa_center]` `[fa_centre]`

**Command tag.**

Horizontally align this line of text centrally at the [`.draw()`](scribble-methods?id=drawx-y) coordinate.

&nbsp;

## `[fa_right]`

**Command tag.**

Horizontally align this line of text to the right of the [`.draw()`](scribble-methods?id=drawx-y) coordinate.

&nbsp;

## `[fa_justify]`

**Command tag.**

Increases the space between words in a line of text such that each lines fills the maximum width.

&nbsp;

## `[fa_top]`

**Command tag.**

Vertically align **all text** to the top of the [`.draw()`](scribble-methods?id=drawx-y) coordinate.

&nbsp;

## `[fa_middle]`

**Command tag.**

Vertically align **all text** to the middle of the [`.draw()`](scribble-methods?id=drawx-y) coordinate.

&nbsp;

## `[fa_bottom]`

**Command tag.**

Vertically align **all text** to the bottom of the [`.draw()`](scribble-methods?id=drawx-y) coordinate.

&nbsp;

## `[pin_left]`

**Command tag.**

Horizontally align this line of text to the left of the entire textbox.

&nbsp;

## `[pin_center]` `[pin_centre]`

**Command tag.**

Horizontally align this line of text centrally versus the entire textbox.

&nbsp;

## `[pin_right]`

**Command tag.**

Horizontally align this line of text to the right of the entire textbox.
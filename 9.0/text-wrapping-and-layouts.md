# Text Wrapping and Layouts

&nbsp;

## `.layout_free()`

**Text Element Method:** `.layout_free()`

**Returns**: The text element

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Resets any layout that has been set. A "free" layout will not constrain text positioning. Any `[/page]` tags will be respected, however, creating new pages of text that you can choose to display using the `.page()` method.

!> This method is a regenerator. If the value is changed then the text element will be regenerated, potentially leading to degraded performance.

&nbsp;

## `.layout_guide()`

**Text Element Method:** `.layout_guide(width)`

**Returns**: The text element

|Name   |Datatype|Purpose                                                                                                                         |
|-------|--------|--------------------------------------------------------------------------------------------------------------------------------|
|`width`|integer |Width to use for pin-type alignments. Use a negative number (the default) to use the width of the text instead of a fixed number|

A "guide" layout will not perform any text wrapping, but if text is determined to use predominantly a right-to-left orientation then the width set by this method will be used as the initial right-hand position of the text.

!> This method is a regenerator. If the value is changed then the text element will be regenerated, potentially leading to degraded performance.

&nbsp;

## `.layout_wrap()`

**Text Element Method:** `.layout_wrap(maxWidth, [characterWrap])`

**Returns**: The text element

|Name             |Datatype|Purpose                                                                                                                                         |
|-----------------|--------|------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`       |number  |Maximum width for the whole textbox. Use a negative number (the default) for no limit                                                           |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for tight textboxes and some East Asian languages|

Instructs Scribble to fit text inside a box by automatically inserting line breaks where necessary. Scribble's text wrapping operates in a very similar way to GameMaker's native [`draw_text_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/draw_text_ext.htm). If text exceeds the horizontal maximum width then text will be pushed onto the next line. Very long sequences of glyphs without spaces will be split across multiple lines.

!> This method is a regenerator. If the value is changed then the text element will be regenerated, potentially leading to degraded performance.

&nbsp;

## `.layout_wrap_split_pages()`

**Text Element Method:** `.layout_wrap_split_pages(maxWidth, [maxHeight], [characterWrap])`

**Returns**: The text element

|Name             |Datatype|Purpose                                                                                                                                         |
|-----------------|--------|------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`       |number  |Maximum width for the whole textbox. Use a negative number (the default) for no limit                                                           |
|`maxHeight`      |number  |Maximum height for the whole textbox. Use a negative number (the default) for no limit                                                          |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for tight textboxes and some East Asian languages|

Instructs Scribble to fit text inside a box by automatically inserting line breaks and page breaks where necessary. Scribble's text wrapping operates in a very similar way to GameMaker's native [`draw_text_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/draw_text_ext.htm). If text exceeds the horizontal maximum width then text will be pushed onto the next line. If text exceeds the maximum height of the textbox then a new page will be created (see [`.page()`](scribble-methods?id=pagepage) and [`.get_page()`](scribble-methods?id=get_page)). Very long sequences of glyphs without spaces will be split across multiple lines.

!> This method is a regenerator. If the value is changed then the text element will be regenerated, potentially leading to degraded performance.

&nbsp;

## `.layout_scale()`

**Text Element Method:** `.layout_scale(maxWidth, maxHeight, [maxScale])`

**Returns**: The text element

|Name        |Datatype|Purpose                                                                                                               |
|------------|--------|----------------------------------------------------------------------------------------------------------------------|
|`maxWidth`  |number  |Maximum width of the bounding box to fit the text into. Use a negative number (the default) for no limit              |
|`maxHeight` |number  |Maximum height of the bounding box to fit the text into. Use a negative number (the default) for no limit             |
|`[maxScale]`|number  |Maximum scale that can be used which allows the algorithm to make text bigger. Defaults to `1`, no upscaling permitted|

Scales the text element such that it always fits inside the maximum width and height specified. Scaling is equal in both the x and y axes. This behaviour does not recalculate text wrapping so will not re-flow text. `.layout_scale()` is a simple scaling operation therefore, and one that is best used for single lines of text (e.g. for buttons).

!> This method is a regenerator. If the value is changed then the text element will be regenerated, potentially leading to degraded performance.

&nbsp;

## `.layout_fit()`

**Text Element Method:** `.layout_fit(maxWidth, maxHeight, [characterWrap], [maxScale])`

**Returns**: The text element

|Name        |Datatype|Purpose                                                                                                                                                   |
|------------|--------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`  |number  |Maximum width of the bounding box to fit the text into. Use a negative number (the default) for no limit                                                  |
|`maxHeight` |number  |Maximum height of the bounding box to fit the text into. Use a negative number (the default) for no limit                                                 |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for very tight textboxes and some East Asian languages|
|`[maxScale]`|number  |Maximum scale that can be used which allows the algorithm to make text bigger. Defaults to `1`, no upscaling permitted                                    |

Fits text to a box by inserting line breaks and scaling text but **will not** insert any page breaks. Text will take up as much space as possible without starting a new page. The macro `SCRIBBLE_FIT_TO_BOX_ITERATIONS` controls how many iterations to perform (higher is slower but more accurate).

!> This method is a regenerator. If the value is changed then the text element will be regenerated, potentially leading to degraded performance.

&nbsp;

## `.layout_scroll()`

**Text Element Method:** `.layout_scroll(maxWidth, maxHeight, [characterWrap])`

**Returns**: The text element

|Name             |Datatype|Purpose                                                                                                                                         |
|-----------------|--------|------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`       |number  |Maximum width for the whole textbox. Use a negative number (the default) for no limit                                                           |
|`maxHeight`      |number  |Maximum height for the whole textbox. Use a negative number (the default) for no limit                                                          |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for tight textboxes and some East Asian languages|

Instructs Scribble to fit text inside a box by automatically inserting line breaks where necessary. Scribble's text wrapping operates in a very similar way to GameMaker's native [`draw_text_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/draw_text_ext.htm). If text exceeds the horizontal maximum width then text will be pushed onto the next line. Very long sequences of glyphs without spaces will be split across multiple lines.

Unlike other layout methods, `.layout_scroll()` will not create a new page if the `[/page]` command tag is used. Instead, Scribble will append new pages underneath previous pages. Any text that overflows the maximum height of the textbox will be visually clipped. You can then scroll between pages using the relevant functions.

!> This method is a regenerator. If the value is changed then the text element will be regenerated, potentially leading to degraded performance.

&nbsp;

## `.layout_scroll_split_pages()`

**Text Element Method:** `.layout_scroll_split_pages(maxWidth, maxHeight, [characterWrap])`

**Returns**: The text element

|Name             |Datatype|Purpose                                                                                                                                         |
|-----------------|--------|------------------------------------------------------------------------------------------------------------------------------------------------|
|`maxWidth`       |number  |Maximum width for the whole textbox. Use a negative number (the default) for no limit                                                           |
|`maxHeight`      |number  |Maximum height for the whole textbox. Use a negative number (the default) for no limit                                                          |
|`[characterWrap]`|boolean |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for tight textboxes and some East Asian languages|

Instructs Scribble to fit text inside a box by automatically inserting line breaks and page breaks where necessary. Scribble's text wrapping operates in a very similar way to GameMaker's native [`draw_text_ext()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Drawing/Text/draw_text_ext.htm). If text exceeds the horizontal maximum width then text will be pushed onto the next line. Very long sequences of glyphs without spaces will be split across multiple lines.

Unlike other layout methods, `.layout_scroll_split_pages()` will not create a new page if the `[/page]` command tag is used. Instead, Scribble will append new pages underneath previous pages. Any text that overflows the maximum height of the textbox will be visually clipped and marked as a new page as though you'd added a `[/page]` tag manually yourself. You can then scroll between pages using the relevant functions.

!> This method is a regenerator. If the value is changed then the text element will be regenerated, potentially leading to degraded performance.
# Bold & Italic

&nbsp;

## `scribble_font_set_style_family()`

**Global Function:** `scribble_font_set_style_family(regular, bold, italic, boldItalic)`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                                      |
|------------|--------|---------------------------------------------|
|`regular`   |string  |Name of font to use for the regular style    |
|`bold`      |string  |Name of font to use for the bold style       |
|`italic`    |string  |Name of font to use for the italic style     |
|`boldItalic`|string  |Name of font to use for the bold-italic style|

Associates four fonts together for use with `[b]` `[i]` `[bi]` `[r]` font tags. Use `undefined` for any style you don't want to set a font for.

&nbsp;

## `[r]`

**Command tag.** 

Sets the regular font for the font family, as defined by `scribble_font_set_style_family()`.

&nbsp;

## `[b]`

**Command tag.**

Sets the bold font for the font family, as defined by `scribble_font_set_style_family()`.

&nbsp;

## `[i]`

**Command tag.**

Sets the italic font for the font family, as defined by `scribble_font_set_style_family()`.

&nbsp;

## `[bi]`

**Command tag.**

Sets the bold-italic font for the font family, as defined by `scribble_font_set_style_family()`.
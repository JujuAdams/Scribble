# Other Getters

&nbsp;

## `.get_wrapped()`

**Text Element Method:** `.get_wrapped()`

**Returns:** Boolean, whether the text has wrapped onto a new line using the [`.wrap()` feature](scribble-methods?id=wrapmaxwidth-maxheight-characterwrap-regenerator)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Will return `true` only if the [`.wrap()` feature](scribble-methods?id=wrapmaxwidth-maxheight-characterwrap-regenerator) is used. Manual newlines (`\n`) included in the input string will **not** cause this function to return `true`.

&nbsp;

## `.get_text()`

**Text Element Method:** `.get_text([page])`

**Returns:** String, the parsed string for the given page

|Name    |Datatype|Purpose                                                                  |
|--------|--------|-------------------------------------------------------------------------|
|`[page]`|integer |Page to get the raw text from. If not specified, the current page is used|

The string that is returned is the raw text that is drawn i.e. all command tags and events have been stripped out. Sprites and surfaces are represented by a single glyph with the Unicode value of `26` ([`0x001A` "substitute character"](https://unicode-table.com/en/001A/)).

&nbsp;

## `.get_glyph_data()`

**Text Element Method:** `.get_glyph_data(glyphIndex, [page])`

**Returns:** Struct, containing layout details for the glyph on the given page (see below)

|Name        |Datatype|Purpose                                                                    |
|------------|--------|---------------------------------------------------------------------------|
|`glyphIndex`|integer |Index of the glyph whose data will be returned                             |
|`[page]`    |integer |Page to get the glyph data from. If not specified, the current page is used|

The struct that is returned has the following member variables:

|Name      |Datatype|Purpose                                                       |
|----------|--------|--------------------------------------------------------------|
|`unicode` |integer |The Unicode character code for the glyph. Sprites and surfaces are represented by a single glyph with the Unicode value of `26` ([`0x001A` "substitute character"](https://unicode-table.com/en/001A/))                     |
|`left`    |number  |Left x-position of the glyph, relative to the model's origin  |
|`top`     |number  |Top y-position of the glyph, relative to the model's origin   |
|`right`   |number  |Right x-position of the glyph, relative to the model's origin |
|`bottom`  |number  |Bottom y-position of the glyph, relative to the model's origin|

&nbsp;

## `.get_glyph_count()`

**Text Element Method:** `.get_glyph_count([page])`

**Returns:** Integer, the number of glyphs on the given page

|Name        |Datatype|Purpose                                                                     |
|------------|--------|----------------------------------------------------------------------------|
|`[page]`    |integer |Page to get the glyph count from. If not specified, the current page is used|

&nbsp;

## `.get_line_count()`

**Text Element Method:** `.get_line_count([page])`

**Returns:** Integer, how many lines of text are on the given page

|Name    |Datatype|Purpose                                                                                  |
|--------|--------|-----------------------------------------------------------------------------------------|
|`[page]`|Integer |Page to retrieve the number of lines for. Defaults to the current page that's being shown|
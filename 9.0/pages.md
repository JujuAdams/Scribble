# Pages

&nbsp;

##  `[/page]`

**Command tag.** Inserts a manual page break.

&nbsp;

## `.page(page)`

**Returns**: The text element

|Name  |Datatype|Purpose                                          |
|------|--------|-------------------------------------------------|
|`page`|integer |Page to display, starting at 0 for the first page|

Changes which page Scribble is display for the text element. Pages are created when using the [`.wrap()` method](scribble-methods?id=wrapmaxwidth-maxheight-characterwrap-regenerator) or when inserting [`[/page] command tags`](text-formatting) into your input string. Pages are 0-indexed.

Please note that changing the page will reset any typewriter animations started by a [typist](typist-methods) associated with the text element.

&nbsp;

## `.get_page()`

**Returns:** Integer, page that the text element is currently on, starting at `0` for the first page

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Returns which page Scribble is showing, as set by [`.page()`](scribble-methods?id=pagepage). Pages are 0-indexed; this function will return `0` for the first page.

&nbsp;

## `.get_page_count()`

**Returns:** Integer, total number of pages for the text element

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Returns the total number of pages that this text element contains. In rare cases, this function can return 0.

&nbsp;

## `.on_last_page()`

**Returns:** Boolean, whether the current page is the last page for the text element

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Convenience function.

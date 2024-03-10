# Right-to-Left

&nbsp;

## `.right_to_left()`

**Global Function:** `.right_to_left(state)`

**Returns**: The text element

|Name    |Datatype|Purpose                                            |
|--------|--------|---------------------------------------------------|
|`state` |boolean |Whether the overall text direction is right-to-left|

Hints to the text parser whether the overall text direction is right-to-left (`true`) or left-to-right (`false`). This method also accepts an input of `undefined` to use the default behaviour whereby Scribble attempts to figure out the overall text direction based on the first glyph in the string.

&nbsp;

## `[l2r]`

**Command tag.**

Provides a hint at the direction of text. Useful at the start of strings or adjacent to punctuation to fix minor issues in text layout.

&nbsp;

## `[r2l]`

**Command tag.**

Provides a hint at the direction of text. Useful at the start of strings or adjacent to punctuation to fix minor issues in text layout.
# `scribble_typist()`

&nbsp;

## `scribble_typist()`

**Global Function:** `scribble_typist([perLine])`

**Returns:** Struct, an instance of `__scribble_class_typist`

|Name       |Datatype|Purpose                                                                            |
|-----------|--------|-----------------------------------------------------------------------------------|
|`[perLine]`|boolean |Whether to reveal text per line. Defaults to `false`, revealling text per character|

Typewriter behaviour is controlled using a "typist". A typist is a unique (non-cached) machine that controls how your text is revealed and how events are executed as text is revealed. For example, you should create one typist per textbox. Typists are created by calling `scribble_typist()` and are garbage collected automatically. Typists can be used with a text element by targetting the typist with the text element's `.draw()` method. For example:

```GML
///Create
typist = scribble_typist();
typist.in(1, 0);

///Draw
scribble("Here's some typewriter text!").draw(x, y, typist);
```

Note that we called the `.in()` method. This is analogous to the old `.typewriter_in()` method that was available on text elements in previous versions. Below is a list of methods for typists, and they follow the same basic rules as the old typewriter functions.

!> A typist should only be used to control text reveal for **one text element at a time**. Changing text element, or changing the page for that text element, will cause the typist to automatically be reset.

&nbsp;

## `.get_text_element()`

**Typist Method:** `.get_text_element()`

**Returns**: The text element associated with the typist, or `undefined` if no text element is associated

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

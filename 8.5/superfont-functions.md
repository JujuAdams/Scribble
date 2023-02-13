# Superfont Functions

&nbsp;

## `scribble_super_create(name)`

**Returns:** N/A (`undefined`)

|Name  |Datatype|Purpose                   |
|------|--------|--------------------------|
|`name`|string  |Name of the font to create|

Creates a new superfont. The new font is totally blank and should not be used until some glyphs have been added to it using `scribble_super_glyph_copy()` or `scribble_super_glyph_copy_all()`.

!> Trying to use a blank superfont to draw text will cause the game to crash.

&nbsp;

## `scribble_super_glyph_copy(target, source, overwrite, glyphSet, ...)`

**Returns:** N/A (`undefined`)

|Name       |Datatype|Purpose                                                                                     |
|-----------|--------|--------------------------------------------------------------------------------------------|
|`target`   |string  |Name of the superfont to add glyphs to                                                      |
|`source`   |string  |Name of the font to add glyphs from                                                         |
|`overwrite`|boolean |Whether to overwrite existing glyphs in the target font with new glyphs from the source font|
|`glyphSet` |various |The glyph, or glyphs, to add. See below                                                     |
|`...`      |various |Additional glyph, or glyphs, to add                                                         |

Copies a set of glyphs from the source font into the target superfont. The target font must be a superfont created by `scribble_super_create()`, though the source font can be either a superfont or not. If `overwrite` is set to `false`, any glyphs that already exist in the target font will be ignored. If `overwrite` is set to `true` existing glyphs will be overwritten.

?> It is not possible to combine glyphs from an MSDF font and a standard/sprite font. It is further not possible to combine glyphs from MSDF fonts that have a different `pxrange`. Standard fonts and sprite fonts can otherwise be combined however you like.

`glyphSet` can be one of three different types of input. You may specify as many glyph sets as you like

1. UTF-8 decimal character code<br>e.g. `scribble_super_glyph_copy("targetFont", "sourceFont", true, 32)`

2. String of characters<br>e.g. `scribble_super_glyph_copy("targetFont", "sourceFont", true, "abc")`

3. Two-element array that describes a range of UTF-8 decimal character codes<br>e.g. `scribble_super_glyph_copy("targetFont", "sourceFont", true, [97, 122])`

As mentioned above, this function can be given as many glyph sets as you like. The following are interchangeable therefore:

```GML
scribble_super_glyph_copy("targetFont", "sourceFont", true, 40, 41, 88, 89, 90);
scribble_super_glyph_copy("targetFont", "sourceFont", true, "()", "XYZ");
scribble_super_glyph_copy("targetFont", "sourceFont", true, [40, 41], [88, 90]);
```

&nbsp;

## `scribble_super_glyph_copy_all(target, source, overwrite)`

**Returns:** N/A (`undefined`)

|Name       |Datatype|Purpose                                                                                     |
|-----------|--------|--------------------------------------------------------------------------------------------|
|`target`   |string  |Name of the superfont to add glyphs to                                                      |
|`source`   |string  |Name of the font to add glyphs from                                                         |
|`overwrite`|boolean |Whether to overwrite existing glyphs in the target font with new glyphs from the source font|

Copies **all** glyphs from the source font into the target superfont. The target font must be a superfont created by `scribble_super_create()`, though the source font can be either a superfont or not. If `overwrite` is set to `false`, any glyphs that already exist in the target font will be ignored. If `overwrite` is set to `true` existing glyphs will be overwritten.

?> It is not possible to combine glyphs from an MSDF font and a standard/sprite font. It is further not possible to combine glyphs from MSDF fonts that have a different `pxrange`. Standard fonts and sprite fonts can otherwise be combined however you like.

&nbsp;

## `scribble_super_glyph_delete(target, glyphSet, ...)`

**Returns:** N/A (`undefined`)

|Name       |Datatype|Purpose                                   |
|-----------|--------|------------------------------------------|
|`target`   |string  |Name of the font to delete glyphs from    |
|`glyphSet` |various |The glyph, or glyphs, to delete. See below|
|`...`      |various |Additional glyph, or glyphs, to delete    |

Deletes a set of glyphs from the specified font. The font must be a superfont. For the rules on how glyph sets should be defined, please consult `scribble_super_glyph_copy()` above.

&nbsp;

## `scribble_super_clear(target)`

**Returns:** N/A (`undefined`)

|Name    |Datatype|Purpose                  |
|--------|--------|-------------------------|
|`target`|string  |Name of the font to clear|

Removes all glyphs from a superfont. Once cleared, the font is totally blank and should not be used until some glyphs have been added to it using `scribble_super_glyph_copy()` or `scribble_super_glyph_copy_all()`.

!> Trying to use a blank superfont to draw text will cause the game to crash.

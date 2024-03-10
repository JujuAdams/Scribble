# Glyph Properties

&nbsp;

Fonts can often be tricky to render correctly, and this script allows you to change certain properties. Properties can be adjusted at any time, but existing and cached Scribble text elements will not be updated to match new properties.

&nbsp;

## `scribble_glyph_x_offset_set()`

**Global Function:** `scribble_glyph_x_offset_set(fontName, character, value, [relative=false])`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                     |
|------------|--------|----------------------------|
|`fontName`  |string  |The target font, as a string|
|`glyphRange`|string  |Range of glyphs to target   |
|`value`     |integer |The value to set (or add)   |
|`[relative]`|boolean |Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to `false`, overwriting the existing value|

&nbsp;

## `scribble_glyph_x_offset_get()`

**Global Function:** `scribble_glyph_x_offset_get(fontName, character)`

**Returns:** Number, value for the specified property

|Name       |Datatype|Purpose                      |
|-----------|--------|-----------------------------|
|`fontName` |string  |The target font, as a string |
|`character`|string  |Target character, as a string|

&nbsp;

## `scribble_glyph_y_offset_set()`

**Global Function:** `scribble_glyph_y_offset_set(fontName, character, value, [relative=false])`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                     |
|------------|--------|----------------------------|
|`fontName`  |string  |The target font, as a string|
|`glyphRange`|string  |Range of glyphs to target   |
|`value`     |integer |The value to set (or add)   |
|`[relative]`|boolean |Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to `false`, overwriting the existing value|

&nbsp;

## `scribble_glyph_y_offset_get()`

**Global Function:** `scribble_glyph_y_offset_get(fontName, character)`

**Returns:** Number, value for the specified property

|Name       |Datatype|Purpose                      |
|-----------|--------|-----------------------------|
|`fontName` |string  |The target font, as a string |
|`character`|string  |Target character, as a string|

&nbsp;

## `scribble_glyph_separation_set()`

**Global Function:** `scribble_glyph_separation_set(fontName, character, value, [relative=false])`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                     |
|------------|--------|----------------------------|
|`fontName`  |string  |The target font, as a string|
|`glyphRange`|string  |Range of glyphs to target   |
|`value`     |integer |The value to set (or add)   |
|`[relative]`|boolean |Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to `false`, overwriting the existing value|

&nbsp;

## `scribble_glyph_separation_get()`

**Global Function:** `scribble_glyph_separation_get(fontName, character)`

**Returns:** Number, value for the specified property

|Name       |Datatype|Purpose                      |
|-----------|--------|-----------------------------|
|`fontName` |string  |The target font, as a string |
|`character`|string  |Target character, as a string|

&nbsp;

## `scribble_glyph_width_set()`

**Global Function:** `scribble_glyph_width_set(fontName, character, value, [relative=false])`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                     |
|------------|--------|----------------------------|
|`fontName`  |string  |The target font, as a string|
|`glyphRange`|string  |Range of glyphs to target   |
|`value`     |integer |The value to set (or add)   |
|`[relative]`|boolean |Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to `false`, overwriting the existing value|

&nbsp;

## `scribble_glyph_width_get()`

**Global Function:** `scribble_glyph_width_get(fontName, character)`

**Returns:** Number, value for the specified property

|Name       |Datatype|Purpose                      |
|-----------|--------|-----------------------------|
|`fontName` |string  |The target font, as a string |
|`character`|string  |Target character, as a string|

&nbsp;

## `scribble_glyph_height_set()`

**Global Function:** `scribble_glyph_height_set(fontName, character, value, [relative=false])`

**Returns:** N/A (`undefined`)

|Name        |Datatype|Purpose                     |
|------------|--------|----------------------------|
|`fontName`  |string  |The target font, as a string|
|`glyphRange`|string  |Range of glyphs to target   |
|`value`     |integer |The value to set (or add)   |
|`[relative]`|boolean |Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to `false`, overwriting the existing value|

&nbsp;

## `scribble_glyph_height_get()`

**Global Function:** `scribble_glyph_height_get(fontName, character)`

**Returns:** Number, value for the specified property

|Name       |Datatype|Purpose                      |
|-----------|--------|-----------------------------|
|`fontName` |string  |The target font, as a string |
|`character`|string  |Target character, as a string|
# Kerning

&nbsp;

## `scribble_kerning_pair_set()`

**Global Function:** `scribble_kerning_pair_set(fontName, firstChar, secondChar, value, [relative])`

**Returns:** Number, the new kerning offset

|Name        |Datatype|Purpose                                                                                                                                    |
|------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------|
|`fontName`  |string  |The target font, as a string                                                                                                               |
|`firstChar` |string  |First character in the pair                                                                                                                |
|`secondChar`|string  |Second character in the pair                                                                                                               |
|`value`     |number  |The value to set (or add)                                                                                                                  |
|`[relative]`|boolean |Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to `false`, overwriting the existing value|

&nbsp;

## `scribble_kerning_pair_get()`

**Global Function:** `scribble_kerning_pair_get(fontName, firstChar, secondChar)`

**Returns:** Number, the kerning offset for the given pair of characters

|Name        |Datatype|Purpose                     |
|------------|--------|----------------------------|
|`fontName`  |string  |The target font, as a string|
|`firstChar` |string  |First character in the pair |
|`secondChar`|string  |Second character in the pair|

If there is no kerning offset defined for the given pair of characters (either set automatically by the font or manually via `scribble_kerning_pair_set()`), a value of `0` is returned.
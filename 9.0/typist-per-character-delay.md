# Per-character Delay

&nbsp;

## `.character_delay_add(character, delay)`

**Returns:** `self`, the typist

|Name       |Datatype|Purpose                                                                                                         |
|-----------|--------|----------------------------------------------------------------------------------------------------------------|
|`character`|string  |A single character or a pair of characters, the substring to search for to apply a delay during typist animation|
|`delay`    |number  |The length of time to delay for, in milliseconds                                                                |

&nbsp;

## `.character_delay_remove(character)`

**Returns:** `self`, the typist

|Name       |Datatype|Purpose                                                                                                |
|-----------|--------|-------------------------------------------------------------------------------------------------------|
|`character`|string  |A single character or a pair of characters, the substring whose delay should be removed from the typist|

&nbsp;

## `.character_delay_clear()`

**Returns:** `self`, the typist

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Clears all per-character delays that have been set for this typist.
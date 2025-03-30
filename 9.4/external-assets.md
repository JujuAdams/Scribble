# External Assets

&nbsp;

## `scribble_external_sound_add(soundID, alias)`

**Returns:** N/A (`undefined`)

|Name     |Datatype                                                          |Purpose                                                       |
|---------|------------------------------------------------------------------|--------------------------------------------------------------|
|`soundID`|[sound](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm)|The sound to target                                           |
|`alias`  |string                                                            |A string to use to refer to the sound ID in Scribble functions|

Adds a sound that can be referenced in Scribble functions using the given alias. This is intended for use with externally added sounds via `audio_create_stream()` or `audio_create_buffer_sound()`.

&nbsp;

## `scribble_external_sound_remove(alias)`

**Returns:** N/A (`undefined`)

|Name     |Datatype|Purpose                                         |
|---------|--------|------------------------------------------------|
|`alias`  |string  |The external sound alias to remove from Scribble|

&nbsp;

## `scribble_external_sound_exists(alias)`

**Returns:** Boolean, whether the alias has been added by `scribble_external_sound_add()`

|Name     |Datatype|Purpose                              |
|---------|--------|-------------------------------------|
|`alias`  |string  |The external sound alias to check for|
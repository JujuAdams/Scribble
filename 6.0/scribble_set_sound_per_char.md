`scribble_autotype_set_sound_per_char(element, soundArray, pitchMin, pitchMax, [occuranceName])`

**Returns:** N/A (`0`)

|Argument|Name        |Purpose                                                               |
|--------|------------|----------------------------------------------------------------------|
|0       |`element`   |Text element to target. This element must have been created previously by [`scribble_draw()`](scribble_draw) or [`scribble_cache()`](scribble_cache)|
|1       |`soundArray`|Array of sound assets that can be used for playback|
|2       |`pitchMin`  |Minimum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `0.5` halves the pitch etc.|
|3       |`pitchMax`  |Maximum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `2.0` doubles the pitch etc.|
|[4]     |`[occuranceName]`|ID to reference a specific unique occurance of a text element. This can be a string or a number. Defaults to [`SCRIBBLE_DEFAULT_OCCURANCE_NAME`](__scribble_macros)             |

It's quite common in games with typewriter-style text animations to have a sound effect that plays as text shows up. This function allows you to define an array of sound effects that will be randomly played as **each character** is revealed. The pitch of these sounds can be randomly modulated as well by selecting `pitchMin` and `pitchMax` values.
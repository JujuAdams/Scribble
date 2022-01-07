`scribble_autotype_set_sound(element, soundArray, overlap, pitchMin, pitchMax, [occuranceName])`

**Returns:** N/A (`0`)

|Argument|Name        |Purpose                                                               |
|--------|------------|----------------------------------------------------------------------|
|0       |`element`   |Text element to target. This element must have been created previously by [`scribble_draw()`](scribble_draw) or [`scribble_cache()`](scribble_cache)|
|1       |`soundArray`|Array of sound assets that can be used for playback|
|2       |`overlap`   |Amount of overlap between sound effect playback, in milliseconds|
|3       |`pitchMin`  |Minimum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `0.5` halves the pitch etc.|
|3       |`pitchMax`  |Maximum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `2.0` doubles the pitch etc.|
|[4]     |`[occuranceName]`|ID to reference a specific unique occurance of a text element. This can be a string or a number. Defaults to [`SCRIBBLE_DEFAULT_OCCURANCE_NAME`](__scribble_macros)             |

It's quite common in games with typewriter-style text animations to have a "mumble" or "gibberish" sound effect that plays whilst text is being revealed. This function allows you to define an array of sound effects that will be randomly played as text is revealed. The pitch of these sounds can be randomly modulated as well by selecting `pitchMin` and `pitchMax` values.

Setting the `overlap` value to 0 will ensure that sound effects never overlap at all, which is generally what's desirable, but it can sound a bit stilted and unnatural. By setting the `overlap` argument to a number above 0, sound effects will be played with a little bit of overlap which improves the effect considerably. A value around 30ms usually sounds ok. The `overlap` argument can be set to a value less than 0 if you'd like more space between sound effects.
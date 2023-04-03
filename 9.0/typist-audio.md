# Audio

&nbsp;

## `[<name of sound>]`

**Command tag.**

Insert sound playback event. Sounds will only be played when using Scribble's typist feature.

&nbsp;

## `.sound()`

**Typist Method:** `.sound(soundArray, overlap, pitchMin, pitchMax. [gain=1])`

**Returns**: `self`, the typist

|Name        |Datatype                                                                    |Purpose                                                                                                             |
|------------|----------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
|`soundArray`|array of [sounds](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm)|Array of audio assets that can be used for playback                                                                 |
|`overlap`   |number                                                                      |Amount of overlap between sound effect playback, in milliseconds                                                    |
|`pitchMin`  |number                                                                      |Minimum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `0.5` halves the pitch etc. |
|`pitchMax`  |number                                                                      |Maximum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `2.0` doubles the pitch etc.|
|`gain`      |number                                                                      |Gain to play the sound at, from `0.0` (silence) to `1.0` (full volume). Defaults to `1`                             |

It's quite common in games with typewriter-style text animations to have a "mumble" or "gibberish" sound effect that plays whilst text is being revealed. This function allows you to define an array of sound effects that will be randomly played as text is revealed. The pitch of these sounds can be randomly modulated as well by selecting `pitchMin` and `pitchMax` values.

Setting the `overlap` value to `0` will ensure that sound effects never overlap at all, which is generally what's desirable, but it can sound a bit stilted and unnatural. By setting the `overlap` argument to a number above `0`, sound effects will be played with a little bit of overlap which improves the effect considerably. A value around 30ms usually sounds ok. The `overlap` argument can be set to a value less than 0 if you'd like more space between sound effects.

&nbsp;

## `.sound_per_char()`

**Typist Method:** `.sound_per_char(soundArray, pitchMin, pitchMax, [exceptionString], [gain=1])`

**Returns**: `self`, the typist

|Name               |Datatype                                                                    |Purpose                                                                                                                                  |
|-------------------|----------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
|`soundArray`       |array of [sounds](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm)|Array of audio assets that can be used for playback                                                                                      |
|`pitchMin`         |number                                                                      |Minimum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `0.5` halves the pitch etc.                      |
|`pitchMax`         |number                                                                      |Maximum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `2.0` doubles the pitch etc.                     |
|`[exceptionString]`|number                                                                      |String of characters for whom a sound should **not** be played. If no string is specified, all characters will play a sound when revealed|
|`[gain]`           |number                                                                      |Gain to play the sound at, from `0.0` (silence) to `1.0` (full volume). Defaults to `1`                                                  |

It's quite common in games with typewriter-style text animations to have a sound effect that plays as text shows up. This function allows you to define an array of sound effects that will be randomly played as **each character** is revealed. The pitch of these sounds can be randomly modulated as well by selecting `pitchMin` and `pitchMax` values.

&nbsp;

## `[typistSound,...]`

**Command tag.**

Sets the sound of the typewriter by replicating the behaviour of the `.sound()` typist method (see above).

&nbsp;

## `[typistSoundPerChar,...]`

**Command tag.**

Sets the sound of the typewriter by replicating the behaviour of the `.sound_per_char()` typist method (see above).

&nbsp;

## `.sync_to_sound(soundInstance)`

**Typist Method:** `.sync_to_sound(soundInstance)`

**Returns:** `self`, the typist

|Name           |Datatype                                                                                                                   |Purpose                                               |
|---------------|---------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------|
|`soundInstance`|[sound instance](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Audio/audio_play_sound.htm)|Sound instance to use as the basis for synchronisation|

Sets up a typist to synchronise to an audio source whilst typing in. Calling `.sync_to_sound()` will enable the use of `[sync,<seconds>]` tags. These tags act in a similar way to `[delay]` tags insofar that they wait for a particular amount of time to elapse before the typist resumes. Insert `[sync,<seconds>]` tags where you'd like the typist to wait during sound playback, and set the `<seconds>` argument in the tag to the position in the audio file that you'd like to resume playback. The `<seconds>` argument should be specified in seconds.

!> Do not use `.sync_to_sound()` with looping audio. Sound synchronisation is only supported when typing in.

If the provided sound instance is paused, the typist will be paused as well and will wait until playback is resumed to contineu typing (this is a different pause state to the `.pause()` function above). If the sound instance stops, either because it has reached the end of playback or the sound instance was stopped manually, the typist will fall back to standard behaviour. Any remaining text that has not been typed will be typed out without pausing.

?> When synchronising to audio, `[delay]` and `[pause]` tags will be ignored. To pace the display of text, use `[sync]` tags as described above.

&nbsp;

## `[sync,<seconds>]`

**Command tag.**

Synchronisation point for `.sync_to_sound()`, see above.

&nbsp;

## `scribble_external_sound_add()`

**Global Function:** `scribble_external_sound_add(soundID, alias)`

**Returns:** N/A (`undefined`)

|Name     |Datatype                                                          |Purpose                                                       |
|---------|------------------------------------------------------------------|--------------------------------------------------------------|
|`soundID`|[sound](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm)|The sound to target                                           |
|`alias`  |string                                                            |A string to use to refer to the sound ID in Scribble functions|

Adds a sound that can be referenced in Scribble functions using the given alias. This is intended for use with externally added sounds via `audio_create_stream()` or `audio_create_buffer_sound()`.

&nbsp;

## `scribble_external_sound_remove()`

**Global Function:** `scribble_external_sound_remove(alias)`

**Returns:** N/A (`undefined`)

|Name     |Datatype|Purpose                                         |
|---------|--------|------------------------------------------------|
|`alias`  |string  |The external sound alias to remove from Scribble|

&nbsp;

## `scribble_external_sound_exists()`

**Global Function:** `scribble_external_sound_exists(alias)`

**Returns:** Boolean, whether the alias has been added by `scribble_external_sound_add()`

|Name     |Datatype|Purpose                              |
|---------|--------|-------------------------------------|
|`alias`  |string  |The external sound alias to check for|
# Legacy Typewriter Functions

!> These are legacy methods for text elements created by `scribble()`. Please avoid using these functions and use [`scribble_typist()`](typist-methods) instead as the functions on this page will be removed in a future release.

## `.typewriter_off()`

**Returns**: The text element

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Turns off the typewriter effect and displays all text. [Typewriter events](misc-functions?id=scribble_typist_add_eventname-function) will **not** be executed.

&nbsp;

## `.typewriter_reset()`

**Returns**: The text element

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Resets the position of the typewriter animation for the current page.

&nbsp;

## `.typewriter_in(speed, smoothness)`

**Returns**: The text element

|Name        |Datatype|Purpose                                                                                                                        |
|------------|--------|-------------------------------------------------------------------------------------------------------------------------------|
|`speed`     |real    |Amount of text to reveal per tick (1 tick is usually 1 frame). This is character or lines depending on the method defined above|
|`smoothness`|real    |How much text is visible during the fade. Higher numbers will allow more text to be visible as it fades in                     |

The `smoothness` argument offers some customisation for how text fades in. A high value will cause text to be smoothly faded in whereas a smoothness of `0` will cause text to instantly pop onto the screen. For advanced users, custom shader code can be easily combined with the `smoothness` value to animate text in unique ways as it fades in.

[Events](misc-functions?id=scribble_typist_add_eventname-function) (in-line functions) will be executed as text fades in. This is a powerful tool and can be used to achieve many things, including triggering sound effects, changing character portraits, starting movement of instances, starting weather effects, giving the player items, and so on.

&nbsp;

## `.typewriter_out(speed, smoothness, [backwards])`

**Returns**: The text element

|Name         |Datatype|Purpose                                                                                                                        |
|-------------|--------|-------------------------------------------------------------------------------------------------------------------------------|
|`speed`      |real    |Amount of text to reveal per tick (1 tick is usually 1 frame). This is character or lines depending on the method defined above|
|`smoothness` |real    |How much text is visible during the fade. Higher numbers will allow more text to be visible as it fades out                    |
|`[backwards]`|boolean |Whether to animate the typewriter backwards. Defaults to `false`                                                               |

The `smoothness` argument offers some customisation for how text fades out. A high value will cause text to be smoothly faded out whereas a smoothness of `0` will cause text to instantly pop onto the screen. For advanced users, custom shader code can be easily combined with the `smoothness` value to animate text in unique ways as it fades out.

[Events](misc-functions?id=scribble_typist_add_eventname-function) will **not** be executed as text fades out.

&nbsp;

## `.typewriter_skip()`

**Returns**: The text element

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

## `.get_typewriter_pos()`

**Returns**: Real, the position of the typewriter "head", corresponding to the most recent revealed glyph

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This method will return a decimal value if the speed is a decimal value too.

&nbsp;

## `.typewriter_ease(easeMethod, dx, dy, xscale, yscale, rotation, alphaDuration)`

**Returns**: The text element

|Name           |Datatype|Purpose                                                           |
|---------------|--------|------------------------------------------------------------------|
|`easeMethod`   |integer |A member of the `SCRIBBLE_EASE` enum. See below                   |
|`dx`           |real    |Starting x-coordinate of the glyph, relative to its final position|
|`dy`           |real    |Starting y-coordinate of the glyph, relative to its final position|
|`xscale`       |real    |Starting x-scale of the glyph, relative to its final scale        |
|`yscale`       |real    |Starting y-scale of the glyph, relative to its final scale        |
|`rotation`     |real    |Starting rotation of the glyph, relative to its final rotation    |
|`alphaDuration`|real    |Value from `0` to `1` (inclusive). See below                      |

The `alphaDuration` argument controls how glyphs fade in using alpha blending. A value of `0` will cause the glyph to "pop" into view with no fading, a value of `1` will cause the glyph to fade into view smoothly such that it reaches 100% alpha at the very end of the typewriter animation for the glyph.

**N.B.** Alpha fading is always linear and is not affected by the easing method chosen.

Scribble offers the following easing functions for typewriter behaviour. These are implemented using methods found in the widely used [easings.net](https://easings.net/) library.

|`SCRIBBLE_EASE` members|
|-----------------------|
|`.NONE`                |
|`.LINEAR`              |
|`.QUAD`                |
|`.CUBIC`               |
|`.QUART`               |
|`.QUINT`               |
|`.SINE`                |
|`.EXPO`                |
|`.CIRC`                |
|`.BACK`                |
|`.ELASTIC`             |
|`.BOUNCE`              |

&nbsp;

## `.get_typewriter_state()`

**Returns:** Real value from 0 to 2 (inclusive) that represents what proportion of text on the current page is visible

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

The value returned by this function is as follows:

|Value         |Visibility                                                                                                      |
|--------------|----------------------------------------------------------------------------------------------------------------|
|`= 0`         |No text is visible                                                                                              |
|`> 0`<br>`< 1`|Text is fading in. This value is the proportion of text that is visible<br>e.g. `0.4` is 40% visibility         |
|`= 1`         |Text is fully visible and the fade in animation has finished                                                    |
|`> 1`<br>`< 2`|Text is fading out. 2 minus this value is the proportion of text that is visible<br>e.g. `1.6` is 40% visibility|
|`= 2`         |No text is visible and the fade out animation has finished                                                      |

If no typewriter animation has been started, this function will return `1`.

&nbsp;

## `.typewriter_pause()`

**Returns**: The text element

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Pauses the typewriter effect.

&nbsp;

## `.typewriter_unpause()`

**Returns**: The text element

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Unpauses the typewriter effect. This is helpful when combined with the [`[pause]` command tag](text-formatting) and [`.get_typewriter_paused()`](scribble-methods?id=get_typewriter_paused).

&nbsp;

## `.get_typewriter_paused()`

**Returns:** Boolean, whether the text element is currently paused due to encountering `[pause]` tag when typing out text

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

## `.typewriter_sound(soundArray, overlap, pitchMin, pitchMax)`

**Returns**: The text element

|Name        |Datatype                                                                                      |Purpose                                                                                                             |
|------------|----------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
|`soundArray`|array of [sounds](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm)|Array of audio assets that can be used for playback                                                                 |
|`overlap`   |real                                                                                          |Amount of overlap between sound effect playback, in milliseconds                                                    |
|`pitchMin`  |real                                                                                          |Minimum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `0.5` halves the pitch etc. |
|`pitchMax`  |real                                                                                          |Maximum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `2.0` doubles the pitch etc.|

It's quite common in games with typewriter-style text animations to have a "mumble" or "gibberish" sound effect that plays whilst text is being revealed. This function allows you to define an array of sound effects that will be randomly played as text is revealed. The pitch of these sounds can be randomly modulated as well by selecting `pitchMin` and `pitchMax` values.

Setting the `overlap` value to `0` will ensure that sound effects never overlap at all, which is generally what's desirable, but it can sound a bit stilted and unnatural. By setting the `overlap` argument to a number above `0`, sound effects will be played with a little bit of overlap which improves the effect considerably. A value around 30ms usually sounds ok. The `overlap` argument can be set to a value less than 0 if you'd like more space between sound effects.

&nbsp;

## `.typewriter_sound_per_char(soundArray, pitchMin, pitchMax)`

**Returns**: The text element

|Name        |Datatype                                                                                      |Purpose                                                                                                             |
|------------|----------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
|`soundArray`|array of [sounds](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm)|Array of audio assets that can be used for playback                                                                 |
|`pitchMin`  |real                                                                                          |Minimum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `0.5` halves the pitch etc. |
|`pitchMax`  |real                                                                                          |Maximum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `2.0` doubles the pitch etc.|

It's quite common in games with typewriter-style text animations to have a sound effect that plays as text shows up. This function allows you to define an array of sound effects that will be randomly played as **each character** is revealed. The pitch of these sounds can be randomly modulated as well by selecting `pitchMin` and `pitchMax` values.

&nbsp;

## `.typewriter_function(function)`

**Returns**: The text element

|Name      |Datatype|Purpose|
|----------|--------|-------|
|`function`|function|       |

`.typewriter_function()` allows you to define a function that will be executed once per character as that character is revealed. The function is given two arguments: the text element that triggered the callback, and the position of the character that was just revealed.
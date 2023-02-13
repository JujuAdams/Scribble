# `scribble_typist()` Methods

&nbsp;

## `scribble_typist()`

**Returns:** Struct, an instance of `__scribble_class_typist`

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

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

## `.in(speed, smoothness)`

**Returns**: `self`, the typist

|Name        |Datatype|Purpose                                                                                                                        |
|------------|--------|-------------------------------------------------------------------------------------------------------------------------------|
|`speed`     |real    |Amount of text to reveal per tick (1 tick is usually 1 frame). This is character or lines depending on the method defined above|
|`smoothness`|real    |How much text is visible during the fade. Higher numbers will allow more text to be visible as it fades in                     |

The `smoothness` argument offers some customisation for how text fades in. A high value will cause text to be smoothly faded in whereas a smoothness of `0` will cause text to instantly pop onto the screen. For advanced users, custom shader code can be easily combined with the `smoothness` value to animate text in unique ways as it fades in.

[Events](Functions-(Miscellaneous)#scribble_typists_add_eventname-function) (in-line scripts) will be executed as text fades in. This is a powerful tool and can be used to achieve many things, including triggering sound effects, changing character portraits, starting movement of instances, starting weather effects, giving the player items, and so on.

&nbsp;

## `.out(speed, smoothness, [backwards])`

**Returns**: `self`, the typist

|Name         |Datatype|Purpose                                                                                                                        |
|-------------|--------|-------------------------------------------------------------------------------------------------------------------------------|
|`speed`      |real    |Amount of text to reveal per tick (1 tick is usually 1 frame). This is character or lines depending on the method defined above|
|`smoothness` |real    |How much text is visible during the fade. Higher numbers will allow more text to be visible as it fades out                    |
|`[backwards]`|boolean |Whether to animate the typewriter backwards. Defaults to `false`                                                               |

The `smoothness` argument offers some customisation for how text fades out. A high value will cause text to be smoothly faded out whereas a smoothness of `0` will cause text to instantly pop onto the screen. For advanced users, custom shader code can be easily combined with the `smoothness` value to animate text in unique ways as it fades out.

?> [Events](Functions-(Miscellaneous)#scribble_typists_add_eventname-function) will **not** be executed as text fades out.

&nbsp;

## `.skip(state)`

**Returns**: `self`, the typist

|Name   |Datatype|Purpose                                                |
|-------|--------|-------------------------------------------------------|
|`state`|boolean |Whether the typist should skip the typewriter animation|

Skips the current typist animation, be it typing in or typing out. If text is typing in then all events on the current page will be executed in order of appearance. The skip behaviour also ignores per-character delay, and `[pause]` `[delay]` `[sync]` tags.

&nbsp;

## `.skip_to_pause(state)`

**Returns**: `self`, the typist

|Name   |Datatype|Purpose                                                |
|-------|--------|-------------------------------------------------------|
|`state`|boolean |Whether the typist should skip the typewriter animation|

As `.skip()` but the typist will wait at `[pause]` tags.

&nbsp;

## `.get_skip()`

**Returns**: Boolean, whether the typist is skipping typewriter animation

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

## `.ignore_delay()`

**Returns**: `self`, the typist

|Name   |Datatype|Purpose                                                                |
|-------|--------|-----------------------------------------------------------------------|
|`state`|boolean |Whether the typist should ignore per-character delay and `[delay]` tags|

Unlike the `.skip()` method above, this behaviour will still play the typewriter animation.

&nbsp;

## `.get_ignore_delay()`

**Returns**: Boolean, whether the typist is ignoring per-character delay and `[delay]` tags

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

## `.get_position()`

**Returns**: Real, the position of the typist's "head", corresponding to the index of the most recently revealed glyph

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This method will return a decimal value if the speed is a decimal value too.

&nbsp;

## `.reset()`

**Returns**: `self`, the typist

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Resets the typist entirely, resetting progress and deactivating any animation.

&nbsp;

## `.ease(easeMethod, dx, dy, xscale, yscale, rotation, alphaDuration)`

**Returns**: `self`, the typist

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

|`SCRIBBLE_EASE` members|                       |
|-----------------------|-----------------------|
|`.NONE`                |`.LINEAR`              |
|`.QUAD`                |`.CUBIC`               |
|`.QUART`               |`.QUINT`               |
|`.SINE`                |`.EXPO`                |
|`.CIRC`                |`.BACK`                |
|`.ELASTIC`             |`.BOUNCE`              |

&nbsp;

## `.get_state()`

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

## `.get_skip()`

**Returns:** Boolean, whether the typist is set to skip text typing

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

## `.pause()`

**Returns**: `self`, the typist

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Pauses the typewriter effect.

&nbsp;

## `.unpause()`

**Returns**: `self`, the typist

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Unpauses the typewriter effect. This is helpful when combined with the [`[pause]` command tag](Text-Formatting) and [`.get_paused()`](scribble_typist#get_paused).

&nbsp;

## `.get_paused()`

**Returns:** Boolean, whether the text element is currently paused due to encountering `[pause]` tag when typing out text

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

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

&nbsp;

## `.sound(soundArray, overlap, pitchMin, pitchMax)`

**Returns**: `self`, the typist

|Name        |Datatype                                                                                      |Purpose                                                                                                             |
|------------|----------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
|`soundArray`|array of [sounds](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm)|Array of audio assets that can be used for playback                                                                 |
|`overlap`   |real                                                                                          |Amount of overlap between sound effect playback, in milliseconds                                                    |
|`pitchMin`  |real                                                                                          |Minimum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `0.5` halves the pitch etc. |
|`pitchMax`  |real                                                                                          |Maximum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `2.0` doubles the pitch etc.|

It's quite common in games with typewriter-style text animations to have a "mumble" or "gibberish" sound effect that plays whilst text is being revealed. This function allows you to define an array of sound effects that will be randomly played as text is revealed. The pitch of these sounds can be randomly modulated as well by selecting `pitchMin` and `pitchMax` values.

Setting the `overlap` value to `0` will ensure that sound effects never overlap at all, which is generally what's desirable, but it can sound a bit stilted and unnatural. By setting the `overlap` argument to a number above `0`, sound effects will be played with a little bit of overlap which improves the effect considerably. A value around 30ms usually sounds ok. The `overlap` argument can be set to a value less than 0 if you'd like more space between sound effects.

&nbsp;

## `.sound_per_char(soundArray, pitchMin, pitchMax, [exceptionString])`

**Returns**: `self`, the typist

|Name               |Datatype                                                                                      |Purpose                                                                                                                                  |
|-------------------|----------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
|`soundArray`       |array of [sounds](https://manual.yoyogames.com/The_Asset_Editors/Sounds.htm)|Array of audio assets that can be used for playback                                                                                      |
|`pitchMin`         |real                                                                                          |Minimum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `0.5` halves the pitch etc.                      |
|`pitchMax`         |real                                                                                          |Maximum pitch to play a sound at. A value of `1.0` gives no change in pitch, a value of `2.0` doubles the pitch etc.                     |
|`[exceptionString]`|real                                                                                          |String of characters for whom a sound should **not** be played. If no string is specified, all characters will play a sound when revealed|

It's quite common in games with typewriter-style text animations to have a sound effect that plays as text shows up. This function allows you to define an array of sound effects that will be randomly played as **each character** is revealed. The pitch of these sounds can be randomly modulated as well by selecting `pitchMin` and `pitchMax` values.

&nbsp;

## `.function_per_char(function)`

**Returns**: `self`, the typist

|Name      |Datatype|Purpose|
|----------|--------|-------|
|`function`|function|       |

`.function_per_char()` allows you to define a function that will be executed once per character as that character is revealed. The function is passed three arguments:
1. Text element that triggered the callback
2. Position of the character that was just revealed
3. Typist that triggered the callback

```
///Create
typist = scribble_typist();
typist.in(0.1, 3);
typist.function_per_char(function(_element, _position, _typist)
{
    //Example function to manually control text sound playback behaviour
    
    show_debug_message(_position);
    
    //Don't play any sound if the typist is set to skip typing
    if (!_typist.get_skip())
    {
        //Modulate our pitch on a sine curve
        var _pitch = lerp(0.8, 1.2, 0.5 + 0.5*dsin(36*_position));
        
        //Play a sound and then modify its pitch
        var _sound_instance = audio_play_sound(snd_switch, 1, false);
        audio_sound_pitch(_sound_instance, _pitch);
    }
});
```

&nbsp;

## `.get_text_element()`

**Returns**: The text element associated with the typist, or `undefined` if no text element is associated

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

## `.execution_scope(scope)`

**Returns**: `self`, the typist

|Name   |Datatype       |Purpose                                       |
|-------|---------------|----------------------------------------------|
|`scope`|instance/struct|The new scope to execution typist functions in|

By default, a typist will execute functions in the scope of the instance/struct that called the `.draw()` method for the text element associated with the typist. `.execution_scope()` overrides this execution scope, setting it to a specific instance or struct. If you'd like to reset the execution scope, use `undefined` as the method argument.

&nbsp;

## `.get_execution_scope()`

**Returns**: The execution scope for this typist's function, or `undefined`

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This method will, by default, return `undefined`. See `.execution_scope()` for details.

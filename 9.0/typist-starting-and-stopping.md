# Starting & Stopping

&nbsp;

## `.in()`

**Typist Method:** `.in(speed, smoothness)`

**Returns**: `self`, the typist

|Name        |Datatype|Purpose                                                                                                                        |
|------------|--------|-------------------------------------------------------------------------------------------------------------------------------|
|`speed`     |number  |Amount of text to reveal per tick (1 tick is usually 1 frame). This is character or lines depending on the method defined above|
|`smoothness`|number  |How much text is visible during the fade. Higher numbers will allow more text to be visible as it fades in                     |

The `smoothness` argument offers some customisation for how text fades in. A high value will cause text to be smoothly faded in whereas a smoothness of `0` will cause text to instantly pop onto the screen. For advanced users, custom shader code can be easily combined with the `smoothness` value to animate text in unique ways as it fades in.

[Events](Functions-(Miscellaneous)#scribble_typists_add_eventname-function) (in-line scripts) will be executed as text fades in. This is a powerful tool and can be used to achieve many things, including triggering sound effects, changing character portraits, starting movement of instances, starting weather effects, giving the player items, and so on.

&nbsp;

## `.out()`

**Typist Method:** `.out(speed, smoothness, [backwards])`

**Returns**: `self`, the typist

|Name         |Datatype|Purpose                                                                                                                        |
|-------------|--------|-------------------------------------------------------------------------------------------------------------------------------|
|`speed`      |number  |Amount of text to reveal per tick (1 tick is usually 1 frame). This is character or lines depending on the method defined above|
|`smoothness` |number  |How much text is visible during the fade. Higher numbers will allow more text to be visible as it fades out                    |
|`[backwards]`|boolean |Whether to animate the typewriter backwards. Defaults to `false`                                                               |

The `smoothness` argument offers some customisation for how text fades out. A high value will cause text to be smoothly faded out whereas a smoothness of `0` will cause text to instantly pop onto the screen. For advanced users, custom shader code can be easily combined with the `smoothness` value to animate text in unique ways as it fades out.

?> [Events](Functions-(Miscellaneous)#scribble_typists_add_eventname-function) will **not** be executed as text fades out.

&nbsp;

## `.reset()`

**Typist Method:** `.reset()`

**Returns**: `self`, the typist

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Resets the typist entirely, resetting progress and deactivating any animation.

&nbsp;

## `.get_position()`

**Typist Method:** `.get_position()`

**Returns**: Number, the position of the typist's "head", corresponding to the index of the most recently revealed glyph

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This method will return a decimal value if the speed is a decimal value too.

&nbsp;

## `.get_state()`

**Typist Method:** `.get_state()`

**Returns:** Number, value from 0 to 2 (inclusive) that represents what proportion of text on the current page is visible

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
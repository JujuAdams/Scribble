# Animation Properties

?> These functions are global in scope. Once an animation property is set, it will affect every Scribble text element that gets drawn until that property is adjusted again. `scribble_anim_reset()` is provided to conveniently restore animation properties to their defaults.

&nbsp;

## `.animation_speed()`

**Global Function:** `.animation_speed(speed)`

**Returns**: The text element

|Name   |Datatype|Purpose                                                                                               |
|-------|--------|------------------------------------------------------------------------------------------------------|
|`speed`|number  |The animation speed multiplier where `1` is normal speed, `2` is double speed, and `0.5` is half speed|

Setting the animation speed value to `0` will pause animation effects. This value can even be negative to play effects backwards!

?> This setting does not impact typists. Instead, please use the `.pause()` typist method to pause typists.

&nbsp;

## `.get_animation_speed()`

**Global Function:** `.get_animation_speed()`

**Returns**: The current animation speed

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

The value returned from this function defaults to `1`.

&nbsp;

## `scribble_anim_reset()`

**Global Function:** `scribble_anim_reset()`

**Returns**: N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Restores animation properties to the defaults set in configuration.

&nbsp;

## `scribble_anim_wave())`

**Global Function:** `scribble_anim_wave(size, frequency, speed)`

**Returns**: The text element

|Name       |Datatype|Purpose                                                                                             |
|-----------|--------|----------------------------------------------------------------------------------------------------|
|`size`     |number  |Maximum pixel offset of the animation                                                               |
|`frequency`|number  |Frequency of the animation. Larger values will create more horizontally frequent "humps" in the text|
|`speed`    |number  |Speed of the animation                                                                              |

This function controls behaviour of the `[wave]` effect across all future drawn text elements.

&nbsp;

## `scribble_anim_shake()`

**Global Function:** `scribble_anim_shake(size, speed)`

**Returns**: The text element

|Name       |Datatype|Purpose                                                          |
|-----------|--------|-----------------------------------------------------------------|
|`size`     |number  |Maximum pixel offset of the animation                            |
|`speed`    |number  |Speed of the animation. Larger numbers cause text to shake faster|

This function controls behaviour of the `[shake]` effect across all future drawn text elements.

&nbsp;

## `scribble_anim_rainbow()`

**Global Function:** `scribble_anim_rainbow(weight, speed)`

**Returns**: The text element

|Name    |Datatype|Purpose                                                                                                                   |
|--------|--------|--------------------------------------------------------------------------------------------------------------------------|
|`weight`|number  |Blend weight of the rainbow colouring. A value of 0 will not apply the effect, a value of 1 will blend with 100% weighting|
|`speed` |number  |Cycling speed of the animation. Larger numbers scroll faster                                                              |

This function controls behaviour of the `[rainbow]` effect across all future drawn text elements.

&nbsp;

## `scribble_anim_wobble()`

**Global Function:** `scribble_anim_wobble(angle, frequency)`

**Returns**: The text element

|Name       |Datatype|Purpose                                                              |
|-----------|--------|---------------------------------------------------------------------|
|`angle`    |number  |Maximum angular offset of the animation                              |
|`frequency`|number  |Speed of the animation. Larger numbers cause text to oscillate faster|

This function controls behaviour of the `[wobble]` effect across all future drawn text elements.

&nbsp;

## `scribble_anim_pulse()`

**Global Function:** `scribble_anim_pulse(scale, speed)`

**Returns**: The text element

|Name   |Datatype|Purpose                                                                        |
|-------|--------|-------------------------------------------------------------------------------|
|`scale`|number  |Maximum scale of the animation                                                 |
|`speed`|number  |Speed of the animation. Larger values will cause text to shrink and grow faster|

This function controls behaviour of the `[pulse]` effect across all future drawn text elements.

&nbsp;

## `scribble_anim_wheel()`

**Global Function:** `scribble_anim_wheel(size, frequency, speed)`

**Returns**: The text element

|Name       |Datatype|Purpose                                                                  |
|-----------|--------|-------------------------------------------------------------------------|
|`size`     |number  |Maximum pixel offset of the animation                                    |
|`frequency`|number  |Frequency of the animation. Larger values will create more chaotic motion|
|`speed`    |number  |Speed of the animation                                                   |

This function controls behaviour of the `[wheel]` effect across all future drawn text elements.

&nbsp;

## `scribble_anim_cycle()`

**Global Function:** `scribble_anim_cycle(speed, saturation, value)`

**Returns**: The text element

|Name        |Datatype|Purpose                                                                                                                                                                                                                                                             |
|------------|--------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`speed`     |number  |Speed of the animation. Larger values will cause the colour to cycle faster                                                                                                                                                                                         |
|`saturation`|integer |Saturation of colours generated by the animation. Values from 0 to 255 (inclusive) are accepted, much like GM's [`make_color_hsv()`](https://manual.yoyogames.com/#t=GameMaker_Language%2FGML_Reference%2FDrawing%2FColour_And_Alpha%2Fmake_colour_hsv.htm)         |
|`value`     |integer |Value ("lightness") of colours generated by the animation. Values from 0 to 255 (inclusive) are accepted, much like GM's [`make_color_hsv()`](https://manual.yoyogames.com/#t=GameMaker_Language%2FGML_Reference%2FDrawing%2FColour_And_Alpha%2Fmake_colour_hsv.htm)|

This function controls behaviour of the `[cycle]` effect across future drawn text elements.

&nbsp;

## `scribble_anim_jitter()`

**Global Function:** `scribble_anim_jitter(minScale, maxScale, speed)`

**Returns**: The text element

|Name      |Datatype|Purpose                                                          |
|----------|--------|-----------------------------------------------------------------|
|`minScale`|number  |Minimum scale offset of the animation                            |
|`maxScale`|number  |Maximum scale offset of the animation                            |
|`speed`   |number  |Speed of the animation. Larger numbers cause text to shake faster|

This function controls behaviour of the `[jitter]` effect across future drawn text elements.

&nbsp;

## `scribble_anim_blink()`

**Global Function:** `scribble_anim_blink(onDuration, offDuration, timeOffset)`

**Returns**: The text element

|Name         |Datatype|Purpose                                         |
|-------------|--------|------------------------------------------------|
|`onDuration` |number  |Number of ticks that blinking text is shown for |
|`offDuration`|number  |Number of ticks that blinking text is hidden for|
|`timeOffset` |number  |Time offset for calculating the blink state     |

This function controls behaviour of the `[blink]` effect across future drawn text elements.
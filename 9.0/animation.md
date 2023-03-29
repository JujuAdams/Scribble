# Animation

&nbsp;

## `[wave]` `[/wave]`

**Command tag.**

Set/unset text to wave up and down. Modified by [`scribble_anim_wave()`](animation-properties?id=scribble_anim_wavesize-frequency-speed).

&nbsp;

## `[shake]` `[/shake]`

**Command tag.**

Set/unset text to shake. Modified by [`scribble_anim_shake()`](animation-properties?id=scribble_anim_shakesize-speed).

&nbsp;

## `[wobble]` `[/wobble]`

**Command tag.**

Set/unset text to wobble by rotating back and forth. Modified by [`scribble_anim_wobble()`](animation-properties?id=scribble_anim_wobbleangle-frequency).

&nbsp;

## `[pulse]` `[/pulse]`

**Command tag.**

Set/unset text to shrink and grow rhythmically. Modified by [`scribble_anim_pulse()`](animation-properties?id=scribble_anim_pulsescale-speed).

&nbsp;

## `[wheel]` `[/wheel]`

**Command tag.**

Set/unset text to circulate around their origin. Modified by [`scribble_anim_wheel()`](animation-properties?id=scribble_anim_wheelsize-frequency-speed).

&nbsp;

## `[jitter]` `[/jitter]`

**Command tag.**

Set/unset text to scale erratically. Modified by [`scribble_anim_jitter()`](animation-properties?id=scribble_anim_jitterminscale-maxscale-speed).

&nbsp;

## `[blink]` `[/blink]`

**Command tag.**

Set/unset text to flash on and off. Modified by [`scribble_anim_blink()`](animation-properties?id=scribble_anim_blinkonduration-offduration-timeoffset).

&nbsp;

## `[rainbow]` `[/rainbow]`

**Command tag.**

Set/unset rainbow colour cycling. Modified by [`scribble_anim_rainbow()`](animation-properties?id=scribble_anim_rainbowweight-speed).

&nbsp;

## `[cycle]` `[/cycle]`

**Command tag.**

Set/unset a custom HSV colour cycle using the specified hues. Up to four hues may be specified. Saturation and value are controlled using [`scribble_anim_cycle()`](animation-properties?id=scribble_anim_cyclespeed-saturation-value).

&nbsp;

## `.randomize_animation()`

**Text Element Method:** `.randomize_animation(state)`

**Returns**: The text element

|Name   |Datatype|Purpose                                                |
|-------|--------|-------------------------------------------------------|
|`state`|boolean |Whether to randomize the order that glyphs are animated|

Setting this method to `true` will also randomize any and all effects. This includes typewriter effects achieved with typists or `.reveal()`, and also animated formatting via command tags such as `[shake]` `[rainbow]` etc.

!> This method is a *regenerator*. If the value is changed then the text element will be regenerated, potentially leading to degraded performance.
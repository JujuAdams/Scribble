`scribble_set_animation(animProperty, value)`

**Returns:** N/A (`0`)

|Argument|Name          |Purpose                                                   |
|--------|--------------|----------------------------------------------------------|
|0       |`animProperty`|Integer index for the target animation property. See below|
|1       |`value`       |Value to set the property to                              |

This script sets part of Scribble's global state. All text drawn with [`scribble_draw()`](scribble_draw) or cached with [`scribble_cache()`](scribble_cache) will use these settings until they're overwritten, either by calling this script again or by calling [`scribble_reset()`](scribble_reset) or [`scribble_set_state()`](scribble_set_state).

The integer indexes to be used for the `animProperty` parameter are found in the `SCRIBBLE_ANIM` enum. For example:

```GML
scribble_set_animation(SCRIBBLE_ANIM.RAINBOW_WEIGHT, 0.5);
```
sets the weight of the `[rainbow]` effect to 50%.

Here are the member elements of `SCRIBBLE_ANIM`:

|Element         |Purpose                                                                                                                    |
|----------------|---------------------------------------------------------------------------------------------------------------------------|
|`WAVE_SIZE`     |Maximum pixel offset of the `[wave]` effect                                                                                |
|`WAVE_FREQ`     |Frequency of the `[wave]` effect. Larger values will create more horizontally frequent "humps" in the text                 |
|`WAVE_SPEED`    |Speed of the `[wave]` effect                                                                                               |
|`SHAKE_SIZE`    |Maximum pixel offset of the `[shake]` effect                                                                               |
|`SHAKE_SPEED`   |Speed of the `[shake]` effect. Larger numbers cause text to shake faster                                                   |
|`RAINBOW_WEIGHT`|Blend weight of the `[rainbow]` effect. A value of 0 will not apply the effect, a value of 1 will blend with 100% weighting|
|`RAINBOW_SPEED` |Cycling speed of the `[rainbow]` effect. Increase to make colour scrolling faster                                          |
|`WOBBLE_ANGLE`  |Maximum angular offset of the `[wobble]` effect                                                                            |
|`WOBBLE_FREQ`   |Speed of the `[wobble]` effect. Larger numbers cause text to oscillate faster                                              |
|`PULSE_SCALE`   |Maximum scale of the `[pulse]` effect                                                                                      |
|`PULSE_SPEED`   |Speed of the `[pulse]` effect. Larger values will cause text to shrink and grow faster                                     |
|`WHEEL_SIZE`    |Maximum pixel offset of the `[wheel]` effect                                                                               |
|`WHEEL_FREQ`    |Frequency of the `[wheel]` effect. Larger values will create more chaotic motion                                           |
|`WHEEL_SPEED`   |Speed of the `[wheel]` effect                                                                                              |
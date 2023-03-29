# Default Property Configuration

&nbsp;

## `SCRIBBLE_DEFAULT_COLOR`

*Typical value:* `c_white`

Default vertex colour when drawing text models. This can be overwritten by the `.colour()` text element method. This will not affect `draw_text_scribble()` which instead uses the value returned by GameMaker's native `draw_get_color()`.

&nbsp;

## `SCRIBBLE_DEFAULT_HALIGN`

*Typical value:* `fa_left`

Default horizontal alignment for text. This can be changed using the `.align()` text element method. This will not affect `draw_text_scribble()` which instead uses the value returned by GameMaker's native `draw_get_halign()`.

&nbsp;

## `SCRIBBLE_DEFAULT_VALIGN`

*Typical value:* `fa_top`

Default vertical alignment for text. This can be changed using the `.align()` text element method. This will not affect `draw_text_scribble()` which instead uses the value returned by GameMaker's native `draw_get_valign()`.

&nbsp;

## `SCRIBBLE_DEFAULT_SPRITE_SPEED`

*Typical value:* `1`

The default animation speed for sprites inserted into text.

&nbsp;

## `SCRIBBLE_DEFAULT_DELAY_DURATION`

*Typical value:* `450`

Default duration of the `[delay]` command, in milliseconds.

&nbsp;

## `SCRIBBLE_SLANT_GRADIENT`

*Typical value:* `0.25`

The x-axis displacement when using the `[slant]` tag as a proportion of the glyph height.

&nbsp;

## `SCRIBBLE_DEFAULT_Z`

*Typical value:* `0`

Default z-position when drawing text models. This can be overwritten by the `.z()` text element method.

&nbsp;

## `SCRIBBLE_DEFAULT_WAVE_SIZE`

*Typical value:* `4`

Default wave amplitude, in pixels.

&nbsp;

## `SCRIBBLE_DEFAULT_WAVE_FREQUENCY`

*Typical value:* `50`

Default wave frequency. Larger values create more "humps" over a certain number of characters.

&nbsp;

## `SCRIBBLE_DEFAULT_WAVE_SPEED`

*Typical value:* `0.2`

Default wave speed. Larger numbers cause characters to move up and down more rapidly.

&nbsp;

## `SCRIBBLE_DEFAULT_SHAKE_SIZE`

*Typical value:* `2`

Default shake amplitude, in pixels.

&nbsp;

## `SCRIBBLE_DEFAULT_SHAKE_SPEED`

*Typical value:* `0.4`

Default shake speed. Larger values cause characters to move around more rapidly.

&nbsp;

## `SCRIBBLE_DEFAULT_RAINBOW_WEIGHT`

*Typical value:* `0.5`

Default rainbow blend weight. 0 does not show any rainbow effect at all, and 1 will blend a glyph's colour fully with the rainbow colour.

&nbsp;

## `SCRIBBLE_DEFAULT_RAINBOW_SPEED`

*Typical value:* `0.01`

Default rainbow speed. Larger values cause characters to change colour more rapidly.

&nbsp;

## `SCRIBBLE_DEFAULT_WOBBLE_ANGLE`

*Typical value:* `40`

Default maximum wobble angle. Larger values cause glyphs to oscillate further to the left and right.

&nbsp;

## `SCRIBBLE_DEFAULT_WOBBLE_FREQ`

*Typical value:* `0.15`

Default wobble frequency. Larger values cause glyphs to oscillate faster.

&nbsp;

## `SCRIBBLE_DEFAULT_PULSE_SCALE`

*Typical value:* `0.4`

Default pulse scale offset. A value of 0 will cause no visible scaling changes for a glyph, a value of 1 will cause a glyph to double in size.

&nbsp;

## `SCRIBBLE_DEFAULT_PULSE_SPEED`

*Typical value:* `0.1`

Default pulse speed. Larger values cause glyph scales to pulse faster.

&nbsp;

## `SCRIBBLE_DEFAULT_WHEEL_SIZE`

*Typical value:* `1`

Default wheel amplitude, in pixels.

&nbsp;

## `SCRIBBLE_DEFAULT_WHEEL_FREQUENCY`

*Typical value:* `0.5`

Default wheel frequency. Larger values create more "humps" over a certain number of characters.

&nbsp;

## `SCRIBBLE_DEFAULT_WHEEL_SPEED`

*Typical value:* `0.2`

Default wheel speed. Larger numbers cause characters to move up and down more rapidly.

&nbsp;

## `SCRIBBLE_DEFAULT_CYCLE_SPEED`

*Typical value:* `0.5`

Default cycle speed. Larger numbers cause characters to change colour more rapidly.

&nbsp;

## `SCRIBBLE_DEFAULT_CYCLE_SATURATION`

*Typical value:* `180`

Default cycle colour saturation, from 0 to 255. Colour cycles using the HSV model to create colours.

&nbsp;

## `SCRIBBLE_DEFAULT_CYCLE_VALUE`

*Typical value:* `255`

Default cycle colour value, from 0 to 255. Colour cycles using the HSV model to create colours.

&nbsp;

## `SCRIBBLE_DEFAULT_JITTER_SCALE`

*Typical value:* `0.3`

Default jitter scale. A value of 0 will cause no visible scaling changes for a glyph.

&nbsp;

## `SCRIBBLE_DEFAULT_JITTER_SPEED`

*Typical value:* `0.4`

Default jitter speed. Larger values cause glyph scales to fluctuate faster.

&nbsp;

## `SCRIBBLE_DEFAULT_BLINK_ON_DURATION`

*Typical value:* `50`

Default duration that blinking text should stay on for, in milliseconds.

&nbsp;

## `SCRIBBLE_DEFAULT_BLINK_OFF_DURATION`

*Typical value:* `50`

Default duration that blinking text should turn off for, in milliseconds.

&nbsp;

## `SCRIBBLE_DEFAULT_BLINK_TIME_OFFSET`

*Typical value:* `0`

Default blink time offset, in milliseconds.

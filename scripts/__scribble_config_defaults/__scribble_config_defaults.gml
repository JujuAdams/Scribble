// Default font is set by scribble_font_set_default()

#macro SCRIBBLE_DEFAULT_COLOR               c_white  //Default vertex colour when drawing text models. This can be overwritten by the .starting_format() text element method
#macro SCRIBBLE_DEFAULT_HALIGN              fa_left  //Default horizontal alignment for text. This can be changed using the .align() text element method
#macro SCRIBBLE_DEFAULT_VALIGN              fa_top   //Default vertical alignment for text. This can be changed using the .align() text element method
#macro SCRIBBLE_DEFAULT_SPRITE_SPEED        0.1      //The default animation speed for sprites inserted into text
#macro SCRIBBLE_DEFAULT_DELAY_DURATION      450      //Default duration of the [delay] command, in milliseconds
#macro SCRIBBLE_SLANT_GRADIENT              0.25     //The x-axis displacement when using the [slant] tag as a proportion of the glyph height
#macro SCRIBBLE_DEFAULT_Z                   0        //Default z-position when drawing text models. This can be overwritten by the .z() text element method

#macro SCRIBBLE_DEFAULT_WAVE_SIZE           4        //Default wave amplitude, in pixels
#macro SCRIBBLE_DEFAULT_WAVE_FREQUENCY      50       //Default wave frequency. Larger values create more "humps" over a certain number of characters
#macro SCRIBBLE_DEFAULT_WAVE_SPEED          0.2      //Default wave speed. Larger numbers cause characters to move up and down more rapidly

#macro SCRIBBLE_DEFAULT_SHAKE_SIZE          2        //Default shake amplitude, in pixels
#macro SCRIBBLE_DEFAULT_SHAKE_SPEED         0.4      //Default shake speed. Larger values cause characters to move around more rapidly

#macro SCRIBBLE_DEFAULT_RAINBOW_WEIGHT      0.5      //Default rainbow blend weight. 0 does not show any rainbow effect at all, and 1 will blend a glyph's colour fully with the rainbow colour
#macro SCRIBBLE_DEFAULT_RAINBOW_SPEED       0.01     //Default rainbow speed. Larger values cause characters to change colour more rapidly

#macro SCRIBBLE_DEFAULT_WOBBLE_ANGLE        40       //Default maximum wobble angle. Larger values cause glyphs to oscillate further to the left and right
#macro SCRIBBLE_DEFAULT_WOBBLE_FREQ         0.15     //Default wobble frequency. Larger values cause glyphs to oscillate faster

#macro SCRIBBLE_DEFAULT_PULSE_SCALE         0.4      //Default pulse scale offset. A value of 0 will cause no visible scaling changes for a glyph, a value of 1 will cause a glyph to double in size
#macro SCRIBBLE_DEFAULT_PULSE_SPEED         0.1      //Default pulse speed. Larger values cause glyph scales to pulse faster

#macro SCRIBBLE_DEFAULT_WHEEL_SIZE          1        //Default wheel amplitude, in pixels
#macro SCRIBBLE_DEFAULT_WHEEL_FREQUENCY     0.5      //Default wheel frequency. Larger values create more "humps" over a certain number of characters
#macro SCRIBBLE_DEFAULT_WHEEL_SPEED         0.2      //Default wheel speed. Larger numbers cause characters to move up and down more rapidly

#macro SCRIBBLE_DEFAULT_CYCLE_SPEED         0.5      //Default cycle speed. Larger numbers cause characters to change colour more rapidly
#macro SCRIBBLE_DEFAULT_CYCLE_SATURATION    180      //Default cycle colour saturation, from 0 to 255. Colour cycles using the HSV model to create colours
#macro SCRIBBLE_DEFAULT_CYCLE_VALUE         255      //Default cycle colour value, from 0 to 255. Colour cycles using the HSV model to create colours

#macro SCRIBBLE_DEFAULT_JITTER_MIN_SCALE    0.7      //Default jitter minimum scale. Unlike SCRIBBLE_DEFAULT_PULSE_SCALE this is not an offset
#macro SCRIBBLE_DEFAULT_JITTER_MAX_SCALE    1.2      //Default jitter maximum scale. Unlike SCRIBBLE_DEFAULT_PULSE_SCALE this is not an offset
#macro SCRIBBLE_DEFAULT_JITTER_SPEED        0.4      //Default jitter speed. Larger values cause glyph scales to fluctuate faster

#macro SCRIBBLE_DEFAULT_BLINK_ON_DURATION   50       //Default duration that blinking text should stay on for, in milliseconds
#macro SCRIBBLE_DEFAULT_BLINK_OFF_DURATION  50       //Default duration that blinking text should turn off for, in milliseconds
#macro SCRIBBLE_DEFAULT_BLINK_TIME_OFFSET   0        //Default blink time offset, in milliseconds
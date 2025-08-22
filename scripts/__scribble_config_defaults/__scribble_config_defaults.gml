//Default vertex colour when drawing text models. This can be overwritten by the
//`.starting_format()` text element method. This will not affect `draw_text_scribble()`
//which instead uses `draw_get_color()`.
#macro SCRIBBLE_DEFAULT_COLOR  c_white

//Default horizontal alignment for text. This can be changed using the `.align()` text element
//method. This will not affect `draw_text_scribble()` which instead uses `draw_get_halign()`.
#macro SCRIBBLE_DEFAULT_HALIGN  fa_left

//Default vertical alignment for text. This can be changed using the `.align()` text element
//method. This will not affect `draw_text_scribble()` which instead uses `draw_get_valign()`.
#macro SCRIBBLE_DEFAULT_VALIGN  fa_top

//The default animation speed for sprites inserted into text.
#macro SCRIBBLE_DEFAULT_SPRITE_SPEED  1

//Default duration of the [delay] command, in milliseconds.
#macro SCRIBBLE_DEFAULT_DELAY_DURATION  450

//The x-axis displacement when using the [slant] tag as a proportion of the glyph height.
#macro SCRIBBLE_SLANT_GRADIENT  0.25

//Default z-position when drawing text models. This can be overwritten by the `.z()` text element
//method.
#macro SCRIBBLE_DEFAULT_Z  0

//Whether Scribble should default to using visual bounding boxes or logical bounding boxes. Visual
//bounding boxes are built from the vertex buffer quad coordinates. Logical bounding boxes are
//built from the layout information used to calculate glyph positions.
#macro SCRIBBLE_DEFAULT_VISUAL_BBOXES  false



//Default rainbow frequency. Larger values create more colour changes over a certain number of
//characters. This value should be between 0 and 1.
#macro SCRIBBLE_DEFAULT_RAINBOW_FREQUENCY  0.1

//Default rainbow speed. Larger numbers cause characters to change colour faster.
#macro SCRIBBLE_DEFAULT_RAINBOW_SPEED  0.1



//Default cycle frequency. Larger values create more colour changes over a certain number of
//characters. This value should be between 0 and 1.
#macro SCRIBBLE_DEFAULT_CYCLE_FREQUENCY  0.1

//Default cycle speed. Larger numbers cause characters to change colour faster.
#macro SCRIBBLE_DEFAULT_CYCLE_SPEED  0.1



//Default wave amplitude, in pixels.
#macro SCRIBBLE_DEFAULT_WAVE_SIZE  4

//Default wave frequency. Larger values create more "humps" over a certain number of characters.
#macro SCRIBBLE_DEFAULT_WAVE_FREQUENCY  50

//Default wave speed. Larger numbers cause characters to move up and down more rapidly.
#macro SCRIBBLE_DEFAULT_WAVE_SPEED  0.2



//Default shake amplitude, in pixels.
#macro SCRIBBLE_DEFAULT_SHAKE_SIZE  2

//Default shake speed. Larger values cause characters to move around more rapidly.
#macro SCRIBBLE_DEFAULT_SHAKE_SPEED  0.4



//Default maximum wobble angle. Larger values cause glyphs to oscillate further to the left and
//right.
#macro SCRIBBLE_DEFAULT_WOBBLE_ANGLE  40

//Default wobble frequency. Larger values cause glyphs to oscillate faster.
#macro SCRIBBLE_DEFAULT_WOBBLE_FREQ  0.15



//Default pulse scale offset. A value of 0 will cause no visible scaling changes for a glyph, a
//value of 1 will cause a glyph to double in size.
#macro SCRIBBLE_DEFAULT_PULSE_SCALE  0.4

//Default pulse speed. Larger values cause glyph scales to pulse faster.
#macro SCRIBBLE_DEFAULT_PULSE_SPEED  0.1



//Default wheel amplitude, in pixels.
#macro SCRIBBLE_DEFAULT_WHEEL_SIZE  1

//Default wheel frequency. Larger values create more "humps" over a certain number of characters.
#macro SCRIBBLE_DEFAULT_WHEEL_FREQUENCY  0.5

//Default wheel speed. Larger numbers cause characters to move up and down more rapidly.
#macro SCRIBBLE_DEFAULT_WHEEL_SPEED  0.2



//Default jitter minimum scale. Unlike `SCRIBBLE_DEFAULT_PULSE_SCALE` this is not an offset.
#macro SCRIBBLE_DEFAULT_JITTER_MIN_SCALE  0.7

//Default jitter maximum scale. Unlike `SCRIBBLE_DEFAULT_PULSE_SCALE` this is not an offset.
#macro SCRIBBLE_DEFAULT_JITTER_MAX_SCALE  1.2

//Default jitter speed. Larger values cause glyph scales to fluctuate faster.
#macro SCRIBBLE_DEFAULT_JITTER_SPEED  0.4

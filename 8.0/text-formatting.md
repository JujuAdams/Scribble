# Text Formatting

&nbsp;

Scribble supports many in-line commands that can be used inside a string. Here's a quick example:

```
scribble("This text is normal size. [scale,2]This text is twice as big.").draw(x, y);
```

This will draw a string with two differently sized substrings. Simple!

Of course, because the `[` character is used to open a command tag, putting a single square bracket in a line will cause Scribble to try to interpret following characters as part of a command tag. If you want to include a `[` literal in your string then double up the character:

```
//This string will display as "Here's a square bracket [!"
scribble("Here's a square bracket [[!");
```

You **don't** need to double up the closing bracket `]` to include one in your displayed text.

&nbsp;

**Please note** that text alignment follows the following rules:

1. In-line vertical alignment affects the entire textbox and cannot be changed midway through text display
2. Changing horizontal alignment in the middle of a line of text will add a line break
3. Native GameMaker font alignment options (`fa_left`, `fa_center`, `fa_right`) are not intended to be used in conjunction with Scribble's own custom alignment options (`pin_left`, `pin_center`, `pin_right`)

&nbsp;

Scribble supports the following commands:

|Formatting tag                       |Behaviour                                                                                                                                                                                                            |
|-------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`[/]`                                |Reset formatting to defaults                                                                                                                                                                                         |
|`[/page]`                            |Manual page break                                                                                                                                                                                                    |
|`[<name of font>]`                   |Set font                                                                                                                                                                                                             |
|`[/font]` `[/f]`                     |Reset font                                                                                                                                                                                                           |
|`[nbsp]`                             |Inserts a non-breaking space. Actual non-breaking space characters *are* natively supported but `[nbsp]` may be more convenient in some situations                                                                   |
|`[region,<name>]`                    |Creates a region of text that can be detected later. Useful for tooltips and hyperlinks                                                                                                                              |
|`[/region]`                          |Ends a region                                                                                                                                                                                                        |
|**Colour**                           |                                                                                                                                                                                                                     |
|`[<name of colour>]`                 |Set colour. Colour names are defined in [`__scribble_config_colours()`](configuration?id=__scribble_config_colours)                                                                                                  |
|`[#<hex code>]`                      |Set colour via a hexcode (format controlled by [`SCRIBBLE_BGR_COLOR_HEX_CODES`](configuration))                                                                                                                      |
|`[d#<decimal>]`                      |Set colour via a decimal integer, using GameMaker's BGR format                                                                                                                                                       |
|`[/colour]` `[/color]` `[/c]`        |Reset colour                                                                                                                                                                                                         |
|**Sprites, Surfaces, Sounds**        |                                                                                                                                                                                                                     |
|`[<name of sprite>]`                 |Insert an animated sprite starting on image 0 and animating using [`SCRIBBLE_DEFAULT_SPRITE_SPEED`](configuration)                                                                                                   |
|`[<name of sprite>,<image>]`         |Insert a static sprite using the specified image index                                                                                                                                                               |
|`[<name of sprite>,<image>,<speed>]` |Insert animated sprite using the specified image index and animation speed                                                                                                                                           |
|`[surface,<surfaceID>]`              |Insert surface with the associated index                                                                                                                                                                             |
|`[<name of sound>]`                  |Insert sound playback event. Sounds will only be played when using Scribble's typewriter feature                                                                                                                     |
|**Alignment**                        |                                                                                                                                                                                                                     |
|`[fa_left]`                          |Horizontally align this line of text to the left of the [`.draw()`](scribble-methods?id=drawx-y) coordinate                                                                                                          |
|`[fa_center]` `[fa_centre]`          |Horizontally align this line of text centrally at the [`.draw()`](scribble-methods?id=drawx-y) coordinate                                                                                                            |
|`[fa_right]`                         |Horizontally align this line of text to the right of the [`.draw()`](scribble-methods?id=drawx-y) coordinate                                                                                                         |
|`[fa_top]`                           |Vertically align **all text** to the top of the [`.draw()`](scribble-methods?id=drawx-y) coordinate                                                                                                                  |
|`[fa_middle]`                        |Vertically align **all text** to the middle of the [`.draw()`](scribble-methods?id=drawx-y) coordinate                                                                                                               |
|`[fa_bottom]`                        |Vertically align **all text** to the bottom of the [`.draw()`](scribble-methods?id=drawx-y) coordinate                                                                                                               |
|`[pin_left]`                         |Horizontally align this line of text to the left of the entire textbox                                                                                                                                               |
|`[pin_center]` `[pin_centre]`        |Horizontally align this line of text centrally versus the entire textbox                                                                                                                                             |
|`[pin_right]`                        |Horizontally align this line of text to the right of the entire textbox                                                                                                                                              |
|**Typewriter Control**               |*The following commands only affect the typewriter when text is fading **in***                                                                                                                                       |
|`[<event name>,<arg0>,<arg1>...]`    |Trigger an event with the specified arguments (see [`scribble_typewriter_add_event()`](misc-functions?id=scribble_typewriter_add_eventname-function)                                                                 |
|`[delay,<milliseconds>]`             |Delay the typewriter by the given number of milliseconds. If no time value is given then the delay with defaults to [`SCRIBBLE_DEFAULT_DELAY_DURATION`](configuration)                                               |
|`[pause]`                            |Pause the typewriter. The typewriter can be unpaused by calling [`.typewriter_unpause()`](scribble-methods?id=typewriter_unpause)                                                                                    |
|`[speed,<factor>]`                   |Sets the speed of the typewriter by multiplying the value set by [`.typewriter_in()`](scribble-methods?id=typewriter_inspeed-smoothness) by `<factor>`. A value of `2.0` will be twice as fast etc.                  |
|`[/speed]`                           |Resets the speed of the typewriter to the value set by [`.typewriter_in()`](scribble-methods?id=typewriter_inspeed-smoothness)                                                                                       |
|**Transformation**                   |                                                                                                                                                                                                                     |
|`[scale,<factor>]`                   |Set text (and in-line sprite) scale                                                                                                                                                                                  |
|`[scaleStack,<factor>]`              |Multiply the scale of text by `factor`                                                                                                                                                                               |
|`[/scale]` `[/s]`                    |Reset scale to x1                                                                                                                                                                                                    |
|`[slant]` `[/slant]`                 |Set/unset italic emulation. The size of the x offset is controlled by [`SCRIBBLE_SLANT_AMOUNT`](configuration)                                                                                                       |
|**Effects**                          |                                                                                                                                                                                                                     |
|`[wave]` `[/wave]`                   |Set/unset text to wave up and down. Modified by [`.animation_wave()`](scribble-methods?id=animation_wavesize-frequency-speed)                                                                                        |
|`[shake]` `[/shake]`                 |Set/unset text to shake. Modified by [`.animation_shake()`](scribble-methods?id=animation_shakesize-speed)                                                                                                           |
|`[wobble]` `[/wobble]`               |Set/unset text to wobble by rotating back and forth. Modified by [`.animation_wobble()`](scribble-methods?id=animation_wobbleangle-frequency)                                                                        |
|`[pulse]` `[/pulse]`                 |Set/unset text to shrink and grow rhythmically. Modified by [`.animation_pulse()`](scribble-methods?id=animation_pulsescale-speed)                                                                                   |
|`[wheel]` `[/wheel]`                 |Set/unset text to circulate around their origin. Modified by [`.animation_wheel()`](scribble-methods?id=animation_wheelsize-frequency-speed)                                                                         |
|`[jitter]` `[/jitter]`               |Set/unset text to scale erratically. Modified by [`.animation_jitter()`](scribble-methods?id=animation_jitterminscale-maxscale-speed)                                                                                |
|`[blink]` `[/blink]`                 |Set/unset text to flash on and off. Modified by [`.animation_blink()`](scribble-methods?id=animation_blinkonduration-offduration-timeoffset)                                                                         |
|`[rainbow]` `[/rainbow]`             |Set/unset rainbow colour cycling. Modified by [`.animation_rainbow()`](scribble-methods?id=animation_rainbowweight-speed)                                                                                            |
|`[cycle,<hue1>,<hue2>,<hue3>,<hue4>]`|Set a custom HSV colour cycle using the specified hues. Up to four hues may be specified. Saturation and value are controlled using [`.animation_cycle()`](scribble-methods?id=animation_cyclespeed-saturation-value)|
|`[/cycle]`                           |Unset colour cycling                                                                                                                                                                                                 |

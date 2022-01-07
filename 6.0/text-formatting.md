If you'd like to play around with Scribble's text formatting, a [third-party demo tool](https://dragonite.itch.io/scribble-text-preview-tool) can be downloaded from itch.io.

|Formatting tag                      |Behaviour                                                                                                          |
|------------------------------------|-------------------------------------------------------------------------------------------------------------------|
|`[]`                                |Reset formatting to defaults                                                                                       |
|`[/page]`                           |Page break                                                                                                         |
|`[<name of font>] [/font] [/f]`     |Set font / Reset font                                                                                              |
|`[<event name>,<arg0>,<arg1>...]`   |Execute a script bound to an event name with the specified arguments (see [`scribble_add_autotype_event()`](https://github.com/JujuAdams/scribble/wiki/(6.0.0)-scribble_shader_add_tag))|
|**Colour**                          |                                                                                                                   |
|`[<name of colour>]`                |Set colour                                                                                                         |
|`[#<hex code>]`                     |Set colour via a hexcode, using the industry standard 24-bit RGB format (#RRGGBB)                                  |
|`[d#<decimal>]`                     |Set colour via a decimal integer, using GameMaker's BGR format                                                     |
|`[/colour] [/c]`                    |Reset colour to the default                                                                                        |
|**Sprites**                         |                                                                                                                   |
|`[<name of sprite>]`                |Insert an animated sprite starting on image 0 and animating using [`SCRIBBLE_DEFAULT_SPRITE_SPEED`](https://github.com/JujuAdams/scribble/wiki/(6.0.0)-__scribble_macros)|
|`[<name of sprite>,<image>]`        |Insert a static sprite using the specified image index                                                             |
|`[<name of sprite>,<image>,<speed>]`|Insert animated sprite using the specified image index and animation speed                                         |
|**Alignment**                       |                                                                                                                   |
|`[fa_left]`                         |Align horizontally to the left. This will insert a line break if used in the middle of a line of text              |
|`[fa_right]`                        |Align horizontally to the right. This will insert a line break if used in the middle of a line of text             |
|`[fa_center] [fa_centre]`           |Align centrally. This will insert a line break if used in the middle of a line of text                             |
|**Effects**                         |                                                                                                                   |
|`[scale,<factor>] [/scale] [/s]`    |Scale text / Reset scale to x1                                                                                     |
|`[slant] [/slant]`                  |Set/unset italic emulation                                                                                         |
|`[wave]    [/wave]`                 |Set/unset text to wave up and down                                                                                 |
|`[shake]   [/shake]`                |Set/unset text to shake                                                                                            |
|`[rainbow] [/rainbow]`              |Set/unset text to cycle through rainbow colours                                                                    |
|`[wobble]  [/wobble]`               |Set/unset text to wobble by rotating back and forth                                                                |
|`[pulse]   [/pulse]`                |Set/unset text to shrink and grow rhythmically                                                                     |
|`[wheel]   [/wheel]`                |Set/unset text to circulate around their origin                                                                 |
|`[<effect name>] [/<effect name>]`  |Set/unset an effect added by [`scribble_add_shader_effect()`](https://github.com/JujuAdams/scribble/wiki/(6.0.0)-scribble_add_shader_effect)|
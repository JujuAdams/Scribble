# Colour

&nbsp;

This page lists all the ways that you can colour text natively with Scribble. The features on this page are enumerated in reverse order of priority with the **highest priority** colourisation effects being at the **bottom** of the page e.g. `.rgb_lerp()` is applied after `[cycle]`.

There are, broadly, three types of functionality available in Scribble to adjust the colour of text. Firstly, there're **global functions** which affect the appearance of Scribble text everywhere. Then there's **text element methods** which can be used to adjust properties of a target text element. Finally, there are **command tags** which should be included in strings that you draw with Scribble and can control behaviour of individual characters.

?> Unless otherwise stated, colours are applied multiplicatively with the result of the prior stage.

&nbsp;

## Texture Colour

Text colour in Scribble starts with the source texture being used. GameMaker's standard native fonts are stored as pure white text, and generally speaking all text should be created in a pure white colour. If you're using spritefonts, or you're including sprites in your text, then any subsequent adjustments will be applied on top of the source texture colour.

?> Scribble can bake text borders into standard fonts and spritefonts. These are calculated as modifications to the source texture. As a result, colourisation is applied to the border as well as the basic text. SDF fonts have their own border method `.sdf_border()` that is **not** affected by colourisation.

&nbsp;

## Sprite Blending

**Global function.** Sprites, by default, are colour blended like normal text. You can turn this behaviour off by calling `scribble_blend_sprites_set()`. Even if colour blending is turned off for sprites, functionality that adjusts the alpha value of sprites will still function normally.

&nbsp;

## `.colour()` `.color()`

**Text Element Method:** `.colour(colour)` `.color(color)`

**Returns**: The text element

|Name      |Datatype         |Purpose                                                                                                                                                                                                                                   |
|----------|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`colour`  |integer or string|Basic text colour as either:<br>- standard GameMaker 24-bit BGR format<br>- name of a GameMaker colour constant<br>- name of a colour added to `__scribble_config_colours()`<br>- name of a colour added by calling `scribble_color_set()`|

**Text element method.** This method sets the basic text blend colour for the text element and can be overriden by `[#...]` `[d#...]` `[c_red]` etc.

!> This method is a *regenerator*. If the value is changed then the text element will be regenerated, potentially leading to degraded performance. Try not to change the colour of text using this method often.

&nbsp;

## `[c_red]` etc.

**Command tag.** Sets the colour of text based on a pre-configured colour, either a native GameMaker colour constant, added to `__scribble_config_colours()`, or added by calling `scribble_color_set()`. This command tag overrides colours set by `.colour()` `[# ...]` `[d# ...]`

&nbsp;

## `[#...]`

**Command tag.** Sets the colour of text based on a hexcode that follows the standard `#RRGGBB` layout. This command tag overrides colours set by `.colour()` `[d# ...]` `[c_red]` etc.

&nbsp;

## `[d#...]`

**Command tag.** Sets the colour of text based on a decimal value that follows GameMaker's native 24-bit BGR format. This command tag overrides colours set by `.colour()` `[d# ...]` `[c_red]` etc.

&nbsp;

## `[/colour]` `[/color]` `[/c]`

**Command tag.** Resets the colour of text to the value set by `.colour()` or, if `.colour()` has not been called for a particular text element, `SCRIBBLE_DEFAULT_COLOR`. This command tag overrides colours set by `[#... ]` `[d# ...]` `[c_red]` etc.

&nbsp;

## `[cycle]` `[/cycle]`

**Command tag.** Sets a colourful animated cycling colour effect. The cycle effect overrides colours set by `.colour()` `[# ...]` `[d# ...]` `[c_red]` etc. See the [animation](Animation) page for more information.

&nbsp;

## `[rainbow]` `[/rainbow]`

**Command tag.** Sets a colourful animated rainbow effect. The rainbow effect is [lerped](https://www.gamedev.net/tutorials/programming/general-and-gameplay-programming/a-brief-introduction-to-lerp-r4954/) with the current text colour based on the weight of the rainbow effect. See the [animation](Animation) page for more information.

&nbsp;

## `.rgb_gradient()`

**Text Element Method:** `.rgb_gradient(colour, mix)`

**Returns**: The text element

|Name    |Datatype         |Purpose                                                                                                                                                                                                                                   |
|--------|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`colour`|integer or string|Basic text colour as either:<br>- standard GameMaker 24-bit BGR format<br>- name of a GameMaker colour constant<br>- name of a colour added to `__scribble_config_colours()`<br>- name of a colour added by calling `scribble_color_set()`|
|`mix`   |number           |Blending factor for the gradient, from `0` (no gradient applied) to `1` (base blend colour of the bottom of each glyph is replaced with `colour`)                                                                                         |

**Text element method.** This function creates a top-to-bottom gradient effect. The colour specified in the method is used to affect the colour of the bottom of each glyph. The colour of the top of the glyph is determined by prior colourisation functionality (see above).

&nbsp;

## `.rgb_multiply()`

**Text Element Method:** `.rgb_multiply(colour)`

**Returns**: The text element

|Name         |Datatype         |Purpose                                                                                                                                                                                                                                   |
|-------------|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`colour`     |integer or string|Basic text colour as either:<br>- standard GameMaker 24-bit BGR format<br>- name of a GameMaker colour constant<br>- name of a colour added to `__scribble_config_colours()`<br>- name of a colour added by calling `scribble_color_set()`|

**Text element method.** This function multiplies the current text colour with the input colour. This is useful to tint text to indicate mouse-over state etc.

&nbsp;

## `.rgb_lerp()`

**Text Element Method:** `.rgb_lerp(colour, mix)`

**Returns**: The text element

|Name    |Datatype         |Purpose                                                                                                                                                                                                                                   |
|--------|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`colour`|integer or string|Basic text colour as either:<br>- standard GameMaker 24-bit BGR format<br>- name of a GameMaker colour constant<br>- name of a colour added to `__scribble_config_colours()`<br>- name of a colour added by calling `scribble_color_set()`|
|`mix`   |number           |Blending factor for the lerp, from `0` (no colour change) to `1` (text colour fully replaced by the specified lerp colour)                                                                                                                |

**Text element method.** This function [lerps](https://www.gamedev.net/tutorials/programming/general-and-gameplay-programming/a-brief-introduction-to-lerp-r4954/) between the current text colour and the target colour. This allows you to force the RGB channels of text to a certain colour whilst leaving the alpha channel unchanged. This is useful for e.g. flashing text in a particular colour.

&nbsp;

## `[alpha, ...]` `[/alpha]`

**Command tag.** `[alpha]` sets the alpha value for subsequent characters. `[/alpha]` resets the alpha value to `1.0`. The value set by `[alpha]` and `[/alpha]` is multiplied with values set by the `.alpha()` text element method (see below).

&nbsp;

## `.alpha(value)`

**Returns**: The text element

|Name    |Datatype|Purpose                                                                                 |
|--------|--------|----------------------------------------------------------------------------------------|
|`value` |number  |Alpha used when drawing text, `0.0` being fully transparent and `1.0` being fully opaque|

**Text element method.** This function multiplies the current text alpha value with the input alpha value. This is useful to fade text in and out in bulk. The value set by `.alpha()` is multiplied with values set by the `[alpha]` command tag (see above).

&nbsp;

## Premultiply Alpha

**Global function.** Set by using `scribble_premultiply_alpha_set()`. Calculated as `outputRGB = inputRGB * inputA`. This functionality is mostly used in combination with the extended blend mode `bm_one, bm_inv_src_alpha`.
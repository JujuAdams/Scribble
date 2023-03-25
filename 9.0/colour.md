# Colour

&nbsp;

## Texture Colour

Text colour in Scribble starts with the source texture being used. GameMaker's standard native fonts are stored as pure white text, and generally speaking all text should be created in a pure white colour. If you're using spritefonts (or you're including sprites in your text) take care when choosing your source colour.

?> Scribble can bake text borders into standard fonts and spritefonts. These are calculated as modifications to the source texture. As a result, colourisation is applied to the border as well as the basic text.

## Sprite Blending

Sprites, by default, are colour blended like normal text. You can turn this behaviour off by calling `scribble_blend_sprites_set()`. Even if colour blending is turned off for sprites, functionality that adjusts the alpha value of sprites will still function normally.

## `.colour()` `.color()`

Text element method. This method sets the basic text blend colour for the text element and can be overriden by `[#... ]` `[d# ...]` `[c_red]` etc.

!> This method is a *regenerator*. If the value is changed then the text element will be regenerated, potentially leading to degraded performance. Try not to change the colour of text using this method often.

## `[c_red]` etc.

Command tag. Sets the colour of text based on a pre-configured colour, either a native GameMaker colour constant, added by modifying `__scribble_config_colours()`, or added by calling `scribble_color_set()`. This command tag overrides colours set by `.colour()` `[# ...]` `[d# ...]`

## `[#...]`

Command tag. Sets the colour of text based on a hexcode that follows the standard `#RRGGBB` layout. This command tag overrides colours set by `.colour()` `[d# ...]` `[c_red]` etc.

## `[d#...]`

Command tag. Sets the colour of text based on a decimal value that follows GameMaker's native 24-bit BGR format. This command tag overrides colours set by `.colour()` `[d# ...]` `[c_red]` etc.

## `[/colour]` `[/color]` `[/c]`

Command tag. Resets the colour of text to the value set by `.colour()` or, if `.colour()` has not been called for a particular text element, `SCRIBBLE_DEFAULT_COLOR`. This command tag overrides colours set by `[#... ]` `[d# ...]` `[c_red]` etc.

## `[cycle]` `[/cycle]`

Command tag. Sets a colourful animated cycling colour effect. The cycle effect overrides colours set by `.colour()` `[# ...]` `[d# ...]` `[c_red]` etc. See the [animation](Animation) page for more information.

## `[rainbow]` `[/rainbow]`

Command tag. Sets a colourful animated rainbow effect. The rainbow effect is [lerped](https://www.gamedev.net/tutorials/programming/general-and-gameplay-programming/a-brief-introduction-to-lerp-r4954/) with the current text colour based on the weight of the rainbow effect. See the [animation](Animation) page for more information.

## `.rgb_gradient()`

Text element method. This function creates a top-to-bottom gradient effect by multiplying the current text colour with the input colour across the height of each character. The top of each character is left unchanged.

## `.rgb_blend()`

Text element method. This function multiplies the current text colour with the input colour. This is useful to tint text to indicate mouse-over state etc.

## `.rgb_lerp()`

Text element method. This function [lerps](https://www.gamedev.net/tutorials/programming/general-and-gameplay-programming/a-brief-introduction-to-lerp-r4954/) between the current text colour and the target colour. This allows you to force the RGB channel of text to a certain colour whilst leaving the alpha channel unchanged. This is useful for e.g. flashing text in a particular colour.

## `[alpha, ...]` `[/alpha]`

Command tag. `[alpha]` sets the alpha value for subsequent characters. `[/alpha]` resets the alpha value to `1.0`. The value set by `[alpha]` and `[/alpha]` is multiplied with values set by the `.alpha()` text element method (see below).

## `.alpha()`

Text element method. This function multiplies the current text alpha value with the input alpha value. This is useful to fade text in and out in bulk. The value set by `.alpha()` is multiplied with values set by the `[alpha]` command tag (see above).

## Premultiply Alpha

Set by using `scribble_premultiply_alpha_set()`. Calculated as `outputRGB = inputRGB * inputA`. This functionality is mostly used in combination with the extended blend mode `bm_one, bm_inv_src_alpha`.
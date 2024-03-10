# Easing

&nbsp;

## `.ease()`

**Typist Method:** `.ease(easeMethod, dx, dy, xscale, yscale, rotation, alphaDuration)`

**Returns**: `self`, the typist

|Name           |Datatype|Purpose                                                           |
|---------------|--------|------------------------------------------------------------------|
|`easeMethod`   |integer |A member of the `SCRIBBLE_EASE` enum. See below                   |
|`dx`           |number  |Starting x-coordinate of the glyph, relative to its final position|
|`dy`           |number  |Starting y-coordinate of the glyph, relative to its final position|
|`xscale`       |number  |Starting x-scale of the glyph, relative to its final scale        |
|`yscale`       |number  |Starting y-scale of the glyph, relative to its final scale        |
|`rotation`     |number  |Starting rotation of the glyph, relative to its final rotation    |
|`alphaDuration`|number  |Value from `0` to `1` (inclusive). See below                      |

The `alphaDuration` argument controls how glyphs fade in using alpha blending. A value of `0` will cause the glyph to "pop" into view with no fading, a value of `1` will cause the glyph to fade into view smoothly such that it reaches 100% alpha at the very end of the typewriter animation for the glyph.

?> Alpha fading is always linear and is not affected by the easing method chosen.

Scribble offers the following easing functions for typewriter behaviour. These are implemented using methods found in the widely used [easings.net](https://easings.net/) library.

|`SCRIBBLE_EASE` members|
|-----------------------|
|`.NONE`                |
|`.QUAD`                |
|`.QUART`               |
|`.SINE`                |
|`.CIRC`                |
|`.ELASTIC`             |
|`.LINEAR`              |
|`.CUBIC`               |
|`.QUINT`               |
|`.EXPO`                |
|`.BACK`                |
|`.BOUNCE`              |
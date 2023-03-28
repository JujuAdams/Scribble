# Easing

&nbsp;

## `.ease(easeMethod, dx, dy, xscale, yscale, rotation, alphaDuration)`

**Returns**: `self`, the typist

|Name           |Datatype|Purpose                                                           |
|---------------|--------|------------------------------------------------------------------|
|`easeMethod`   |integer |A member of the `SCRIBBLE_EASE` enum. See below                   |
|`dx`           |real    |Starting x-coordinate of the glyph, relative to its final position|
|`dy`           |real    |Starting y-coordinate of the glyph, relative to its final position|
|`xscale`       |real    |Starting x-scale of the glyph, relative to its final scale        |
|`yscale`       |real    |Starting y-scale of the glyph, relative to its final scale        |
|`rotation`     |real    |Starting rotation of the glyph, relative to its final rotation    |
|`alphaDuration`|real    |Value from `0` to `1` (inclusive). See below                      |

The `alphaDuration` argument controls how glyphs fade in using alpha blending. A value of `0` will cause the glyph to "pop" into view with no fading, a value of `1` will cause the glyph to fade into view smoothly such that it reaches 100% alpha at the very end of the typewriter animation for the glyph.

**N.B.** Alpha fading is always linear and is not affected by the easing method chosen.

Scribble offers the following easing functions for typewriter behaviour. These are implemented using methods found in the widely used [easings.net](https://easings.net/) library.

|`SCRIBBLE_EASE` members|                       |
|-----------------------|-----------------------|
|`.NONE`                |`.LINEAR`              |
|`.QUAD`                |`.CUBIC`               |
|`.QUART`               |`.QUINT`               |
|`.SINE`                |`.EXPO`                |
|`.CIRC`                |`.BACK`                |
|`.ELASTIC`             |`.BOUNCE`              |
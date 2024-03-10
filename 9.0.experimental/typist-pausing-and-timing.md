# Pausing and Timing

&nbsp;

## `[delay,<milliseconds>]`

**Command tag.**

Delay the typewriter by the given number of milliseconds. If no time value is given then the delay with defaults to [`SCRIBBLE_DEFAULT_DELAY_DURATION`](configuration).

&nbsp;

## `[pause]`

**Command tag.**

Pause the typewriter. The typewriter can be unpaused by calling [`.unpause()`](typist-methods?id=unpause).

&nbsp;

## `[speed,<factor>]`

**Command tag.**

Sets the speed of the typewriter by multiplying the value set by [`.in()`](typist-methods?id=inspeed-smoothness) by `<factor>`. A value of `2.0` will be twice as fast etc.

&nbsp;

## `[/speed]`

**Command tag.**

Resets the speed of the typewriter to the value set by [`.in()`](typist-methods?id=inspeed-smoothness).

&nbsp;

## `.pause()`

**Typist Method:** `.pause()`

**Returns**: `self`, the typist

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Pauses the typewriter effect.

&nbsp;

## `.unpause()`

**Typist Method:** `.unpause()`

**Returns**: `self`, the typist

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Unpauses the typewriter effect. This is helpful when combined with the [`[pause]` command tag](Text-Formatting) and [`.get_paused()`](scribble_typist#get_paused).

&nbsp;

## `.get_paused()`

**Typist Method:** `.get_paused()`

**Returns:** Boolean, whether the text element is currently paused due to encountering `[pause]` tag when typing out text

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |
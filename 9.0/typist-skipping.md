# Skipping

&nbsp;

## `.skip()`

**Returns**: `self`, the typist

|Name   |Datatype|Purpose                                                |
|-------|--------|-------------------------------------------------------|
|`state`|boolean |Whether the typist should skip the typewriter animation|

Skips the current typist animation, be it typing in or typing out. If text is typing in then all events on the current page will be executed in order of appearance. The skip behaviour also ignores per-character delay, and `[pause]` `[delay]` `[sync]` tags.

&nbsp;

## `.skip_to_pause(state)`

**Returns**: `self`, the typist

|Name   |Datatype|Purpose                                                |
|-------|--------|-------------------------------------------------------|
|`state`|boolean |Whether the typist should skip the typewriter animation|

As `.skip()` but the typist will wait at `[pause]` tags.

&nbsp;

## `.get_skip()`

**Returns**: Boolean, whether the typist is skipping typewriter animation

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;

## `.ignore_delay(state)`

**Returns**: `self`, the typist

|Name   |Datatype|Purpose                                                                |
|-------|--------|-----------------------------------------------------------------------|
|`state`|boolean |Whether the typist should ignore per-character delay and `[delay]` tags|

Unlike the `.skip()` method above, this behaviour will still play the typewriter animation.

&nbsp;

## `.get_ignore_delay()`

**Returns**: Boolean, whether the typist is ignoring per-character delay and `[delay]` tags

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |
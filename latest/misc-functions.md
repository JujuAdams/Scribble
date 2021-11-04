# Miscellaneous Functions

&nbsp;

### `scribble_flush_everything()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Frees all memory that Scribble text elements and text models are currently using. You will not normally need to call this function (Scribble automatically garbage collects resources that haven't been used recently) but it's occasionally useful when you need memory to be available immediately, or you want to make sure memory is being freed.

&nbsp;

&nbsp;

### `scribble_typewriter_add_event(name, function)`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                                                                                  |
|----------|--------|-----------------------------------------------------------------------------------------|
|`name`    |string  |Name of the new formatting tag to add e.g. `"portrait"` adds the tag `[portrait]` for use|
|`function`|function|Function to execute                                                                      |

Events are scripts that are executed during a [typewriter fade in](scribble()-Methods#typewriter_inspeed-smoothness) animation. As each character is revealed, Scribble will check if any events are present at that position in the text and, if so, Scribble will **immediately** execute that function. This can be used for many purposes including changing character portraits, starting movement of instances, starting weather effects, giving the player items, and so on.

It is possible to send parameters into an executed script from your text. **Parameters passed into event functions are only ever strings.** The syntax is similar to normal GameMaker functions; `[popup,0.1,0.2,hello world]` has three parameters: `0.1`, `0.2`, and `hello world`, all of which are strings.

&nbsp;

Event scripts are executed with two arguments:

|Argument|Name            |Purpose                                                               |
|--------|----------------|----------------------------------------------------------------------|
|0       |`element`       |Text element that caused the script to be executed|
|1       |`parameterArray`|An array of strings that contains the parameters defined in the text. See above|
|2       |`characterIndex`|Which character has been revealed (1-indexed)|

Your script should be formatted such that they can unpack parameters from the provided array. Scripts are executed in the scope of the instance that ran the [`.draw()`](scribble()-Methods#drawx-y) method, and in the associated GameMaker object event (typically the Draw event).

&nbsp;

Here's an example. Let's say we run this code in the Create event of an object:
```
scribble_typewriter_add_event("rumble", callbackRumble);
element = scribble("Here's some[rumble,0.2] rumble!");
element.typewriter_in(0.5, 0);
```
And then in the Draw event we run:
```
element.draw(x, y);
```
The object will draw the text `Here's some rumble!`, slowly revealling the text character by character. When the `e` of the word `some` is displayed, Scribble will automatically call the script `callbackRumble()`.

```
/// @description callbackRumble(element, parameterArray, characterIndex)
/// @param element
/// @param parameterArray
/// @param characterIndex

function callbackRumble(_element, _parameter_array, _character_index)
{
    var _amount = real(_parameter_array[0]);
    gamepad_set_vibration(global.current_gamepad, _amount, _amount);
}
```

Here, `callbackRumble()` will fetch the parameter from the array and use it to vibrate the player's gamepad. Given that the formatting tag was `[rumble,0.2]`, the function `gamepad_set_vibration()` will be given `0.2` as its input value.

&nbsp;

&nbsp;

### `scribble_typewriter_add_character_delay(character, delay)`

**Returns:** N/A (`undefined`)

|Name       |Datatype      |Purpose                                                                       |
|-----------|--------------|------------------------------------------------------------------------------|
|`character`|string/integer|The character to delay after. Can either be a string or a UTF-8 character code|
|`delay`    |real          |Delay time in milliseconds                                                    |

Automatically adds internal [delay tags](Text-Formatting) after specific characters. This is a global setting for all Scribble strings.

&nbsp;

&nbsp;

### `scribble_rgb_to_bgr(RGB)`

**Returns:** GM-native BGR colour

|Name |Datatype|Purpose                                        |
|-----|--------|-----------------------------------------------|
|`RGB`|integer |Industry standard (`#RRGGBB`) 24-bit RGB colour|

Converts an RGB colour code (the industry standard) to GameMaker's native BGR format.
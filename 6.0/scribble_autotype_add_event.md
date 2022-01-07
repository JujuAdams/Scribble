`scribble_autotype_add_event(name, script)`

**Returns:** N/A (`0`)

|Argument|Name        |Purpose                                                               |
|--------|------------|----------------------------------------------------------------------|
|0       |`name`      |Name of the new formatting tag to add e.g. `portrait` adds the tag `[portrait]` for use|
|1       |`script`    |Script asset to execute<br>N.B. This is the asset index, not a string|

Events are scripts that are executed during an [typewriter fade in](https://github.com/JujuAdams/scribble/wiki/(6.0.0)-scribble_autotype_fade_in) animation. As each character is revealed, Scribble will check if any events are present at that position in the text and, if so, Scribble will **immediately** execute that script. This can be used for many purposes including triggering sound effects, changing character portraits, starting movement of instances, starting weather effects, giving the player items, and so on.

It is possible to send parameters into an executed script from your text. **Parameters passed into event scripts are only ever strings.** The syntax is similar to normal GameMaker functions; `[popup,0.1,0.2,hello world]` has three parameters: `0.1`, `0.2`, and `hello world`, all of which are strings.

&nbsp;

Event scripts are executed with two arguments:

|Argument|Name            |Purpose                                                               |
|--------|----------------|----------------------------------------------------------------------|
|0       |`element`       |Text element that caused the script to be executed|
|1       |`parameterArray`|An array of strings that contains the parameters defined in the text. See above|

Your script should be formatted such that they can unpack parameters from the provided array. Scripts are executed in the scope of the instance that ran `scribble_draw()` and in the associated GameMaker object event (typically the Draw event).

&nbsp;

Here's an example. Let's say we run this code in the Create event of an object:
```
scribble_tw_add_event("rumble", callbackRumble);
element = scribble_draw("Here's some[rumble,0.2] rumble!);
scribble_tw_fade_in(element, 0.5);
```
And then in the Draw event we run:
```
scribble_draw(x, y, element);
```
The object will draw the text `Here's some rumble!`, slowly revealing the text character by character. When the `e` of the word `some` is displayed, Scribble will automatically call the script `callbackRumble()`.

```
/// @description callbackRumble(element, parameterArray)
/// @param element
/// @param parameterArray

var _element = argument0; //Not used but good practice to label it
var _parameter_array = argument1;

var _amount = real(_parameter_array[0]);
gamepad_set_vibration(global.current_gamepad, _amount, _amount);
```

Here, `callbackRumble()` will fetch the parameter from the array and use it to vibrate the player's gamepad. Given that the formatting tag was `[rumble,0.2]`, the function `gamepad_set_vibration()` will be given `0.2` as its input value.
# Events

&nbsp;

## `scribble_typists_add_event()`

**Global Function:** `scribble_typists_add_event(name, function)`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                                                                                  |
|----------|--------|-----------------------------------------------------------------------------------------|
|`name`    |string  |Name of the new formatting tag to add e.g. `"portrait"` adds the tag `[portrait]` for use|
|`function`|function|Function to execute                                                                      |

Events are scripts that are executed during a [typewriter fade in](scribble()-Methods#typewriter_inspeed-smoothness) animation. As each character is revealed, Scribble will check if any events are present at that position in the text and, if so, Scribble will **immediately** execute that function. This can be used for many purposes including changing character portraits, starting movement of instances, starting weather effects, giving the player items, and so on.

It is possible to send parameters into an executed script from your text. **Parameters passed into event functions are only ever strings.** The syntax is similar to normal GameMaker functions; `[popup,0.1,0.2,hello world]` has three parameters: `0.1`, `0.2`, and `hello world`, all of which are strings.

&nbsp;

Event scripts are executed with two arguments:

|Argument|Name            |Purpose                                                                        |
|--------|----------------|-------------------------------------------------------------------------------|
|0       |`element`       |Text element that caused the script to be executed                             |
|1       |`parameterArray`|An array of strings that contains the parameters defined in the text. See above|
|2       |`characterIndex`|Which character has been revealed (1-indexed)                                  |

Your script should be formatted such that they can unpack parameters from the provided array. Scripts are executed in the scope of the instance that ran the [`.draw()`](scribble-methods?id=drawx-y) method, and in the associated GameMaker object event (typically the Draw event).

&nbsp;

Here's an example. Let's say we run this code in the Create event of an object:
```
scribble_typists_add_event("rumble", callbackRumble);
element = scribble("Here's some[rumble,0.2] rumble!");
typist = scribble_typist();
typist.in(0.5, 0);
```
And then in the Draw event we run:
```
element.draw(x, y, typist);
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

## `[<event name>,<arg0>,<arg1>...]`

**Command tag.**

Trigger an event with the specified arguments. See `scribble_typist_add_event()` above.

&nbsp;

## `.get_events()`

**Typist Method:** `.get_events(position, [page])`

**Returns**: An array containing structs that describe typewrite events for the given character

|Name      |Datatype|Purpose                                                                    |
|----------|--------|---------------------------------------------------------------------------|
|`position`|integer |Character to get events for. See below for more details                    |
|`[page]`  |integer |The page to get events for. If not specified, the current page will be used|

To match GameMaker's native string behaviour for functions such as `string_copy()`, character positions are 1-indexed such that the character at position 1 in the string `"abc"` is `a`. Events are indexed such that an event placed immediately before a character has an index one less than the character. Events placed immediately after a character have an index equal to the character e.g. `"[event index 0]X[event index 1]"`.

The returned array contains structs that themselves contain the following member variables:

|Member Variable|Datatype        |Purpose                                                                                                  |
|---------------|----------------|---------------------------------------------------------------------------------------------------------|
|`.position`    |integer         |The character position for this event. This should (!) be the same as the index provided to get the event|
|`.name`        |string          |Name of the event e.g. `[ping, Hello!]` will set `.name` to `"ping"`                                     |
|`.data`        |array of strings|Contains the arguments provided for the event. Arguments will always be returned as strings e.g. `[move to, 20, -5]` will set `.data` to `["20", "-5"]`|
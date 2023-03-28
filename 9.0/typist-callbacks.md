# Callbacks

&nbsp;

## `.function_per_char(function)`

**Returns**: `self`, the typist

|Name      |Datatype|Purpose                                             |
|----------|--------|----------------------------------------------------|
|`function`|function|Function to execute when a new character is revealed|

`.function_per_char()` allows you to define a function that will be executed once per character as that character is revealed. The function is passed three arguments:
1. Text element that triggered the callback
2. Position of the character that was just revealed
3. Typist that triggered the callback

```
///Create
typist = scribble_typist();
typist.in(0.1, 3);
typist.function_per_char(function(_element, _position, _typist)
{
    //Example function to manually control text sound playback behaviour
    
    show_debug_message(_position);
    
    //Don't play any sound if the typist is set to skip typing
    if (!_typist.get_skip())
    {
        //Modulate our pitch on a sine curve
        var _pitch = lerp(0.8, 1.2, 0.5 + 0.5*dsin(36*_position));
        
        //Play a sound and then modify its pitch
        var _sound_instance = audio_play_sound(snd_switch, 1, false);
        audio_sound_pitch(_sound_instance, _pitch);
    }
});
```

&nbsp;

## `.function_on_complete(function)`

**Returns**: `self`, the typist

|Name      |Datatype|Purpose                                             |
|----------|--------|----------------------------------------------------|
|`function`|function|Function to execute when a typist finishes animating|

`.function_on_complete()` allows you to define a function that will be executed once when a typist finishes animating. The function is passed two arguments:
1. Text element that triggered the callback
2. Typist that triggered the callback

&nbsp;

## `.execution_scope(scope)`

**Returns**: `self`, the typist

|Name   |Datatype       |Purpose                                       |
|-------|---------------|----------------------------------------------|
|`scope`|instance/struct|The new scope to execution typist functions in|

By default, a typist will execute functions in the scope of the instance/struct that called the `.draw()` method for the text element associated with the typist. `.execution_scope()` overrides this execution scope, setting it to a specific instance or struct. If you'd like to reset the execution scope, use `undefined` as the method argument.

&nbsp;

## `.get_execution_scope()`

**Returns**: The execution scope for this typist's function, or `undefined`

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This method will, by default, return `undefined`. See `.execution_scope()` for details.
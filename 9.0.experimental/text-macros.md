# Text Macros

&nbsp;

## `scribble_add_macro()`

**Global Function:** `scribble_add_macro(name, function)`

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                                     |
|----------|--------|--------------------------------------------|
|`name`    |string  |Name of the macro command tag               |
|`function`|function|Function to execute when the macro is parsed|

Macros are a way to inject text into the Scribble parser as an input string is being parsed. The function attached to a macro must return a string. The macro tag, when parsed, will be replaced by the string returned by the function. Macro functions can take arguments in a similar fashion to custom typist events or formatting tags. Macro arguments are always passed to the function as strings.

The following example shows how to use a macro to insert a series of sprites into a string:
```gml
///Create
scribble_add_macro("coin_gen", function(_count)
{
    var _string = "";
    repeat(real(_count)) _string += "[spr_coin]";
    return _string;
});



///Draw
scribble("You find [coin_gen,4] lying on the floor!").draw(x, y);
```

The final string that Scribble will draw is equivalent to `"You find [spr_coin][spr_coin][spr_coin][spr_coin] lying on the floor!"` in this case.

!> If you read a variable in your macro function to control part of its behaviour, and that variable later changes whilst text is being drawn, there is no guarantee that Scribble will reflect that change. If you want to use a variable that can potentially change whilst text is being displayed, make sure you pass in that variable's value as a macro argument by modifying the input string.

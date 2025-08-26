// Feather disable all

function __scribble_error()
{
    var _string = "";
    
    var _i = 0
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_debug_message("Scribble Deluxe " + SCRIBBLE_VERSION + ": " + string_replace_all(_string, "\n", "\n          "));
    show_error(" \nScribble Deluxe " + SCRIBBLE_VERSION + ":\n" + _string + "\n ", true);
}
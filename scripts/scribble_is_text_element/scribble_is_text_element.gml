// Feather disable all
/// @param value

function scribble_is_text_element(_value)
{
    return (is_struct(_value) && (instanceof(_value) == "__scribble_class_element"));
}

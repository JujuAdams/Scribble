/// Returns the colour for the given colour name
/// If the colour doesn't exist, this function will return <undefined>
/// 
/// @param name

function scribble_color_get(_name)
{
    static _colours_struct = __scribble_get_state().__custom_colour_struct;
    return _colours_struct[$ _name];
}
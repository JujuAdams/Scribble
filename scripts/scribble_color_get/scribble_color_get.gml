/// Returns the colour for the given colour name
/// If the colour doesn't exist, this function will return <undefined>
/// 
/// @param name

function scribble_color_get(_name)
{
    static _colourDict = __scribble_config_colours();
    return _colourDict[$ _name];
}
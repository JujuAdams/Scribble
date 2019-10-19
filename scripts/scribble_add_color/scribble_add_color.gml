/// Adds a custom color for use as an in-line color definition for scribble_draw().
/// 
/// 
/// @param name                    String name of the color
/// @param color                   The color itself as a 24-bit integer
/// @param [colorIsGameMakerBGR]   Whether the color is in GameMaker's propriatery 24-bit BGR color format. Defaults to <false>.
/// 
/// All optional arguments accept <undefined> to indicate that the default value should be used.

if (argument_count == 2)
{
    return scribble_add_colour(argument[0], argument[1]);
}
else if (argument_count == 3)
{
    return scribble_add_colour(argument[0], argument[1], argument[2]);
}
else
{
    return undefined;
}
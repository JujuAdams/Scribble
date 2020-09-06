/// Fits text to a cubic Bezier curve
/// 
/// @param x1
/// @param y1
/// @param x2
/// @param y2
/// @param x3
/// @param y3
/// @param x4
/// @param y4

function scribble_set_bezier()
{
    if (argument_count <= 0)
    {
	    global.scribble_state_bezier_array = array_create(6, 0.0);
    }
    else if (argument_count == 8)
    {
	    global.scribble_state_bezier_array = [argument[2] - argument[0], argument[3] - argument[1],
                                              argument[4] - argument[0], argument[5] - argument[1],
                                              argument[6] - argument[0], argument[7] - argument[1]];
    }
    else
    {
        show_error("Scribble:\nWrong number of arguments (" + string(argument_count) + ") provided\nExpecting 0 or 8\n ", false);
    }
}
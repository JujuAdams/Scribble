/// Fits text to a cubic bezier curve
/// 
/// @param dx2
/// @param dy2
/// @param dx3
/// @param dy3
/// @param dx4
/// @param dy4

function scribble_set_bezier()
{
    if (argument_count <= 0)
    {
	    global.scribble_state_bezier_array = array_create(6, 0.0);
    }
    else if (argument_count == 6)
    {
	    global.scribble_state_bezier_array = [argument[0], argument[1],
                                              argument[2], argument[3],
                                              argument[4], argument[5]];
    }
    else
    {
        show_error("Scribble:\nWrong number of arguments (" + string(argument_count) + ") provided\nExpecting 0 or 6\n ", false);
    }
}
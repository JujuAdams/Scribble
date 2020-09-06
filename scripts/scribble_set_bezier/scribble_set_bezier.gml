/// Fits text to a cubic bezier curve
/// 
/// @param dx2
/// @param dy2
/// @param dx3
/// @param dy3
/// @param dx4
/// @param dy4

function scribble_set_bezier(_x2, _y2, _x3, _y3, _x4, _y4)
{
    if (argument_count <= 0)
    {
	    global.scribble_state_bezier_array = array_create(8, 0.0);
    }
    else if (argument_count == 6)
    {
	    global.scribble_state_bezier_array = [0, 0, _x2, _y2, _x3, _y3, _x4, _y4];
    }
    else
    {
        show_error("Scribble:\nWrong number of arguments (" + string(argument_count) + ") provided\nExpecting 0 or 6\n ", false);
    }
}
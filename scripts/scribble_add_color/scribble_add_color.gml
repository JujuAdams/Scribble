/// Adds a custom colour for use as an in-line colour definition for scribble_draw()
/// 
/// @param name                    String name of the colour
/// @param color                   The colour itself as a 24-bit integer
/// @param [colorIsGameMakerBGR]   Whether the colour is in GameMaker's propriatery 24-bit BGR colour format. Defaults to <false>.

function scribble_add_color()
{
	var _name   = argument[0];
	var _colour = argument[1];
	var _native = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : false;

	if (!variable_global_exists("__scribble_lcg"))
	{
	    show_error("Scribble:\nscribble_add_color() should be called after initialising Scribble.\n ", false);
	    exit;
	}

	if (!is_string(_name))
	{
	    show_error("Scribble:\nCustom colour names should be strings.\n ", false);
	    exit;
	}

	if (!is_real(_colour))
	{
	    show_error("Scribble:\nCustom colours should be specificed as 24-bit integers.\n ", false);
	    exit;
	}

	if (!_native)
	{
	    _colour = make_colour_rgb(colour_get_blue(_colour), colour_get_green(_colour), colour_get_red(_colour));
	}

	if (ds_map_exists(global.__scribble_effects, _name))
	{
	    show_debug_message("Scribble: WARNING! Colour name \"" + _name + "\" has already been defined as an effect" );
	    exit;
	}

	var _old_colour = global.__scribble_colours[? _name];
	if (is_real(_old_colour))
	{
	    show_debug_message("Scribble: WARNING! Overwriting colour \"" + _name + "\" (" + string(colour_get_red(_old_colour)) + "," + string(colour_get_green(_old_colour)) + "," + string(colour_get_blue(_old_colour)) + ", u32=" + string(_old_colour) + ")");
	}

	global.__scribble_colours[? _name ] = _colour;

	if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Added colour \"" + _name + "\" as " + string(colour_get_red(_colour)) + "," + string(colour_get_green(_colour)) + "," + string(colour_get_blue(_colour)) + ", u32=" + string(_colour));
}
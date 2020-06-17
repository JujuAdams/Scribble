/// Defines an effect name, allowing for behaviours to be set in scribble_draw() and passed to a shader
/// 
/// @param name    Effect name, as a string
/// @param index   Integer effect index, from 1 to SCRIBBLE_MAX_MAX_EFFECTS-1 inclusive

function scribble_add_shader_effect(_name, _index)
{
	if (!variable_global_exists("__scribble_lcg"))
	{
	    show_error("Scribble:\nscribble_add_effect() should be called after initialising Scribble\n ", false);
	    exit;
	}

	if (!is_string(_name))
	{
	    show_error("Scribble:\nCustom effect names should be strings\n ", false);
	    exit;
	}

	if (!is_real(_index) || (_index != floor(_index)) || (_index < 1))
	{
	    show_error("Scribble:\nCustom effect indexes should be an integer greater than 0 to const MAX_EFFECTS (in shd_scribble)\n(Index was \"" + string(_index) + "\")\n ", false);
	    exit;
	}

	if (ds_map_exists(global.__scribble_colours, _name))
	{
	    show_debug_message("Scribble: WARNING! Effect name \"" + _name + "\" has already been defined as a color");
	    exit;
	}

	if (ds_map_exists(global.__scribble_autotype_events, _name))
	{
	    show_debug_message("Scribble: WARNING! Effect name \"" + _name + "\" has already been defined as an event");
	    exit;
	}

	var _old_name = global.__scribble_effects[? _index];
	if (_old_name != undefined)
	{
	    show_debug_message("Scribble: WARNING! Overwriting effect index " + string(_index) + " \"" + _old_name + "\"");
	    ds_map_delete(global.__scribble_effects, _old_name);
	    ds_map_delete(global.__scribble_effects_slash, "/" + _old_name);
	}

	//Bidrectional lookup in the same map made possible because the datatypes are different
	global.__scribble_effects[? _index] = _name;
	global.__scribble_effects[? _name ] = _index;

	_name = "/" + _name;
	global.__scribble_effects_slash[? _index] = _name;
	global.__scribble_effects_slash[? _name ] = _index;

	if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Added effect name \"" + _name + "\" as index " + string(_index));
}
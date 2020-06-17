/// Sets Scribble's text wrapping state
/// 
/// @param min   Minimum line height for each line of text. Use a negative number (the default) for the height of a space character of the default font
/// @param max   Maximum line height for each line of text. Use a negative number (the default) for no limit
/// 
/// This script sets Scribble's draw state. All text drawn with scribble_draw() will use these settings until they're overwritten, either by
/// calling this script again or by calling scribble_reset() or scribble_set_state().
function scribble_set_line_height(argument0, argument1) {

	var _min = argument0;
	var _max = argument1;

	global.scribble_state_line_min_height = _min;
	global.scribble_state_line_max_height = _max;

	global.__scribble_cache_string = string(global.scribble_state_starting_font  ) + ":" +
	                                 string(global.scribble_state_starting_color ) + ":" +
	                                 string(global.scribble_state_starting_halign) + ":" +
	                                 string(global.scribble_state_line_min_height) + ":" +
	                                 string(global.scribble_state_line_max_height) + ":" +
	                                 string(global.scribble_state_max_width      ) + ":" +
	                                 string(global.scribble_state_max_height     ) + ":" +
	                                 string(global.scribble_state_character_wrap );


}

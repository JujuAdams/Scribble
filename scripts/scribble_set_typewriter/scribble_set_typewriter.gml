/// @param fadeOut
/// @param position
/// @param [type]
/// @param [executeEvents]

var _fade_out = argument[0];
var _position = argument[1];
var _type     = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : SCRIBBLE_TYPEWRITER_PER_CHARACTER;
var _execute  = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : false;

global.__scribble_next_tw_instance = id;
global.__scribble_next_tw_time     = get_timer();
global.__scribble_next_tw_fade_out = _fade_out;
global.__scribble_next_tw_position = _position;
global.__scribble_next_tw_type     = _type;
global.__scribble_next_tw_execute  = _execute;
/// Sets Scribble's scaling and rotation state.
/// 
/// 
/// @param xscale   The x scale of the text.
/// @param yscale   The y scale of the text.
/// @param angle    The rotation angle of the text.
/// 
/// Set any of these arguments to <undefined> to set as pass-through (usually inheriting SCRIBBLE_DEFAULT_XSCALE, SCRIBBLE_DEFAULT_YSCALE, and SCRIBBLE_DEFAULT_ANGLE).

global.__scribble_state_xscale = argument0;
global.__scribble_state_yscale = argument1;
global.__scribble_state_angle  = argument2;
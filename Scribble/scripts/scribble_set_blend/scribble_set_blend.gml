/// Sets Scribble's colour and alpha blending state.
/// 
/// 
/// @param colour   The blend colour used when drawing, applied multiplicatively.
/// @param alpha    The alpha used when drawing, 0 being fully transparent and 1 being fully opaque.
/// 
/// Set any of these arguments to <undefined> to set as pass-through (usually inheriting SCRIBBLE_DEFAULT_BLEND_COLOUR and SCRIBBLE_DEFAULT_ALPHA).

global.__scribble_state_colour = argument0;
global.__scribble_state_alpha  = argument1;

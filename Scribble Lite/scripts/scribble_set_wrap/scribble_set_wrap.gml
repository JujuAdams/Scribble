/// Sets Scribble's text wrapping state.
/// 
/// 
/// @param minLineHeight   The minimum line height for each line of text. Use a negative number (the default) for the height of a space character of the default font.
/// @param maxLineWidth    The maximum line width for each line of text. Use a negative number (the default) for no limit.
/// 
/// Set any of these arguments to <undefined> to set as pass-through (usually inheriting SCRIBBLE_DEFAULT_LINE_MIN_HEIGHT and SCRIBBLE_DEFAULT_MAX_WIDTH).

global.__scribble_state_line_min_height = argument0;
global.__scribble_state_max_width       = argument1;
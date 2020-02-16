/// Sets Scribble's text wrapping state.
/// 
/// 
/// @param minLineHeight    The minimum line height for each line of text. Use a negative number (the default) for the height of a space character of the default font
/// @param maxLineWidth     The maximum line width for each line of text. Use a negative number (the default) for no limit
/// @param maxLineHeight    The maximum line height for the whole textbox. Use a negative number (the default) for no limit
/// @param [characterWrap]  Whether to wrap text per character (rather than per word). Defaults to <false>. This is useful for very tight textboxes and some East Asian languages
/// 
/// 
/// This operates in a very similar way to GameMaker's native draw_text_ext() function ("sep" is minLineHeight and "w" is maxLineWidth).
/// 
/// This script "sets state". All text drawn with scribble_draw() will use these settings until they're overwritten,
/// either by calling this script again or by calling scribble_draw_reset() / scribble_draw_set_state().

global.scribble_state_line_min_height = argument[0];
global.scribble_state_max_width       = argument[1];
global.scribble_state_max_height      = argument[2];
global.scribble_state_character_wrap  = (argument_count > 3)? argument[3] : false;
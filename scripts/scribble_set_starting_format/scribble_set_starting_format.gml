/// @param fontName
/// @param fontColor
/// @param textHAlign

if (is_string(argument0))                         global.scribble_state_starting_font   = argument0;
if ((argument1 != undefined) && (argument1 >= 0)) global.scribble_state_starting_color  = argument1;
if ((argument2 != undefined) && (argument2 >= 0)) global.scribble_state_starting_halign = argument2;

global.__scribble_cache_string = string(global.scribble_state_starting_font  ) + ":" +
                                 string(global.scribble_state_starting_color ) + ":" +
                                 string(global.scribble_state_starting_halign) + ":" +
                                 string(global.scribble_state_line_min_height) + ":" +
                                 string(global.scribble_state_line_max_height) + ":" +
                                 string(global.scribble_state_max_width      ) + ":" +
                                 string(global.scribble_state_max_height     ) + ":" +
                                 string(global.scribble_state_character_wrap );
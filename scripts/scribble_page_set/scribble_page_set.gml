/// @param textElement       Text element to target. This element must have been created previously by scribble_draw()
/// @param page              Page to display, starting at 0 for the first page
/// @param [occuranceName]
/// 
/// This function is intended for use with scribble_page_get().
/// 
/// Please note that changing the page will reset any autotype animations i.e. those started by
/// scribble_autotype_fade_in() and scribble_autotype_fade_out().

var _scribble_array = argument[0];
var _page           = argument[1];
var _occurance_name = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : global.__scribble_default_occurance_name;

//Find our occurance data
var _occurance_map = _scribble_array[SCRIBBLE.OCCURANCES_MAP];
var _occurance_array = _occurance_map[? _occurance_name];

_page = clamp(_page, 0, _scribble_array[SCRIBBLE.PAGES]-1);
_occurance_array[@ __SCRIBBLE_OCCURANCE.PAGE] = _page;

scribble_autotype_fade_in(_scribble_array, undefined, undefined, undefined);

return _page;
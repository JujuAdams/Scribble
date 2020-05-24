/// Returns: Page that is currently being drawn, starting at 0 for the first page
/// @param textElement   Text element to target. This element must have been created previously by scribble_draw()
/// @param [occuranceName]
/// 
/// This function is intended for use with scribble_page_set().

var _scribble_array = argument[0];
var _occurance_name = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : global.__scribble_default_occurance_name;

//Find our occurance data
var _occurance_map = _scribble_array[SCRIBBLE.OCCURANCES_MAP];
var _occurance_array = _occurance_map[? _occurance_name];

return _occurance_array[__SCRIBBLE_OCCURANCE.PAGE];
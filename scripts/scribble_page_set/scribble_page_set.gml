/// @param element
/// @param page
/// @param [relative]

var _scribble_array = argument[0];
var _page           = argument[1];
var _relative       = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : false;

if (_relative) _page += _scribble_array[__SCRIBBLE.PAGE];

_page = clamp(_page, 0, _scribble_array[__SCRIBBLE.PAGES]-1);
_scribble_array[@ __SCRIBBLE.PAGE] = _page;

return _page;
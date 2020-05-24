/// @param element   Text element to target. This element must have been created previously by scribble_draw()
/// @param page      Page to display, starting at 0 for the first page
/// 
/// This function is intended for use with scribble_page_get().
/// 
/// Please note that changing the page will reset any autotype animations i.e. those started by
/// scribble_autotype_fade_in() and scribble_autotype_fade_out().

var _scribble_array = argument0;
var _page           = argument1;

_page = clamp(_page, 0, _scribble_array[SCRIBBLE.PAGES]-1);
_scribble_array[@ SCRIBBLE.AUTOTYPE_PAGE] = _page;

scribble_autotype_fade_in(_scribble_array, undefined, undefined, undefined);

return _page;
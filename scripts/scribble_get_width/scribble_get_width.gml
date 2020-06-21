/// Returns: The width of the text element's bounding box, ignoring rotation and scaling
/// @param string/textElement   The text to get the bounding box for. Alternatively, you can pass a text element into this script
/// @param [page]               Find the width of this specific page. Defaults to <undefined>, returning the maximal width of all pages

function scribble_get_width()
{
	var _scribble_array = argument[0];
    var _page           = (argument_count > 1)? argument[1] : undefined;
    
	_scribble_array = scribble_cache(_scribble_array);
	if (_scribble_array == undefined) return 0;
    
    if (_page != undefined)
    {
        var _pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
        var _page_array = _pages_array[_page];
        return _page_array[__SCRIBBLE_PAGE.WIDTH];
    }
    else
    {
        return _scribble_array[SCRIBBLE.WIDTH];
    }
}
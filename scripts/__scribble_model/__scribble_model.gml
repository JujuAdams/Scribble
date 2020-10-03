function __scribble_model(_element) constructor
{
    page_count = 0;
    
    draw = function(_x, _y)
    {
        
    }
    
    flush = function()
    {
        
    }
    
    /// @param page
    get_bbox = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
        {
            //Find our occurrence data
            var _occurrences_map = _scribble_array[SCRIBBLE.OCCURRENCES_MAP];
            var _occurrence_array = _occurrences_map[? _occurrence_name];
            
            //Find our page data
            var _element_pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
            var _page_array = _element_pages_array[_occurrence_array[__SCRIBBLE_OCCURRENCE.PAGE]];
            
            return { left:   _page_array[__SCRIBBLE_PAGE.MIN_X ],
                     top:    0,
                     right:  _page_array[__SCRIBBLE_PAGE.MAX_X ],
                     bottom: _page_array[__SCRIBBLE_PAGE.HEIGHT],
                 
                     width:  _page_array[__SCRIBBLE_PAGE.WIDTH ],
                     height: _page_array[__SCRIBBLE_PAGE.HEIGHT] };
        }
        else
        {
            return { left:   _scribble_array[SCRIBBLE.MIN_X ],
                     top:    0,
                     right:  _scribble_array[SCRIBBLE.MAX_X ],
                     bottom: _scribble_array[SCRIBBLE.HEIGHT],
                 
                     width:  _scribble_array[SCRIBBLE.WIDTH ],
                     height: _scribble_array[SCRIBBLE.HEIGHT] };
        }
    }
    
    /// @page
    get_width = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
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
    
    /// @page
    get_height = function(_page)
    {
        if ((_page != undefined) && (_page >= 0))
        {
            var _pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
            var _page_array = _pages_array[_page];
            return _page_array[__SCRIBBLE_PAGE.HEIGHT];
        }
        else
        {
            return _scribble_array[SCRIBBLE.HEIGHT];
        }
    }
    
    get_pages = function()
    {
        return page_count;
    }
}
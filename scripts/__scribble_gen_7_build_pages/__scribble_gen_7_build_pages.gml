// Feather disable all

function __scribble_gen_7_build_pages()
{
    static _generator_state = __scribble_system().__generator_state;
    
    with(_generator_state)
    {
        var _line_grid             = __line_grid;
        var _modelMaxHeight        = __modelMaxHeight;
        var _line_count            = __line_count;
        var _line_height           = __line_height;
        var _line_spacing_add      = __line_spacing_add;
        var _line_spacing_multiply = __line_spacing_multiply;
    }
    
    var _trimText = (__layoutType == SCRIBBLE_LAYOUT_TRIM);
    var _skippingLines = false;
    
    var _simulated_model_height = (__layoutType == SCRIBBLE_LAYOUT_FIT)? infinity : (_modelMaxHeight / __fitScale);
    
    var _page_data = __NewPage(0);
    var _firstLine = true;
    var _line_y = 0;
    
    var _line = 0;
    repeat(_line_count)
    {
        var _starts_manual_page = _line_grid[# _line, __SCRIBBLE_GEN_LINE_STARTS_MANUAL_PAGE];
        var _overflow = _line_y + _line_height >= _simulated_model_height;
        
        if (_starts_manual_page || (_overflow && (not _firstLine) && (not _skippingLines)))
        {
            if (not _skippingLines)
            {
                _page_data.__Finalize(_line-1);
            }
            
            _firstLine = true;
            _line_grid[# _line, __SCRIBBLE_GEN_LINE_Y] = 0;
            _line_y = _line_spacing_add + _line_height*_line_spacing_multiply;
            
            if (_starts_manual_page)
            {
                _skippingLines = false;
            }
            else if (_overflow && _trimText)
            {
                _skippingLines = true;
            }
            
            if (not _skippingLines)
            {
                _page_data = __NewPage(_line);
            }
        }
        else
        {
            _firstLine = false;
            _line_grid[# _line, __SCRIBBLE_GEN_LINE_Y] = _line_y;
            _line_y += _line_spacing_add + _line_height*_line_spacing_multiply;
        }
        
        ++_line;
    }
    
    if (not _skippingLines)
    {
        _page_data.__Finalize(_line-1);
    }
}

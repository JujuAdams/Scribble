function __scribble_gen_8_build_pages()
{
    var _glyph_grid   = global.__scribble_glyph_grid;
    var _word_grid    = global.__scribble_word_grid;
    var _line_grid    = global.__scribble_line_grid;
    var _control_grid = global.__scribble_control_grid; //This grid is cleared at the bottom of __scribble_generate_model()
    
    with(global.__scribble_generator_state)
    {
        var _element          = element;
        var _model_max_height = model_max_height;
        var _line_count       = line_count;
        var _control_count    = control_count;
        var _wrap_no_pages    = _element.wrap_no_pages;
    }
    
    var _simulated_model_height = _wrap_no_pages? infinity : (_model_max_height / fit_scale);
    
    var _model_height = 0;
    
    // Set up a new page and set its starting glyph
    // We'll set the ending glyph in the loop below
    var _page_data = __new_page();
    _page_data.__line_start  = 0;
    _page_data.__glyph_start = _word_grid[# _line_grid[# 0, __SCRIBBLE_PARSER_LINE.WORD_START], __SCRIBBLE_PARSER_WORD.GLYPH_START];
    
    var _page_start_line = 0;
    var _line_y = 0;
    var _i = 0;
    repeat(_line_count)
    {
        var _line_height        = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.HEIGHT            ];
        var _starts_manual_page = _line_grid[# _i, __SCRIBBLE_PARSER_LINE.STARTS_MANUAL_PAGE];
        
        if (!_starts_manual_page && (_line_y + _line_height < _simulated_model_height))
        {
            _line_grid[# _i, __SCRIBBLE_PARSER_LINE.Y] = _line_y;
            _line_y += _line_height;
        }
        else
        {
            __SCRIBBLE_GEN_PAGE_POP;
            
            // Create a new page
            _page_data = __new_page();
            _page_data.__line_start  = _i;
            _page_data.__glyph_start = _word_grid[# _line_grid[# _i, __SCRIBBLE_PARSER_LINE.WORD_START], __SCRIBBLE_PARSER_WORD.GLYPH_START];
            
            _page_start_line = _i;
            _line_grid[# _i, __SCRIBBLE_PARSER_LINE.Y] = 0;
            _line_y = _line_height;
        }
        
        if (_line_y > _model_height) _model_height = _line_y;
        ++_i;
    }
    
    __SCRIBBLE_GEN_PAGE_POP;
    
    height = _model_height;
}
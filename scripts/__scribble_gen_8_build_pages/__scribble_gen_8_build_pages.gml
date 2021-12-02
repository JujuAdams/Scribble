#macro __SCRIBBLE_GEN_PAGE_POP  var _page_end_line = _i - 1;\
                                _page_data.__line_end  = _page_end_line;\
                                _page_data.__glyph_end = _word_grid[# _line_grid[# _page_end_line, __SCRIBBLE_GEN_LINE.WORD_END], __SCRIBBLE_GEN_WORD.GLYPH_END];\
                                _page_data.__width     = ds_grid_get_max(_line_grid, _page_start_line, __SCRIBBLE_GEN_LINE.WIDTH, _page_end_line, __SCRIBBLE_GEN_LINE.WIDTH);\
                                _page_data.__height    = _line_y;\
                                ;\// Set up the character indexes for the page, relative to the character index of the first glyph on the page
                                var _page_anim_start = _glyph_grid[# _page_data.__glyph_start, __SCRIBBLE_GEN_GLYPH.ANIMATION_INDEX];\
                                ds_grid_add_region(_glyph_grid, _page_data.__glyph_start, __SCRIBBLE_GEN_GLYPH.ANIMATION_INDEX, _page_data.__glyph_end, __SCRIBBLE_GEN_GLYPH.ANIMATION_INDEX, -_page_anim_start);\
                                ;\// Set the character count for the page too
                                _page_data.__character_count = 1 + _glyph_grid[# _page_data.__glyph_end, __SCRIBBLE_GEN_GLYPH.ANIMATION_INDEX];



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
    _page_data.__glyph_start = _word_grid[# _line_grid[# 0, __SCRIBBLE_GEN_LINE.WORD_START], __SCRIBBLE_GEN_WORD.GLYPH_START];
    
    var _page_start_line = 0;
    var _line_y = 0;
    var _i = 0;
    repeat(_line_count)
    {
        var _line_height        = _line_grid[# _i, __SCRIBBLE_GEN_LINE.HEIGHT            ];
        var _starts_manual_page = _line_grid[# _i, __SCRIBBLE_GEN_LINE.STARTS_MANUAL_PAGE];
        
        if (!_starts_manual_page && (_line_y + _line_height < _simulated_model_height))
        {
            _line_grid[# _i, __SCRIBBLE_GEN_LINE.Y] = _line_y;
            _line_y += _line_height;
        }
        else
        {
            __SCRIBBLE_GEN_PAGE_POP;
            
            // Create a new page
            _page_data = __new_page();
            _page_data.__line_start  = _i;
            _page_data.__glyph_start = _word_grid[# _line_grid[# _i, __SCRIBBLE_GEN_LINE.WORD_START], __SCRIBBLE_GEN_WORD.GLYPH_START];
            
            _page_start_line = _i;
            _line_grid[# _i, __SCRIBBLE_GEN_LINE.Y] = 0;
            _line_y = _line_height;
        }
        
        if (_line_y > _model_height) _model_height = _line_y;
        ++_i;
    }
    
    __SCRIBBLE_GEN_PAGE_POP;
    
    height = _model_height;
}
#macro __SCRIBBLE_GEN_PAGE_POP  var _page_end_line = _i - 1;\
                                _page_data.__line_end    = _page_end_line;\
                                _page_data.__line_count  = 1 + _page_data.__line_end - _page_data.__line_start;\
                                _page_data.__glyph_end   = _word_grid[# _line_grid[# _page_end_line, __SCRIBBLE_GEN_LINE.WORD_END], __SCRIBBLE_GEN_WORD.GLYPH_END];\
                                _page_data.__glyph_count = 1 + _page_data.__glyph_end - _page_data.__glyph_start;\
                                _page_data.__width       = ds_grid_get_max(_line_grid, _page_start_line, __SCRIBBLE_GEN_LINE.WIDTH, _page_end_line, __SCRIBBLE_GEN_LINE.WIDTH);\
                                _page_data.__height      = _line_y;\
                                _page_data.__min_y       = (__valign == fa_middle)? -_line_y/2 : ((__valign == fa_bottom)? -_line_y :       0);\
                                _page_data.__max_y       = (__valign == fa_middle)?  _line_y/2 : ((__valign == fa_bottom)?        0 : _line_y);\
                                ;\// Set up the character indexes for the page, relative to the character index of the first glyph on the page
                                var _page_anim_start = _glyph_grid[# _page_data.__glyph_start, __SCRIBBLE_GEN_GLYPH.ANIMATION_INDEX];\
                                ds_grid_add_region(_glyph_grid, _page_data.__glyph_start, __SCRIBBLE_GEN_GLYPH.ANIMATION_INDEX, _page_data.__glyph_end, __SCRIBBLE_GEN_GLYPH.ANIMATION_INDEX, -_page_anim_start);\
                                ;\// Set the character count for the page too
                                _page_data.__character_count = 1 + _glyph_grid[# _page_data.__glyph_end, __SCRIBBLE_GEN_GLYPH.ANIMATION_INDEX];



function __scribble_gen_7_build_pages()
{
    var _glyph_grid = global.__scribble_glyph_grid;
    var _word_grid  = global.__scribble_word_grid;
    var _line_grid  = global.__scribble_line_grid;
    
    with(global.__scribble_generator_state)
    {
        var _element               = __element;
        var _model_max_height      = __model_max_height;
        var _line_count            = __line_count;
        var _wrap_no_pages         = _element.__wrap_no_pages;
        var _line_spacing_add      = __line_spacing_add;
        var _line_spacing_multiply = __line_spacing_multiply;
    }
    
    var _simulated_model_height = _wrap_no_pages? infinity : (_model_max_height / __fit_scale);
    
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
        
        if (!_starts_manual_page && ((_line_y + _line_height < _simulated_model_height) || (_page_start_line >= _i)))
        {
            _line_grid[# _i, __SCRIBBLE_GEN_LINE.Y] = _line_y;
            if (_line_y + _line_height > _model_height) _model_height = _line_y + _line_height;
            if (_i < _line_count-1) _line_y += _line_spacing_add + _line_height*_line_spacing_multiply;
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
            if (_line_y + _line_height > _model_height) _model_height = _line_y + _line_height;
            _line_y = _line_spacing_add + _line_height*_line_spacing_multiply;
        }
        
        ++_i;
    }
    
    __SCRIBBLE_GEN_PAGE_POP;
    
    __height = _model_height;
}

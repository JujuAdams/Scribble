#macro __SCRIBBLE_GEN_PAGE_POP  _model_height = max(_model_height, _line_max_y);\
                                var _page_end_line = _i - 1;\
                                _page_data.__line_end    = _page_end_line;\
                                _page_data.__line_count  = 1 + _page_data.__line_end - _page_data.__line_start;\
                                _page_data.__glyph_end   = _word_grid[# _line_grid[# _page_end_line, __SCRIBBLE_GEN_LINE.__WORD_END], __SCRIBBLE_GEN_WORD.__GLYPH_END];\
                                _page_data.__glyph_count = 1 + _page_data.__glyph_end - _page_data.__glyph_start;\
                                _page_data.__width       = ds_grid_get_max(_line_grid, _page_start_line, __SCRIBBLE_GEN_LINE.__WIDTH, _page_end_line, __SCRIBBLE_GEN_LINE.__WIDTH);\
                                _page_data.__height      = _line_max_y;\
                                _page_data.__y_offset    = _page_y;\
                                _page_data.__scroll_y    = _page_y;\
                                if (__valign == fa_middle)\
                                {\
                                    _page_data.__min_y = -(_line_max_y div 2);\
                                    _page_data.__max_y =  (_line_max_y div 2);\
                                }\
                                else if (__valign == fa_bottom)\
                                {\
                                    _page_data.__min_y = -_line_max_y;\
                                    _page_data.__max_y = 0;\
                                }\
                                else\ //fa_top
                                {\
                                    _page_data.__min_y = 0;\
                                    _page_data.__max_y = _line_max_y;\
                                }\
                                ;\// Set up the character indexes for the page, relative to the character index of the first glyph on the page
                                var _page_anim_start = _glyph_grid[# _page_data.__glyph_start, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX];\
                                var _page_anim_end   = _glyph_grid[# _page_data.__glyph_end,   __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX];\
                                _page_data.__character_count = 1 + _page_anim_end - _page_anim_start;\
                                ds_grid_add_region(_glyph_grid, _page_data.__glyph_start, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, _page_data.__glyph_end, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, -_page_anim_start);



function __scribble_gen_7_build_pages()
{
    static _generator_state = __scribble_get_generator_state();
    with(_generator_state)
    {
        var _glyph_grid            = __glyph_grid;
        var _word_grid             = __word_grid;
        var _line_grid             = __line_grid;
        var _element               = __element;
        var _model_max_height      = __model_max_height;
        var _line_count            = __line_count;
        var _line_spacing_add      = __line_spacing_add;
        var _line_spacing_multiply = __line_spacing_multiply;
        var _page_separation       = __element.__layout_page_separation;
    }
    
    var _max_break_height = (_element.__layout_type == __SCRIBBLE_LAYOUT.__WRAP_SPLIT)? (_model_max_height / __fit_scale) : infinity;
    var _simulated_model_height = _max_break_height;
    var _model_height = 0;
    
    // Set up a new page and set its starting glyph
    // We'll set the ending glyph in the loop below
    var _page_data = __new_page();
    _page_data.__line_start  = 0;
    _page_data.__glyph_start = _word_grid[# _line_grid[# 0, __SCRIBBLE_GEN_LINE.__WORD_START], __SCRIBBLE_GEN_WORD.__GLYPH_START];
    var _page_line_array = _page_data.__line_array;
    
    var _page_start_line = 0;
    var _page_y = 0;
    var _line_y = 0;
    var _line_max_y = 0;
    var _manual_start_page = true;
    var _i = 0;
    repeat(_line_count)
    {
        var _line_height        = _line_grid[# _i, __SCRIBBLE_GEN_LINE.__HEIGHT            ];
        var _starts_manual_page = _line_grid[# _i, __SCRIBBLE_GEN_LINE.__STARTS_MANUAL_PAGE];
        
        if (!_starts_manual_page && ((_line_y + _line_height < _simulated_model_height) || (_page_start_line >= _i)))
        {
            _line_grid[# _i, __SCRIBBLE_GEN_LINE.__Y] = _line_y;
            
            array_push(_page_line_array, {
                __y:      _line_y,
                __height: _line_height,
            });
            
            _line_max_y = _line_y + _line_height;
            _line_y += _line_spacing_add + _line_height*_line_spacing_multiply;
        }
        else
        {
            __SCRIBBLE_GEN_PAGE_POP;
            if (!_manual_start_page) _page_data.__scroll_y -= _model_max_height - _page_data.__height;
            
            _page_y += _starts_manual_page? (max(_line_y, _model_max_height) + _page_separation) : _line_y;
            _manual_start_page = _starts_manual_page;
            
            // Create a new page
            _page_data = __new_page();
            _page_data.__line_start  = _i;
            _page_data.__glyph_start = _word_grid[# _line_grid[# _i, __SCRIBBLE_GEN_LINE.__WORD_START], __SCRIBBLE_GEN_WORD.__GLYPH_START];
            _page_line_array = _page_data.__line_array;
            
            _page_start_line = _i;
            _line_grid[# _i, __SCRIBBLE_GEN_LINE.__Y] = 0;
            
            array_push(_page_line_array, {
                __y:      _line_y,
                __height: _line_height,
            });
            
            _line_max_y = _line_height;
            _line_y = _line_spacing_add + _line_height*_line_spacing_multiply;
        }
        
        ++_i;
    }
    
    __SCRIBBLE_GEN_PAGE_POP;
    if (!_manual_start_page) _page_data.__scroll_y -= _model_max_height - _page_data.__height;
    
    __height = _model_height;
}

// Feather disable all
#macro __SCRIBBLE_GEN_PAGE_POP  _model_height = max(_model_height, _line_max_y);\
                                var _page_end_line = _i - 1;\
                                _page_data.__line_end    = _page_end_line;\
                                _page_data.__line_count  = 1 + _page_data.__line_end - _page_data.__line_start;\
                                _page_data.__glyph_end   = _word_grid[# _line_grid[# _page_end_line, __SCRIBBLE_GEN_LINE.__WORD_END], __SCRIBBLE_GEN_WORD.__GLYPH_END];\
                                _page_data.__glyph_count = 1 + _page_data.__glyph_end - _page_data.__glyph_start;\
                                _page_data.__width       = ds_grid_get_max(_line_grid, _page_start_line, __SCRIBBLE_GEN_LINE.__WIDTH, _page_end_line, __SCRIBBLE_GEN_LINE.__WIDTH);\
                                _page_data.__height      = _line_max_y;\
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
                                if (_randomize_animation)\
                                {\
                                    array_resize(_animation_randomize_array, _page_data.__character_count);\
                                    var _i = 0;\
                                    repeat(_page_data.__character_count)\
                                    {\
                                        _animation_randomize_array[@ _i] = _i;\
                                        ++_i;\
                                    }\
                                    array_sort(_animation_randomize_array, function() { return choose(-1, 1); });\
                                    var _glyph_start = _page_data.__glyph_start;\
                                    var _i = 0;\
                                    repeat(_page_data.__character_count)\
                                    {\
                                        _glyph_grid[# _glyph_start + _i, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX] = _animation_randomize_array[_i];\
                                        ++_i;\
                                    }\
                                }\
                                else\
                                {\
                                    ds_grid_add_region(_glyph_grid, _page_data.__glyph_start, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, _page_data.__glyph_end, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX, -_page_anim_start);\
                                }



function __scribble_gen_7_build_pages()
{
    static _generator_state = __scribble_initialize().__generator_state;
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
        var _randomize_animation   = __element.__randomize_animation;
    }
    
    static _animation_randomize_array = [];
    
    var _wrap_no_pages = _element.__wrap_no_pages;
    
    var _simulated_model_height = _wrap_no_pages? infinity : (_model_max_height / __fit_scale);
    
    var _model_height = 0;
    
    // Set up a new page and set its starting glyph
    // We'll set the ending glyph in the loop below
    var _page_data = __new_page();
    _page_data.__line_start  = 0;
    _page_data.__glyph_start = _word_grid[# _line_grid[# 0, __SCRIBBLE_GEN_LINE.__WORD_START], __SCRIBBLE_GEN_WORD.__GLYPH_START];
    
    var _page_start_line = 0;
    var _line_y = 0;
    var _line_max_y = 0;
    var _i = 0;
    repeat(_line_count)
    {
        var _line_height        = _line_grid[# _i, __SCRIBBLE_GEN_LINE.__HEIGHT            ];
        var _starts_manual_page = _line_grid[# _i, __SCRIBBLE_GEN_LINE.__STARTS_MANUAL_PAGE];
        
        if (!_starts_manual_page && ((_line_y + _line_height < _simulated_model_height) || (_page_start_line >= _i)))
        {
            _line_grid[# _i, __SCRIBBLE_GEN_LINE.__Y] = _line_y;
            _line_max_y = _line_y + _line_height;
            _line_y += _line_spacing_add + _line_height*_line_spacing_multiply;
        }
        else
        {
            __SCRIBBLE_GEN_PAGE_POP;
            
            // Create a new page
            _page_data = __new_page();
            _page_data.__line_start  = _i;
            _page_data.__glyph_start = _word_grid[# _line_grid[# _i, __SCRIBBLE_GEN_LINE.__WORD_START], __SCRIBBLE_GEN_WORD.__GLYPH_START];
            
            _page_start_line = _i;
            _line_grid[# _i, __SCRIBBLE_GEN_LINE.__Y] = 0;
            _line_max_y = _line_height;
            _line_y = _line_spacing_add + _line_height*_line_spacing_multiply;
        }
        
        ++_i;
    }
    
    __SCRIBBLE_GEN_PAGE_POP;
    
    __height = _model_height;
}

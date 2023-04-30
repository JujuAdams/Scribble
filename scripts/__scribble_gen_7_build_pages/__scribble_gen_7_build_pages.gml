#macro __SCRIBBLE_GEN_PAGE_POP  ++_page;\
                                _model_height = max(_model_height, _line_page_y_max);\
                                ;\
                                var _page_end_line = _i - 1;\
                                _page_data.__line_end    = _page_end_line;\
                                _page_data.__line_count  = 1 + _page_data.__line_end - _page_data.__line_start;\
                                _page_data.__glyph_end   = _word_grid[# _line_grid[# _page_end_line, __SCRIBBLE_GEN_LINE.__WORD_END], __SCRIBBLE_GEN_WORD.__GLYPH_END];\
                                _page_data.__glyph_count = 1 + _page_data.__glyph_end - _page_data.__glyph_start;\
                                _page_data.__width       = ds_grid_get_max(_line_grid, _page_start_line, __SCRIBBLE_GEN_LINE.__WIDTH, _page_end_line, __SCRIBBLE_GEN_LINE.__WIDTH);\
                                _page_data.__height      = _line_page_y_max;\
                                ;\
                                _page_data.__manual_start = _page_manual_start;\
                                _page_data.__model_y      = _page_model_y;\
                                _page_data.__scroll_y     = _page_model_y;\
                                ;\
                                if (__valign == fa_middle)\
                                {\
                                    _page_data.__min_y = _page_model_y - (_line_page_y_max div 2);\
                                    _page_data.__max_y = _page_model_y + (_line_page_y_max div 2);\
                                }\
                                else if (__valign == fa_bottom)\
                                {\
                                    _page_data.__min_y = _page_model_y - _line_page_y_max;\
                                    _page_data.__max_y = _page_model_y;\
                                }\
                                else\ //fa_top
                                {\
                                    _page_data.__min_y = _page_model_y;\
                                    _page_data.__max_y = _page_model_y + _line_page_y_max;\
                                }\
                                ;\
                                ;\// Set up the character indexes for the page, relative to the character index of the first glyph on the page
                                var _page_anim_start = _glyph_grid[# _page_data.__glyph_start, __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX];\
                                var _page_anim_end   = _glyph_grid[# _page_data.__glyph_end,   __SCRIBBLE_GEN_GLYPH.__ANIMATION_INDEX];\
                                _page_data.__character_count = 1 + _page_anim_end - _page_anim_start;



#macro __SCRIBBLE_GEN_PAGE_ADD_LINE  var _line_data = {\
                                         __line:        _i,\
                                         __page:        _page,\
                                         __page_y:      _line_page_y,\
                                         __model_y:     _line_model_y,\
                                         __height:      _line_height,\
                                         __glyph_start: _word_grid[# _line_grid[# _i, __SCRIBBLE_GEN_LINE.__WORD_START], __SCRIBBLE_GEN_WORD.__GLYPH_START],\
                                         __glyph_end:   _word_grid[# _line_grid[# _i, __SCRIBBLE_GEN_LINE.__WORD_END  ], __SCRIBBLE_GEN_WORD.__GLYPH_END  ],\
                                     };\
                                     ;\
                                     array_push(__lines_array, _line_data);\
                                     array_push(_page_line_array, _line_data);



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
    var _model_height = 0;
    
    // Set up a new page and set its starting glyph
    // We'll set the ending glyph in the loop below
    var _page_data = __new_page();
    _page_data.__line_start  = 0;
    _page_data.__glyph_start = _word_grid[# _line_grid[# 0, __SCRIBBLE_GEN_LINE.__WORD_START], __SCRIBBLE_GEN_WORD.__GLYPH_START];
    var _page_line_array = _page_data.__line_array;
    
    var _page              = 0;
    var _page_start_line   = 0;
    var _page_model_y      = 0;
    var _line_model_y      = 0;
    var _line_page_y       = 0;
    var _line_page_y_max   = 0;
    var _page_manual_start = true;
    
    var _i = 0;
    repeat(_line_count)
    {
        var _line_height      = _line_grid[# _i, __SCRIBBLE_GEN_LINE.__HEIGHT            ];
        var _manual_linebreak = _line_grid[# _i, __SCRIBBLE_GEN_LINE.__STARTS_MANUAL_PAGE];
        
        if (!_manual_linebreak && ((_line_page_y + _line_height < _max_break_height) || (_page_start_line >= _i)))
        {
            _line_grid[# _i, __SCRIBBLE_GEN_LINE.__Y] = _line_model_y;
            
            __SCRIBBLE_GEN_PAGE_ADD_LINE
            
            _line_page_y_max = _line_page_y + _line_height;
            
            var _shift     = _line_spacing_add + _line_height*_line_spacing_multiply;
            _line_model_y += _shift;
            _line_page_y  += _shift;
        }
        else
        {
            __SCRIBBLE_GEN_PAGE_POP
            
            if (_manual_linebreak)
            {
                //If we found [/page] then force then ensure the previous page has space at the end to fill up the entire layout height
                //We also include a page separator here too
                _page_model_y += max(_line_page_y, _max_break_height) + _page_separation;
                _line_model_y  = _page_model_y;
            }
            else
            {
                //Otherwise start the next page immediately underneath the previous page
                _page_model_y = _line_model_y;
            }
            
            _line_page_y = 0;
            
            // Create a new page
            _page_data = __new_page();
            _page_data.__line_start  = _i;
            _page_data.__glyph_start = _word_grid[# _line_grid[# _i, __SCRIBBLE_GEN_LINE.__WORD_START], __SCRIBBLE_GEN_WORD.__GLYPH_START];
            _page_line_array = _page_data.__line_array;
            
            _page_start_line = _i
            _page_manual_start = _manual_linebreak;
            
            _line_grid[# _i, __SCRIBBLE_GEN_LINE.__Y] = _line_model_y;
            
            __SCRIBBLE_GEN_PAGE_ADD_LINE
            
            _line_page_y_max = _line_height;
            
            var _shift     = _line_spacing_add + _line_height*_line_spacing_multiply;
            _line_model_y += _shift;
            _line_page_y   = _shift;
        }
        
        ++_i;
    }
    
    __SCRIBBLE_GEN_PAGE_POP
    
    if (!SCRIBBLE_ALWAYS_USE_FULL_PAGE_HEIGHT && (array_length(__pages_array) > 1))
    {
        var _prev_page_data = undefined;
        var _page_data      = __pages_array[0];
        
        var _i = 1;
        repeat(array_length(__pages_array)-1)
        {
            _prev_page_data = _page_data;
            var _page_data = __pages_array[_i];
            if (!_prev_page_data.__manual_start && _page_data.__manual_start) _prev_page_data.__scroll_y -= _max_break_height - _prev_page_data.__height;
            ++_i;
        }
    }
    
    __height = _model_height;
}

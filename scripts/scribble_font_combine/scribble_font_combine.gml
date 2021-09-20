/// @param newFontName
/// @param font1
/// @param font2
/// @param [font3]...

function scribble_font_combine()
{
    var _new_font_name = argument[0];
    
    if (!is_string(_new_font_name))
    {
        __scribble_error("Fonts should be specified using their name as a string.\n(Input was an invalid datatype)");
        exit;
    }
    
    if (ds_map_exists(global.__scribble_font_data, _new_font_name))
    {
        __scribble_error("New font name \"", _new_font_name, "\" already exists as a font");
        exit;
    }
    
    //We always use a glyph map so we don't need to pre-parse the fonts
    var _glyph_map = ds_map_create();
    
    var _font_data = new __scribble_class_font(_new_font_name, "runtime");
    _font_data.glyphs_map = _glyph_map;

    //Go go backwards so fonts listed first take priority (character from later fonts get overwritten)
    
    //Collect MSDF state for the fonts
    var _any_msdf            = false;
    var _all_msdf            = true;
    var _msdf_range          = undefined;
    var _msdf_range_conflict = false;
    var _f = 1;
    repeat(argument_count - 1)
    {
        var _src_font_name = argument[_f];
        var _src_font_data = global.__scribble_font_data[? _src_font_name];
        
        if ((_src_font_data.type == "msdf") || (_src_font_data.type == "runtime msdf"))
        {
            _any_msdf = true;
            if ((_msdf_range != undefined) && (_msdf_range != _src_font_data.msdf_range)) _msdf_range_conflict = true;
            _msdf_range = _src_font_data.msdf_range;
        }
        else
        {
            _all_msdf = false;
        }
        
        ++_f;
    }
    
    //Handle MSDF behaviour
    if (_any_msdf)
    {
        if (!_all_msdf) __scribble_error("Cannot combine MSDF fonts with other types of fonts");
        if (_msdf_range_conflict) __scribble_error("Combined MSDF fonts must have the same pxrange");
        _font_data.type = "runtime msdf";
        _font_data.msdf_range = _msdf_range;
    }
    
    //Calculate font min/max y-values so we can apply a y-offset per font so everything is centred
    var _combined_y_min = 0;
    var _combined_y_max = 0;
    var _font_y_min_array = array_create(argument_count - 1, 0);
    var _font_y_max_array = array_create(argument_count - 1, 0);
    
    //Go go backwards so fonts listed first take priority (character from later fonts get overwritten)
    var _f = 1;
    repeat(argument_count - 1)
    {
        var _source_font_name = argument[_f];
        
        if (!is_string(_source_font_name))
        {
            __scribble_error("Fonts should be specified using their name as a string.\n(Input was an invalid datatype)");
            exit;
        }
        
        if (!ds_map_exists(global.__scribble_font_data, _source_font_name))
        {
            __scribble_error("Font \"", _source_font_name, "\" doesn't exist. Ensure input fonts exist before combining them together");
            exit;
        }
        
        var _src_font_data = global.__scribble_font_data[? _source_font_name];
    
        var _font_min = 0;
        var _font_max = 0;
    
        //Unpack source glyphs into an intermediate array
        var _src_glyphs_map = _src_font_data.glyphs_map;
        if (_src_glyphs_map != undefined)
        {
            var _src_glyphs_array = array_create(ds_map_size(_src_glyphs_map));
        
            var _key = ds_map_find_first(_src_glyphs_map);
            repeat(ds_map_size(_src_glyphs_map))
            {
                var _glyph_data = _src_glyphs_map[? _key];
                var _y_min = _glyph_data[SCRIBBLE_GLYPH.Y_OFFSET];
                var _y_max = _glyph_data[SCRIBBLE_GLYPH.HEIGHT  ] + _y_min;
            
                _font_min = min(_font_min, _y_min);
                _font_max = max(_font_max, _y_max);
            
                _key = ds_map_find_next(_src_glyphs_map, _key);
            }
        }
        else
        {
            var _src_glyphs_array = _src_font_data.glyphs_array;
            var _c = 0;
            repeat(array_length(_src_glyphs_array))
            {
                var _glyph_data = _src_glyphs_array[_c];
            
                if (is_array(_glyph_data))
                {
                    var _y_min = _glyph_data[SCRIBBLE_GLYPH.Y_OFFSET];
                    var _y_max = _glyph_data[SCRIBBLE_GLYPH.HEIGHT  ] + _y_min;
                
                    _font_min = min(_font_min, _y_min);
                    _font_max = max(_font_max, _y_max);
                }
            
                ++_c;
            }
        }
    
        _font_y_min_array[@ _f] = _font_min;
        _font_y_max_array[@ _f] = _font_max;
        var _combined_y_min = min(_combined_y_min, _font_min);
        var _combined_y_max = max(_combined_y_max, _font_max);
    
        ++_f;
    }
    
    //Go go backwards so fonts listed first take priority (characters from later fonts get overwritten)
    var _f = argument_count - 1;
    repeat(argument_count - 1)
    {
        var _source_font_name = argument[_f];
        var _src_font_data = global.__scribble_font_data[? _source_font_name];
    
        //Calculate the y-offset for glyphs in this font
        var _y_offset = (_combined_y_min - _font_y_min_array[_f]) + ((_combined_y_max - _combined_y_min) - (_font_y_max_array[_f] - _font_y_min_array[_f])) div 2;
    
        //Unpack source glyphs into an intermediate array
        var _src_glyphs_map = _src_font_data.glyphs_map;
        if (_src_glyphs_map != undefined)
        {
            var _src_glyphs_array = array_create(ds_map_size(_src_glyphs_map));
        
            var _i = 0;
            var _key = ds_map_find_first(_src_glyphs_map);
            repeat(ds_map_size(_src_glyphs_map))
            {
                _src_glyphs_array[@ _i] = _src_glyphs_map[? _key];
                ++_i;
                _key = ds_map_find_next(_src_glyphs_map, _key);
            }
        }
        else
        {
            var _src_glyphs_array = _src_font_data.glyphs_array;
        }
    
        //Add this font's glyph data to the combined font
        var _c = 0;
        repeat(array_length(_src_glyphs_array))
        {
            var _src_array = _src_glyphs_array[_c];
        
            //If we have glyph data then copy it across to the combined font
            if (is_array(_src_array))
            {
                var _dst_array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
                array_copy(_dst_array, 0, _src_array, 0, SCRIBBLE_GLYPH.__SIZE);
            
                _dst_array[@ SCRIBBLE_GLYPH.Y_OFFSET] += _y_offset;
            
                _glyph_map[? _dst_array[SCRIBBLE_GLYPH.INDEX]] = _dst_array;
            }
        
            ++_c;
        }
    
        --_f;
    }
}
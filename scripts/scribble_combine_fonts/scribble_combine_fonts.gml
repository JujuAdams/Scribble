/// @param newFontName
/// @param font1
/// @param font2
/// @param [font3]...

function scribble_combine_fonts()
{
    var _new_font_name = argument[0];
    
    if (!is_string(_new_font_name))
    {
        show_error("Scribble:\nFonts should be specified using their name as a string.\n(Input was an invalid datatype)\n ", false);
        exit;
    }
    
    if (ds_map_exists(global.__scribble_font_data, _new_font_name))
    {
        show_error("Scribble:\nNew font name \"" + string(_new_font_name) + "\" already exists as a font\n ", true);
        exit;
    }
    
    //We always use a glyph map so we don't need to pre-parse the fonts
    var _glyph_map = ds_map_create();

    var _font_data = array_create(__SCRIBBLE_FONT.__SIZE);
    _font_data[@ __SCRIBBLE_FONT.NAME        ] = _new_font_name;
    _font_data[@ __SCRIBBLE_FONT.PATH        ] = undefined;
    _font_data[@ __SCRIBBLE_FONT.TYPE        ] = __SCRIBBLE_FONT_TYPE.RUNTIME;
    _font_data[@ __SCRIBBLE_FONT.FAMILY_NAME ] = undefined;
    _font_data[@ __SCRIBBLE_FONT.GLYPHS_MAP  ] = _glyph_map;
    _font_data[@ __SCRIBBLE_FONT.GLYPHS_ARRAY] = undefined;
    _font_data[@ __SCRIBBLE_FONT.GLYPH_MIN   ] = undefined;
    _font_data[@ __SCRIBBLE_FONT.GLYPH_MAX   ] = undefined;
    _font_data[@ __SCRIBBLE_FONT.SPACE_WIDTH ] = undefined;
    _font_data[@ __SCRIBBLE_FONT.MAPSTRING   ] = undefined;
    _font_data[@ __SCRIBBLE_FONT.SEPARATION  ] = undefined;
    global.__scribble_font_data[? _new_font_name] = _font_data;

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
            show_error("Scribble:\nFonts should be specified using their name as a string.\n(Input was an invalid datatype)\n ", false);
            exit;
        }
        
        if (!ds_map_exists(global.__scribble_font_data, _source_font_name))
        {
            show_error("Scribble:\nFont \"" + string(_source_font_name) + "\" doesn't exist. Ensure input fonts exist before combining them together\n ", true);
            exit;
        }
        
        var _src_font_array = global.__scribble_font_data[? _source_font_name];
    
        var _font_min = 0;
        var _font_max = 0;
    
        //Unpack source glyphs into an intermediate array
        var _src_glyphs_map = _src_font_array[__SCRIBBLE_FONT.GLYPHS_MAP];
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
        	var _src_glyphs_array = _src_font_array[__SCRIBBLE_FONT.GLYPHS_ARRAY];
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
    
    //Go go backwards so fonts listed first take priority (character from later fonts get overwritten)
    var _f = argument_count - 1;
    repeat(argument_count - 1)
    {
        var _source_font_name = argument[_f];
        var _src_font_array = global.__scribble_font_data[? _source_font_name];
    
        //Calculate the y-offset for glyphs in this font
        var _y_offset = (_combined_y_min - _font_y_min_array[_f]) + ((_combined_y_max - _combined_y_min) - (_font_y_max_array[_f] - _font_y_min_array[_f])) div 2;
    
        //Unpack source glyphs into an intermediate array
        var _src_glyphs_map = _src_font_array[__SCRIBBLE_FONT.GLYPHS_MAP];
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
        	var _src_glyphs_array = _src_font_array[__SCRIBBLE_FONT.GLYPHS_ARRAY];
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
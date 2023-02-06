function __scribble_font_add_parse_from_file(_file_name, _font, _font_glyph_array)
{
    
    
    
    
    
    
    
    
    
    
    
    
    __scribble_error("See __scribble_font_add_from_file()");
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //We set this font as active so string_height will return the height of this font's glyphs.
    var _old_font = draw_get_font();
    draw_set_font(_font);
    var _name = font_get_name(_font);
    
    static _font_data_map = __scribble_get_font_data_map();
    if (ds_map_exists(_font_data_map, _name))
    {
        __scribble_trace("Warning! A font for \"", _name, "\" has already been added. Destroying the old font and creating a new one");
        _font_data_map[? _name].__destroy();
    }
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Adding \"", _file_name, "\" as standard font");
    
    var _scribble_state = __scribble_get_state();
    if (_scribble_state.__default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_file_name) + "\"");
        _scribble_state.__default_font = _file_name;
    }
    
    try
    {
        var _global_glyph_bidi_map = __scribble_get_glyph_data().__bidi_map;
        
        //Get font info from the runtime
        var _font_info = font_get_info(_font);
        var _info_glyphs_dict = _font_info.glyphs;
        
        var _size = array_length(_font_glyph_array);
        
        var _info_glyphs_array = array_create(array_length(_font_glyph_array));
        var _i = 0;
        repeat(_size)
        {
            var _glyph = _font_glyph_array[_i];
            var _struct = _info_glyphs_dict[$ _glyph] ?? _info_glyphs_dict[$ " "];
            _info_glyphs_array[@ _i] = _struct;
            ++_i;
        }
        
        if (SCRIBBLE_VERBOSE) __scribble_trace("Processing font \"" + _file_name + "\"");
        
        var _asset       = asset_get_index(_name);
        var _texture     = font_get_texture(_asset);
        var _texture_uvs = font_get_uvs(_asset);
        
        var _texture_tw = texture_get_texel_width(_texture);
        var _texture_th = texture_get_texel_height(_texture);
        var _texture_w  = (_texture_uvs[2] - _texture_uvs[0])/_texture_tw; //texture_get_width(_texture);
        var _texture_h  = (_texture_uvs[3] - _texture_uvs[1])/_texture_th; //texture_get_height(_texture);
        var _texture_l  = round(_texture_uvs[0] / _texture_tw);
        var _texture_t  = round(_texture_uvs[1] / _texture_th);
        
        if (SCRIBBLE_VERBOSE)
        {
            __scribble_trace("  \"" + _file_name +"\""
                             + ", asset = " + string(_asset)
                             + ", texture = " + string(_texture)
                             + ", top-left = " + string(_texture_l) + "," + string(_texture_t)
                             + ", size = " + string(_texture_w) + " x " + string(_texture_h)
                             + ", texel = " + string_format(_texture_tw, 1, 10) + " x " + string_format(_texture_th, 1, 10)
                             + ", uvs = " + string_format(_texture_uvs[0], 1, 10) + "," + string_format(_texture_uvs[1], 1, 10)
                             + " -> " + string_format(_texture_uvs[2], 1, 10) + "," + string_format(_texture_uvs[3], 1, 10));
        }
        
        var _font_data = new __scribble_class_font(_name, _size, false);
        var _font_glyphs_map      = _font_data.__glyphs_map;
        var _font_glyph_data_grid = _font_data.__glyph_data_grid;
        var _font_kerning_map     = _font_data.__kerning_map;
        
        var _i = 0;
        repeat(_size)
        {
            var _glyph_dict = _info_glyphs_array[_i];
            
            var _unicode = _glyph_dict.char;

            if ((_unicode >= 0x3000) && (_unicode <= 0x303F)) //CJK Symbols and Punctuation
            {
                var _bidi = __SCRIBBLE_BIDI.SYMBOL;
            }
            else if ((_unicode >= 0x3040) && (_unicode <= 0x30FF)) //Hiragana and Katakana
            {
                var _bidi = __SCRIBBLE_BIDI.ISOLATED_CJK;
            }
            else if ((_unicode >= 0x4E00) && (_unicode <= 0x9FFF)) //CJK Unified ideographs block
            {
                var _bidi = __SCRIBBLE_BIDI.ISOLATED_CJK;
            }
            else if ((_unicode >= 0xFF00) && (_unicode <= 0xFF0F)) //Fullwidth symbols
            {
                var _bidi = __SCRIBBLE_BIDI.SYMBOL;
            }
            else if ((_unicode >= 0xFF1A) && (_unicode <= 0xFF1F)) //More fullwidth symbols
            {
                var _bidi = __SCRIBBLE_BIDI.SYMBOL;
            }
            else if ((_unicode >= 0xFF5B) && (_unicode <= 0xFF64)) //Yet more fullwidth symbols
            {
                var _bidi = __SCRIBBLE_BIDI.SYMBOL;
            }
            else
            {
                var _bidi = _global_glyph_bidi_map[? _unicode];
                if (_bidi == undefined) _bidi = __SCRIBBLE_BIDI.L2R;
            }
            
            if (SCRIBBLE_USE_KERNING)
            {
                var _kerning_array = _glyph_dict[$ "kerning"];
                if (is_array(_kerning_array))
                {
                    var _j = 0;
                    repeat(array_length(_kerning_array) div 2)
                    {
                        var _first = _kerning_array[_j];
                        if (_first > 0) _font_kerning_map[? ((_unicode & 0xFFFF) << 16) | (_first & 0xFFFF)] = _kerning_array[_j+1];
                        _j += 2;
                    }
                }
            }
            
            var _char = chr(_unicode);
            
            //FIXME - Workaround for HTML5 in GMS2.3.7.606 and above
            //        This doesn't seem to be needed in 2022.3.0.497
            var _x = _glyph_dict[$ "x"];
            var _y = _glyph_dict[$ "y"];
            var _w = _glyph_dict.w;
            var _h = _glyph_dict.h;
        
            //Using this, we get the height in pixels as it is on the texture page.
            var _alt_h = string_height(_char);
            
            if (__SCRIBBLE_ON_WEB)
            {
                _x += _texture_l;
                _y += _texture_t;
            }
            
            var _u0 = _x*_texture_tw;
            var _v0 = _y*_texture_th;
            var _u1 = _u0 + _w*_texture_tw;
            var _v1 = _v0 + _alt_h*_texture_th;
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.CHARACTER           ] = _char;
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.UNICODE             ] = _unicode;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.BIDI                ] = _bidi;
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.X_OFFSET            ] = _glyph_dict.offset;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.Y_OFFSET            ] = 0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.WIDTH               ] = _w;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.HEIGHT              ] = _alt_h;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_HEIGHT         ] = _alt_h;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SEPARATION          ] = _glyph_dict.shift;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.LEFT_OFFSET         ] = -_glyph_dict.offset;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_SCALE          ] = 1;
                                                         
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.TEXTURE             ] = _texture;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U0                  ] = _u0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U1                  ] = _u1;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V0                  ] = _v0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V1                  ] = _v1;
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SDF_PXRANGE         ] = undefined;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SDF_THICKNESS_OFFSET] = undefined;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.BILINEAR            ] = undefined;
            
            _font_glyphs_map[? _unicode] = _i;
            
            ++_i;
        }
        //Copied this from the __scribble_font_add_msdf_from_project, as I was not getting a space character.	
        //Guarantee we have a space character
        var _space_index = _font_glyphs_map[? 32];
        if (_space_index == undefined)
        {
            __scribble_trace("Warning! Space character not found in character set for font added via font_add() \"", _file_name, "\"");
        
            var _i = _size;
            ds_grid_resize(_font_glyph_data_grid, _i+1, SCRIBBLE_GLYPH.__SIZE);
            _font_glyphs_map[? 32] = _i;
        
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.CHARACTER           ] = " ";
        
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.UNICODE             ] = 0x20;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.BIDI                ] = __SCRIBBLE_BIDI.WHITESPACE;
        
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.X_OFFSET            ] = 0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.Y_OFFSET            ] = 0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.WIDTH               ] = 0.5*_font_info.size;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.HEIGHT              ] = _font_info.size;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_HEIGHT         ] = _font_info.size;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SEPARATION          ] = 0.5*_font_info.size;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.LEFT_OFFSET         ] = 0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_SCALE          ] = 1;
        
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.TEXTURE             ] = _texture;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U0                  ] = 0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V0                  ] = 0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U1                  ] = 0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V1                  ] = 0;
        
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SDF_PXRANGE         ] = undefined;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SDF_THICKNESS_OFFSET] = undefined;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.BILINEAR            ] = undefined;
        }
    
        //And guarantee the space character is set up
        var _space_index = _font_glyphs_map[? 32];
        _font_glyph_data_grid[# _space_index, SCRIBBLE_GLYPH.WIDTH ] = _font_glyph_data_grid[# _space_index, SCRIBBLE_GLYPH.SEPARATION];
        _font_glyph_data_grid[# _space_index, SCRIBBLE_GLYPH.HEIGHT] = _font_info.size;
    
        _font_data.__calculate_font_height();
        //Reset the font.
        draw_set_font(_old_font)
    }
    catch(_error)
    {
        __scribble_trace(_error);
        __scribble_error("There was an error whilst reading \"", _file_name, "\"\nPlease ensure that the font file exists before using font_add()\nIf this issue persists, please report it");
    }
}
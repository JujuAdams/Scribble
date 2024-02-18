/// @param font

function __scribble_font_add_from_project(_font)
{
    var _name = font_get_name(_font);
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Adding \"", _name, "\" as standard font");
    
    var _scribble_state = __scribble_get_state();
    if (_scribble_state.__default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_name) + "\"");
        _scribble_state.__default_font = _name;
    }
    
    try
    {
        //Get font info from the runtime
        var _font_info = font_get_info(_font);
        var _info_glyphs_dict = _font_info.glyphs;
        
        var _info_glyph_names = variable_struct_get_names(_info_glyphs_dict);
        var _size = array_length(_info_glyph_names);
        
        var _info_glyphs_array = array_create(array_length(_info_glyph_names));
        var _i = 0;
        repeat(_size)
        {
            var _glyph = _info_glyph_names[_i];
            var _struct = _info_glyphs_dict[$ _glyph];
            _info_glyphs_array[@ _i] = _struct;
            ++_i;
        }
        
        if (SCRIBBLE_VERBOSE) __scribble_trace("Processing font \"" + _name + "\"");
        
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
            __scribble_trace("  \"" + _name +"\""
                             + ", asset = " + string(_asset)
                             + ", texture = " + string(_texture)
                             + ", top-left = " + string(_texture_l) + "," + string(_texture_t)
                             + ", size = " + string(_texture_w) + " x " + string(_texture_h)
                             + ", texel = " + string_format(_texture_tw, 1, 10) + " x " + string_format(_texture_th, 1, 10)
                             + ", uvs = " + string_format(_texture_uvs[0], 1, 10) + "," + string_format(_texture_uvs[1], 1, 10)
                             + " -> " + string_format(_texture_uvs[2], 1, 10) + "," + string_format(_texture_uvs[3], 1, 10));
        }
        
        var _sdf = _font_info.sdfEnabled;
        
        var _font_data = new __scribble_class_font(_name, _name, _size);
        _font_data.__type_standard = not _sdf;
        _font_data.__type_sdf      = _sdf;
        
        //Set material properties
        var _material = _font_data.__material;
        _material.__set_texture(_texture);
        _material.__sdf = _sdf;
        if (_sdf) _material.__sdf_spread = 2*_font_info.sdfSpread;
        
        //Set the bilinear filtering state for the font after we set other properties
        _font_data.__set_bilinear(undefined);
        
        var _font_glyphs_map      = _font_data.__glyphs_map;
        var _font_glyph_data_grid = _font_data.__glyph_data_grid;
        var _font_kerning_map     = _font_data.__kerning_map;
        
        var _is_krutidev = __scribble_asset_is_krutidev(_font, asset_font);
        if (_is_krutidev) _font_data.__is_krutidev = true;
        
        var _i = 0;
        repeat(_size)
        {
            var _glyph_dict = _info_glyphs_array[_i];
            
            var _unicode = _glyph_dict.char;
            var _bidi = __scribble_unicode_get_bidi(_unicode);
            
            if (_is_krutidev)
            {
                __SCRIBBLE_KRUTIDEV_HACK
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
            
            var _x = _glyph_dict.x;
            var _y = _glyph_dict.y;
            var _w = _glyph_dict.w;
            var _h = _glyph_dict.h;
            
            var _u0 = _x*_texture_tw;
            var _v0 = _y*_texture_th;
            var _u1 = _u0 + _w*_texture_tw;
            var _v1 = _v0 + _h*_texture_th;
            
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__CHARACTER  ] = _char;
            
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__UNICODE    ] = _unicode;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__BIDI       ] = _bidi;
            
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__X_OFFSET   ] = _glyph_dict.offset;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__Y_OFFSET   ] = 0;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__WIDTH      ] = _w;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__HEIGHT     ] = _h;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__FONT_HEIGHT] = _h;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__SEPARATION ] = _glyph_dict.shift;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__LEFT_OFFSET] = -_glyph_dict.offset;
            
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__MATERIAL   ] = _material;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__U0         ] = _u0;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__U1         ] = _u1;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__V0         ] = _v0;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__V1         ] = _v1;
            
            _font_glyphs_map[? _unicode] = _i;
            
            ++_i;
        }
        
        _font_data.__calculate_font_height();
        
        //Check to see if this texture has been resized during compile
        var _GM_scaling = _font_info.size / _font_glyph_data_grid[# _font_glyphs_map[? 32], __SCRIBBLE_GLYPH.__HEIGHT];
        if (_GM_scaling > 1)
        {
            __scribble_trace("Warning! Font \"", _name, "\" may have been scaled during compilation (font size = ", _font_info.size, ", space height = ", _font_glyph_data_grid[# _font_glyphs_map[? 32], __SCRIBBLE_GLYPH.__HEIGHT], ", scaling factor = ", _GM_scaling, "). Check that the font is rendering correctly. If it is not, try setting SCRIBBLE_ATTEMPT_FONT_SCALING_FIX to <false>");
            if (SCRIBBLE_ATTEMPT_FONT_SCALING_FIX) scribble_font_set_scale(_name, ceil(_GM_scaling));
        }
    }
    catch(_error)
    {
        __scribble_trace(_error);
        __scribble_error("There was an error whilst reading \"", _name, "\"\nPlease reimport the font into GameMaker and reset character ranges\nIf this issue persists, please report it");
    }
}
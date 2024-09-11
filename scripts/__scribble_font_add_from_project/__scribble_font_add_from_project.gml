// Feather disable all
/// @param font

function __scribble_font_add_from_project(_font)
{
    var _name = font_get_name(_font);
    
    static _font_data_map = __scribble_initialize().__font_data_map;
    if (ds_map_exists(_font_data_map, _name))
    {
        __scribble_trace("Warning! A font for \"", _name, "\" has already been added. Destroying the old font and creating a new one");
        _font_data_map[? _name].__destroy();
    }
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Adding \"", _name, "\" as standard font");
    
    var _scribble_state = __scribble_initialize().__state;
    if (_scribble_state.__default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_name) + "\"");
        _scribble_state.__default_font = _name;
    }
    
    try
    {
        var _is_krutidev = __scribble_asset_is_krutidev(_font, asset_font);
        var _global_glyph_bidi_map = __scribble_initialize().__glyph_data.__bidi_map;
        
        //Get font info from the runtime
        var _font_info = font_get_info(_font);
        var _info_glyphs_dict = _font_info.glyphs;
        var _ascender_offset = SCRIBBLE_USE_ASCENDER_OFFSET? _font_info.ascenderOffset : 0;
        
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
        
        var _sdf = _font_info.sdfEnabled;
        
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
        
        if (_sdf)
        {
            var _sdf_pxrange          = 2*_font_info.sdfSpread;
            var _sdf_thickness_offset = 0;
            var _sdf_offset           = -_sdf_pxrange;
            var _sdf_height_offset    = -_sdf_pxrange + 2; //idk why
        }
        else
        {
            var _sdf_pxrange          = undefined;
            var _sdf_thickness_offset = undefined;
            var _sdf_offset           = 0;
            var _sdf_height_offset    = 0;
        }
        
        var _font_data = new __scribble_class_font(_name, _size, _sdf? __SCRIBBLE_FONT_TYPE.__SDF : __SCRIBBLE_FONT_TYPE.__RASTER);
        _font_data.__sdf_pxrange          = _sdf_pxrange;
        _font_data.__sdf_thickness_offset = _sdf_thickness_offset;
        
        var _font_glyphs_map      = _font_data.__glyphs_map;
        var _font_glyph_data_grid = _font_data.__glyph_data_grid;
        var _font_kerning_map     = _font_data.__kerning_map;
        if (_is_krutidev) _font_data.__is_krutidev = true;
        
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
            
            if (_is_krutidev)
            {
                if (_bidi != __SCRIBBLE_BIDI.WHITESPACE)
                {
                    _bidi = __SCRIBBLE_BIDI.L2R_DEVANAGARI;
                    _unicode += __SCRIBBLE_DEVANAGARI_OFFSET;
                }
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
            
            if (__SCRIBBLE_ON_WEB)
            {
                _x += _texture_l;
                _y += _texture_t;
            }
            
            var _xoffset = _glyph_dict.offset + 0.5*_sdf_offset;
            var _yoffset = 0.5*_sdf_offset;
            
            if (_sdf && (SCRIBBLE_SDF_BORDER_TRIM > 0))
            {
                _x += SCRIBBLE_SDF_BORDER_TRIM;
                _y += SCRIBBLE_SDF_BORDER_TRIM;
                
                _w -= 2*SCRIBBLE_SDF_BORDER_TRIM;
                _h -= 2*SCRIBBLE_SDF_BORDER_TRIM;
                
                _xoffset += SCRIBBLE_SDF_BORDER_TRIM;
                _yoffset += SCRIBBLE_SDF_BORDER_TRIM;
            }
            
            var _u0 = _x*_texture_tw;
            var _v0 = _y*_texture_th;
            var _u1 = _u0 + _w*_texture_tw;
            var _v1 = _v0 + _h*_texture_th;
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.CHARACTER  ] = _char;
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.UNICODE    ] = _unicode;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.BIDI       ] = _bidi;
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.X_OFFSET   ] = _xoffset;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.Y_OFFSET   ] = _yoffset - _ascender_offset;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.WIDTH      ] = _w;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.HEIGHT     ] = _h;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_HEIGHT] = _h + _sdf_height_offset;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SEPARATION ] = _glyph_dict.shift;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.LEFT_OFFSET] = -_glyph_dict.offset;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_SCALE ] = 1;
                                                         
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.TEXTURE    ] = _texture;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U0         ] = _u0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U1         ] = _u1;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V0         ] = _v0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V1         ] = _v1;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_NAME  ] = _name;
            
            _font_glyphs_map[? _unicode] = _i;
            
            ++_i;
        }
        
        _font_data.__calculate_font_height();
        
        //Check to see if this texture has been resized during compile
        var _GM_scaling = _font_info.size / _font_glyph_data_grid[# _font_glyphs_map[? 32], SCRIBBLE_GLYPH.HEIGHT];
        if (_GM_scaling > 1)
        {
            __scribble_trace("Warning! Font \"", _name, "\" may have been scaled during compilation (font size = ", _font_info.size, ", space height = ", _font_glyph_data_grid[# _font_glyphs_map[? 32], SCRIBBLE_GLYPH.HEIGHT], ", scaling factor = ", _GM_scaling, "). Check that the font is rendering correctly. If it is not, try setting SCRIBBLE_ATTEMPT_FONT_SCALING_FIX to <false>");
            if (SCRIBBLE_ATTEMPT_FONT_SCALING_FIX) scribble_font_scale(_name, ceil(_GM_scaling));
        }
    }
    catch(_error)
    {
        __scribble_trace(_error);
        __scribble_error("There was an error whilst reading \"", _name, "\"\nPlease reimport the font into GameMaker and reset character ranges\nIf this issue persists, please report it");
    }
}

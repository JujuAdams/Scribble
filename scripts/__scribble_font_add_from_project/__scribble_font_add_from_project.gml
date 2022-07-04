/// @param font
/// @ignore
function __scribble_font_add_from_project(_font)
{
    var _name = font_get_name(_font);
    
    if (ds_map_exists(global.__scribble_font_data, _name))
    {
        __scribble_trace("Warning! A font for \"", _name, "\" has already been added. Destroying the old font and creating a new one");
        global.__scribble_font_data[? _name].__destroy();
    }
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Adding \"", _name, "\" as standard font");
    
    if (global.__scribble_default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_name) + "\"");
        global.__scribble_default_font = _name;
    }
    
    var _is_krutidev = __scribble_asset_is_krutidev(_font, asset_font);
    var _global_glyph_bidi_map = global.__scribble_glyph_data.__bidi_map;
    
    //Get font info from the runtime
    var _font_info = font_get_info(_font);
    var _info_glyphs_dict = _font_info.glyphs;
    
    //
    var _info_glyph_names = variable_struct_get_names(_info_glyphs_dict);
    var _size = array_length(_info_glyph_names);
    
    //
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
    
    var _font_data = new __scribble_class_font(_name, _size, false);
    var _font_glyphs_map      = _font_data.__glyphs_map;
    var _font_glyph_data_grid = _font_data.__glyph_data_grid;
    if (_is_krutidev) _font_data.__is_krutidev = true;
    
    var _i = 0;
    repeat(_size)
    {
        var _glyph_dict = _info_glyphs_array[_i];
        
        var _unicode = _glyph_dict.char;
        if ((_unicode >= 0x4E00) && (_unicode <= 0x9FFF)) //CJK Unified ideographs block
        {
            var _bidi = __SCRIBBLE_BIDI.ISOLATED;
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
        
        var _u0 = _x*_texture_tw;
        var _v0 = _y*_texture_th;
        var _u1 = _u0 + _w*_texture_tw;
        var _v1 = _v0 + _h*_texture_th;
        
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.CHARACTER   ] = _char;
        
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.UNICODE     ] = _unicode;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.BIDI        ] = _bidi;
        
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.X_OFFSET    ] = _glyph_dict.offset;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.Y_OFFSET    ] = 0;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.WIDTH       ] = _w;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.HEIGHT      ] = _h;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_HEIGHT ] = _h;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SEPARATION  ] = _glyph_dict.shift;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.LEFT_OFFSET ] = -_glyph_dict.offset;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_SCALE  ] = 1;
                                                              
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.TEXTURE     ] = _texture;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U0          ] = _u0;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U1          ] = _u1;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V0          ] = _v0;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V1          ] = _v1;
        
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.MSDF_PXRANGE] = undefined;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.BILINEAR    ] = undefined;
        
        
        _font_glyphs_map[? _unicode] = _i;
        
        ++_i;
    }
    
    _font_data.__calculate_font_height();
    
    //Check to see if this texture has been resized during compile
    var _GM_scaling = _font_glyph_data_grid[# _font_glyphs_map[? 32], SCRIBBLE_GLYPH.HEIGHT] / _font_info.size;
    if (_GM_scaling < 1)
    {
        __scribble_trace("Warning! Font \"", _name, "\" may have been scaled during compilation (font size = ", _font_info.size, ", space height = ", _font_glyph_data_grid[# _font_glyphs_map[? 32], SCRIBBLE_GLYPH.HEIGHT], ", scaling factor = ", _GM_scaling, ")");
        
        //FIXME - This seems to be inaccurate if the font is scaled down a long way - 20201-11-11  IDE v2.3.6.595  Runtime v2.3.6.464
        //        Good test vector is fnt_noto_chinese with a 2K texture page
        scribble_font_scale(_name, 1/_GM_scaling);
    }
}
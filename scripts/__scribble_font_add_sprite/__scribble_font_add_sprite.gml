#macro font_add_sprite          __scribble_font_add_sprite
#macro font_add_sprite_ext      __scribble_font_add_sprite_ext
#macro __font_add_sprite__      font_add_sprite
#macro __font_add_sprite_ext__  font_add_sprite_ext

function __scribble_font_add_sprite(_sprite, _first, _proportional, _separation)
{
    var _spritefont = __font_add_sprite__(_sprite, _first, _proportional, _separation);
    __scribble_font_add_sprite_common(_sprite, _spritefont, _proportional, _separation);
    return _spritefont;
}

function __scribble_font_add_sprite_ext(_sprite, _mapstring, _proportional, _separation)
{
    var _spritefont = __font_add_sprite_ext__(_sprite, _mapstring, _proportional, _separation);
    __scribble_font_add_sprite_common(_sprite, _spritefont, _proportional, _separation);
    return _spritefont;
}

function __scribble_font_add_sprite_common(_sprite, _spritefont, _proportional, _separation)
{
    __scribble_initialize();
    
    static _font_original_name_dict = __scribble_get_state().__font_original_name_dict;
    
    var _font_name = font_get_name(_spritefont);
    __scribble_font_check_name_conflicts(_font_name);
    
    var _font_info = font_get_info(_spritefont);
    var _sprite_name = sprite_get_name(_sprite);
    
    var _scribble_state = __scribble_get_state();
    if (_scribble_state.__default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_sprite_name) + "\"");
        _scribble_state.__default_font = _sprite_name;
    }
    
    var _sprite_width  = sprite_get_width(_sprite);
    var _sprite_height = sprite_get_height(_sprite);
    
    var _sprite_info = sprite_get_info(_sprite);
    var _sprite_frames = _sprite_info.frames;
    
    var _sprite_x_offset = 0;
    var _sprite_y_offset = 0;
    
    if (SCRIBBLE_SPRITEFONT_LEGACY_HEIGHT)
    {
        _sprite_height = 1 + sprite_get_bbox_bottom(_sprite) - sprite_get_bbox_top(_sprite);
        _sprite_y_offset += sprite_get_bbox_top(_sprite);
    }
    
    if (!SCRIBBLE_SPRITEFONT_IGNORE_ORIGIN)
    {
        _sprite_x_offset += sprite_get_xoffset(_sprite);
        _sprite_y_offset += sprite_get_yoffset(_sprite);
    }
    
    var _info_glyphs_dict = _font_info.glyphs;
    var _info_glyph_names = variable_struct_get_names(_info_glyphs_dict);
    if (SCRIBBLE_VERBOSE) __scribble_trace("  \"", _sprite_name, "\" has ", array_length(_info_glyph_names), " characters");
    
    var _size = array_length(_info_glyph_names);
    
    var _font_data = new __scribble_class_font(_sprite_name, _sprite_name, _size, false);
    var _font_glyphs_map      = _font_data.__glyphs_map;
    var _font_glyph_data_grid = _font_data.__glyph_data_grid;
    
    var _is_krutidev = __scribble_asset_is_krutidev(_spritefont, asset_font);
    if (_is_krutidev) _font_data.__is_krutidev = true;
    
    //Also create a duplicate entry so that we can find this spritefont in draw_text_scribble()
    _font_original_name_dict[$ _font_name] = _font_data;
    
    var _i = 0;
    repeat(_size)
    {
        var _glyph   = _info_glyph_names[_i];
        var _unicode = ord(_glyph);
        var _image   = _info_glyphs_dict[$ _glyph].char;
        
        var _uvs = sprite_get_uvs(_sprite, _image);
        
        if (_unicode == 32)
        {
            if (_proportional)
            {
                if (_image >= array_length(_sprite_frames)) //Cases where the space character has not been added to the mapstring
                {
                    var _space_width = 1 + sprite_get_bbox_right(_sprite) - sprite_get_bbox_left(_sprite) + _separation;
                }
                else
                {
                    var _space_width = _sprite_frames[_image].crop_width + _separation;
                }
            }
            else
            {
                var _space_width = _sprite_width + _separation;
            }
            
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__CHARACTER           ] = _glyph;
            
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__UNICODE             ] = _unicode;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__BIDI                ] = __SCRIBBLE_BIDI.WHITESPACE;
            
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__X_OFFSET            ] = -_sprite_x_offset;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__Y_OFFSET            ] = -_sprite_y_offset;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__WIDTH               ] = _space_width;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__HEIGHT              ] = _sprite_height;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__FONT_HEIGHT         ] = _sprite_height;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__SEPARATION          ] = _space_width;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__LEFT_OFFSET         ] = 0;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__FONT_SCALE          ] = 1;
            
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__MATERIAL            ] = _sprite_frames[0].texture; //Use the texture ID for the first image from the sprite
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__U0                  ] = 0;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__V0                  ] = 0;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__U1                  ] = 0;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__V1                  ] = 0;
            
            _font_glyphs_map[? _unicode] = _i;
        }
        else
        {
            var _image_info = _sprite_frames[_image];
            
            //Convert the texture index to a texture pointer
            var _texture_index = _image_info.texture;
            
            static _tex_index_lookup_map = ds_map_create();
            var _texture = _tex_index_lookup_map[? _texture_index];
            if (_texture == undefined)
            {
                _texture = sprite_get_texture(_sprite, _image);
                _tex_index_lookup_map[? _texture_index] = _texture;
            }
            
            if (_proportional)
            {
                var _x_offset = 0;
                var _glyph_separation = _image_info.crop_width + _separation;
            }
            else
            {            
                var _x_offset = _image_info.x_offset;
                var _glyph_separation = _sprite_width + _separation;
            }
            
            var _bidi = __scribble_unicode_get_bidi(_unicode);
            
            if (_is_krutidev)
            {
                __SCRIBBLE_KRUTIDEV_HACK
            }
            
            var _w = _image_info.crop_width;
            var _h = _image_info.crop_height;
            
            //Build an array to store this glyph's properties
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__CHARACTER           ] = _glyph;
            
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__UNICODE             ] = _unicode;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__BIDI                ] = _bidi;
            
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__X_OFFSET            ] = _x_offset - _sprite_x_offset;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__Y_OFFSET            ] = _image_info.y_offset - _sprite_y_offset;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__WIDTH               ] = _w;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__HEIGHT              ] = _h;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__FONT_HEIGHT         ] = _sprite_height;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__SEPARATION          ] = _glyph_separation;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__LEFT_OFFSET         ] = -_x_offset;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__FONT_SCALE          ] = 1;
            
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__MATERIAL            ] = _texture;
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__U0                  ] = _uvs[0];
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__V0                  ] = _uvs[1];
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__U1                  ] = _uvs[2];
            _font_glyph_data_grid[# _i, __SCRIBBLE_GLYPH.__V1                  ] = _uvs[3];
            
            _font_glyphs_map[? _unicode] = _i;
        }
        
        ++_i;
    }
    
    _font_data.__calculate_font_height();
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Added \"", _sprite_name, "\" as a spritefont");
    
    return _spritefont;
}
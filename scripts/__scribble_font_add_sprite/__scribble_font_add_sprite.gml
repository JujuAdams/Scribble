#macro font_add_sprite          __scribble_font_add_sprite
#macro font_add_sprite_ext      __scribble_font_add_sprite_ext
#macro __font_add_sprite__      font_add_sprite
#macro __font_add_sprite_ext__  font_add_sprite_ext

function __scribble_font_add_sprite(_sprite, _first, _proportional, _separation)
{
    var _spritefont = __font_add_sprite__(_sprite, _first, _proportional, _separation);
    __scribble_font_add_sprite_common(_spritefont, _proportional, _separation);
    return _spritefont;
}

function __scribble_font_add_sprite_ext(_sprite, _mapstring, _proportional, _separation)
{
    var _spritefont = __font_add_sprite_ext__(_sprite, _mapstring, _proportional, _separation);
    __scribble_font_add_sprite_common(_spritefont, _proportional, _separation);
    return _spritefont;
}

function __scribble_font_add_sprite_common(_spritefont, _proportional, _separation)
{
    var _font_info = font_get_info(_spritefont);
    
    var _sprite_name = _font_info.name;
    if (ds_map_exists(global.__scribble_font_data, _sprite_name))
    {
        __scribble_error("A spritefont for \"", _sprite_name, "\" has already been added");
    }
    
    var _sprite = asset_get_index(_sprite_name);
    
    if (global.__scribble_default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_sprite_name) + "\"");
        global.__scribble_default_font = _sprite_name;
    }
    
    var _sprite_width  = sprite_get_width(_sprite);
    var _sprite_height = sprite_get_height(_sprite);
    
    var _font_data = new __scribble_class_font(_sprite_name, "sprite");
    _font_data.space_width = undefined;
    _font_data.separation  = _separation;
    _font_data.glyphs_map  = ds_map_create();
    var _font_glyphs_map = _font_data.glyphs_map;
    
    var _sprite_info = sprite_get_info(_sprite);
    var _sprite_frames = _sprite_info.frames;
    var _sprite_x_offset = sprite_get_xoffset(_sprite);
    
    var _info_glyphs_dict = _font_info.glyphs;
    var _info_glyph_names = variable_struct_get_names(_info_glyphs_dict);
    if (SCRIBBLE_VERBOSE) __scribble_trace("  \"", _sprite_name, "\" has ", array_length(_info_glyph_names), " characters");
    
    var _i = 0;
    repeat(array_length(_info_glyph_names))
    {
        var _glyph = _info_glyph_names[_i];
        var _image = _info_glyphs_dict[$ _glyph].char;
        
        var _uvs = sprite_get_uvs(_sprite, _image);
        
        if ((_glyph == " ") && (_image >= array_length(_sprite_frames)))
        {
            if (_proportional)
            {
                var _space_width = 1 + sprite_get_bbox_right(_sprite) - sprite_get_bbox_left(_sprite) + _separation;
            }
            else
            {
                var _space_width = _sprite_width + _separation;
            }
            
            var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
            _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _space_width;
            _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _sprite_height;
            _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = 0;
            _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = 0;
            _array[@ SCRIBBLE_GLYPH.SEPARATION] = _space_width;
            _array[@ SCRIBBLE_GLYPH.TEXTURE   ] = _sprite_frames[0].texture; //Use the texture ID for the first image from the sprite
            _array[@ SCRIBBLE_GLYPH.U0        ] = 0;
            _array[@ SCRIBBLE_GLYPH.V0        ] = 0;
            _array[@ SCRIBBLE_GLYPH.U1        ] = 0;
            _array[@ SCRIBBLE_GLYPH.V1        ] = 0;
            _font_glyphs_map[? 32] = _array;
        }
        else
        {
            var _image_info = _sprite_frames[_image];
            
            if (_proportional)
            {
                var _x_offset = -_sprite_x_offset
                var _glyph_separation = _image_info.crop_width + _separation;
            }
            else
            {            
                var _x_offset = _image_info.x_offset - _sprite_x_offset;
                var _glyph_separation = _sprite_width + _separation;
            }
            
            //Build an array to store this glyph's properties
            var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
            _array[@ SCRIBBLE_GLYPH.CHARACTER ] = _glyph;
            _array[@ SCRIBBLE_GLYPH.INDEX     ] = ord(_glyph);
            _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _image_info.crop_width;
            _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _image_info.crop_height;
            _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _x_offset;
            _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = _image_info.y_offset;
            _array[@ SCRIBBLE_GLYPH.SEPARATION] = _glyph_separation;
            _array[@ SCRIBBLE_GLYPH.TEXTURE   ] = _image_info.texture;
            _array[@ SCRIBBLE_GLYPH.U0        ] = _uvs[0];
            _array[@ SCRIBBLE_GLYPH.V0        ] = _uvs[1];
            _array[@ SCRIBBLE_GLYPH.U1        ] = _uvs[2];
            _array[@ SCRIBBLE_GLYPH.V1        ] = _uvs[3];
            _font_glyphs_map[? ord(_glyph)] = _array;
        }
        
        ++_i;
    }
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Added \"", _sprite_name, "\" as a spritefont");
    
    return _spritefont;
}
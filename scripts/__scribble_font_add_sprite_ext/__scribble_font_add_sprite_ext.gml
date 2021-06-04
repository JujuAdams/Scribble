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
    _font_info = __scribble_snap_from_json(json_stringify(_font_info)); //FIXME - Workaround for a bug in GMS23.1.1.290 beta
    
    var _sprite_name = _font_info.name;
    var _sprite = asset_get_index(_sprite_name);
    
    var _sprite_width  = sprite_get_width(_sprite);
    var _sprite_height = sprite_get_height(_sprite);
    
    var _font_data = new __scribble_class_font(_sprite_name, "sprite");
    _font_data.space_width = undefined;
    _font_data.separation  = _separation;
    _font_data.glyphs_map  = ds_map_create();
    var _font_glyphs_map = _font_data.glyphs_map;
    
    var _sprite_info = sprite_get_info(_sprite);
    var _sprite_frames = _sprite_info.frames;
    
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
            //For some reason if the dev doesn't put in a space character, generate an empty glyph for Scribble to use
            _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _sprite_width - 2;
            _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _sprite_height;
            _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = 0;
            _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = 0;
            _array[@ SCRIBBLE_GLYPH.SEPARATION] = _sprite_width + _separation - 2;
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
            
            var _x_offset = SCRIBBLE_SPRITEFONT_ALIGN_GLYPHS_LEFT? 0 : _image_info.x_offset;
            var _glyph_separation = _image_info.crop_width + _separation;
            
            if (!_proportional)
            {
                _x_offset = _image_info.x_offset;
                _glyph_separation = _sprite_width + _separation;
            }
            
            //Build an array to store this glyph's properties
            var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
            _array[@ SCRIBBLE_GLYPH.CHARACTER ] = _glyph;
            _array[@ SCRIBBLE_GLYPH.INDEX     ] = ord(_glyph);
            _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _image_info.crop_width;
            _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _image_info.crop_height;
            _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _x_offset - 1; //Off by one?
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
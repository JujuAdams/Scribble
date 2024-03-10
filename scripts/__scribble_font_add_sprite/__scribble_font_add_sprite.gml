// Feather disable all
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
    
    var _font_info = font_get_info(_spritefont);
    var _sprite_name = sprite_get_name(_sprite);
    
    static _font_data_map = __scribble_get_font_data_map();
    if (ds_map_exists(_font_data_map, _sprite_name))
    {
        __scribble_trace("Warning! A spritefont for \"", _sprite_name, "\" has already been added. Destroying the old spritefont and creating a new one");
        _font_data_map[? _sprite_name].__destroy();
    }
    
    var _is_krutidev = __scribble_asset_is_krutidev(_sprite, asset_sprite);
    var _global_glyph_bidi_map = __scribble_get_glyph_data().__bidi_map;
    
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
    
    var _font_data = new __scribble_class_font(_sprite_name, _size, false);
    var _font_glyphs_map      = _font_data.__glyphs_map;
    var _font_glyph_data_grid = _font_data.__glyph_data_grid;
    if (_is_krutidev) _font_data.__is_krutidev = true;
    
    //Also create a duplicate entry so that we can find this spritefont in draw_text_scribble()
    _font_data_map[? font_get_name(_spritefont)] = _font_data;
    
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
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.CHARACTER            ] = _glyph;
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.UNICODE              ] = _unicode;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.BIDI                 ] = __SCRIBBLE_BIDI.WHITESPACE;
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.X_OFFSET             ] = -_sprite_x_offset;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.Y_OFFSET             ] = -_sprite_y_offset;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.WIDTH                ] = _space_width;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.HEIGHT               ] = _sprite_height;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_HEIGHT          ] = _sprite_height;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SEPARATION           ] = _space_width;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.LEFT_OFFSET          ] = 0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_SCALE           ] = 1;
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.TEXTURE              ] = _sprite_frames[0].texture; //Use the texture ID for the first image from the sprite
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U0                   ] = 0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V0                   ] = 0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U1                   ] = 0;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V1                   ] = 0;
        
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SDF_PXRANGE         ] = undefined;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SDF_THICKNESS_OFFSET] = undefined;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.BILINEAR             ] = undefined;
            
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
            
            var _w = _image_info.crop_width;
            var _h = _image_info.crop_height;
            
            //Build an array to store this glyph's properties
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.CHARACTER            ] = _glyph;
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.UNICODE              ] = _unicode;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.BIDI                 ] = _bidi;
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.X_OFFSET             ] = _x_offset - _sprite_x_offset;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.Y_OFFSET             ] = _image_info.y_offset - _sprite_y_offset;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.WIDTH                ] = _w;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.HEIGHT               ] = _h;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_HEIGHT          ] = _sprite_height;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SEPARATION           ] = _glyph_separation;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.LEFT_OFFSET          ] = -_x_offset;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_SCALE           ] = 1;
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.TEXTURE              ] = _texture;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U0                   ] = _uvs[0];
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V0                   ] = _uvs[1];
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U1                   ] = _uvs[2];
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V1                   ] = _uvs[3];
            
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SDF_PXRANGE         ] = undefined;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SDF_THICKNESS_OFFSET] = undefined;
            _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.BILINEAR             ] = undefined;
            
            _font_glyphs_map[? _unicode] = _i;
        }
        
        ++_i;
    }
    
    _font_data.__calculate_font_height();
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Added \"", _sprite_name, "\" as a spritefont");
    
    return _spritefont;
}

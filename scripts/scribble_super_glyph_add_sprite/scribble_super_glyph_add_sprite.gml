/// @param fontName
/// @param glyph
/// @param sprite
/// @param image
/// @param separation
/// @param [scale=1]

function scribble_super_glyph_add_sprite(_font_name, _glyph, _sprite, _image, _separation, _scale = 1)
{
    var _font_data = __scribble_get_font_data(_font_name);
    var _glyphs_map      = _font_data.__glyphs_map;
    var _glyph_data_grid = _font_data.__glyph_data_grid;
    
    var _index = ds_grid_width(_glyph_data_grid);
    ds_grid_resize(_glyph_data_grid, _index+1, __SCRIBBLE_GLYPH.__SIZE);
    
    var _unicode = ord(_glyph);
    _scale *= _font_data.__scale;
    
    var _sprite_uvs    = sprite_get_uvs(_sprite, _image);
    var _sprite_frames = sprite_get_info(_sprite).frames;
    
    if (array_length(_sprite_frames) <= 0) __scribble_error(sprite_get_name(_sprite), " has no images");
    if (_image >= array_length(_sprite_frames)) __scribble_error(sprite_get_name(_sprite), " has ", array_length(_sprite_frames), " image, cannot access image index ", _image);
    
    var _image_info = _sprite_frames[_image];
    
    var _yoffset = 0.5*(_font_data.__height - _scale*sprite_get_height(_sprite));
    
    //Build an array to store this glyph's properties
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__CHARACTER  ] = _glyph;
    
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__UNICODE    ] = _unicode;
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__BIDI       ] = __SCRIBBLE_BIDI.SYMBOL;
    
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__X_OFFSET   ] =  _scale*_image_info.x_offset;
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__Y_OFFSET   ] =  _scale*_image_info.y_offset + _yoffset;
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__WIDTH      ] =  _scale*_image_info.crop_width;
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__HEIGHT     ] =  _scale*_image_info.crop_height;
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__FONT_HEIGHT] =  _scale*sprite_get_height(_sprite);
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__SEPARATION ] =  _scale*sprite_get_width(_sprite) + _font_data.__scale*_separation;
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__LEFT_OFFSET] = -_scale*_image_info.x_offset;
    
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__MATERIAL   ] = sprite_get_texture(_sprite, _image);
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__U0         ] = _sprite_uvs[0];
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__V0         ] = _sprite_uvs[1];
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__U1         ] = _sprite_uvs[2];
    _glyph_data_grid[# _index, __SCRIBBLE_GLYPH.__V1         ] = _sprite_uvs[3];
    
    _glyphs_map[? _unicode] = _index;
    
    ds_grid_set_region(_glyph_data_grid, 0, __SCRIBBLE_GLYPH.__FONT_HEIGHT, ds_grid_width(_glyph_data_grid)-1, __SCRIBBLE_GLYPH.__FONT_HEIGHT,
                        max(_font_data.__height, _scale*sprite_get_height(_sprite)));
}
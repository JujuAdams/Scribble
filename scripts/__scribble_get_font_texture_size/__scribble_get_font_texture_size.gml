/// @param fontName

var _name = argument0;

if ( is_array( _name ) ) _name = _name[0];
if ( asset_get_type( _name ) == asset_sprite )
{
    show_debug_message( "Scribble: Cannot get the dimensions of a spritefont" );
    return undefined;
}

var _asset   = asset_get_index(  _name  )
var _texture = font_get_texture( _asset );
var _uvs     = font_get_uvs(     _asset );

var _image_w = (_uvs[2] - _uvs[0]) / texture_get_texel_width(  _texture );
var _image_h = (_uvs[3] - _uvs[1]) / texture_get_texel_height( _texture );

return [ _image_w, _image_h ];
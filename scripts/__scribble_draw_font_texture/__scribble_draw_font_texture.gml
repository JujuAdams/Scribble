/// @param fontName
/// @param x
/// @param y

var _name = argument0;
var _x    = argument1;
var _y    = argument2;

if ( is_array( _name ) ) _name = _name[0];
if ( asset_get_type( _name ) == asset_sprite )
{
    show_debug_message( "Scribble: Cannot draw a spritefont texture." );
    return undefined;
}

var _asset   = asset_get_index(  _name  )
var _texture = font_get_texture( _asset );
var _uvs     = font_get_uvs(     _asset );

var _image_w = (_uvs[2] - _uvs[0]) / texture_get_texel_width(  _texture );
var _image_h = (_uvs[3] - _uvs[1]) / texture_get_texel_height( _texture );

show_debug_message( "Scribble: Drawing font \"" + _name + "\" (" + string( _asset ) + ") texture at " + string( _x ) + "," + string( _y ) + " (size=" + string( _image_w ) + "x" + string( _image_h ) + ")" );

var _vbuff = vertex_create_buffer();
vertex_begin( _vbuff, global.__scribble_vertex_format );
vertex_position( _vbuff, _x         , _y          ); vertex_texcoord( _vbuff, _uvs[0], _uvs[1] ); vertex_color( _vbuff, c_white, 1 ); vertex_float4( _vbuff, 0,0,0,0 ); vertex_float3( _vbuff, 0,0,0 );
vertex_position( _vbuff, _x+_image_w, _y          ); vertex_texcoord( _vbuff, _uvs[2], _uvs[1] ); vertex_color( _vbuff, c_white, 1 ); vertex_float4( _vbuff, 0,0,0,0 ); vertex_float3( _vbuff, 0,0,0 );
vertex_position( _vbuff, _x         , _y+_image_h ); vertex_texcoord( _vbuff, _uvs[0], _uvs[3] ); vertex_color( _vbuff, c_white, 1 ); vertex_float4( _vbuff, 0,0,0,0 ); vertex_float3( _vbuff, 0,0,0 );
vertex_position( _vbuff, _x+_image_w, _y+_image_h ); vertex_texcoord( _vbuff, _uvs[2], _uvs[3] ); vertex_color( _vbuff, c_white, 1 ); vertex_float4( _vbuff, 0,0,0,0 ); vertex_float3( _vbuff, 0,0,0 );
vertex_end( _vbuff );
vertex_submit( _vbuff, pr_trianglestrip, _texture );
vertex_delete_buffer( _vbuff );

return [ _image_w, _image_h ];
/// @description SCRIBBLE service initialisation
/// @param scribble_dat
/// @param scribble_texture

var _scribble_dat     = argument0;
var _scribble_texture = argument1;

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
vertex_format_add_colour();
vertex_format_add_normal();
global.scribble_font_vertex_format = vertex_format_end();

var _buffer = buffer_load( _scribble_dat );
var _string = buffer_read( _buffer, buffer_string );
buffer_delete( _buffer );
global.scribble_font_json = json_decode( _string );

//Unfuck the JSON import - my own fault really
for( var _key = ds_map_find_first( global.scribble_font_json );
     _key != undefined;
	 _key = ds_map_find_next( global.scribble_font_json, _key ) ) {
	
	//We may accidentally visit a real-valued key that we've generated, so ignore those
	if ( is_real( _key ) ) continue;
	
	//Reassign this string-valued key as a real-valued key
	ds_map_add_map( global.scribble_font_json, real( _key ), global.scribble_font_json[? _key ] );
	global.scribble_font_json[? _key ] = undefined;
	
	//Now we need to recover the 2D array that we stored in the JSON
	var _map = global.scribble_font_json[? real( _key ) ];
	var _uvs_list = _map[? "uvs" ];
	var _max_index = ds_list_size( _uvs_list ) / E_SCRIBBLE.SIZE;
	
	//Don't forget to wipe the array properly!
	var _uvs = undefined;
	_uvs[ _max_index, E_SCRIBBLE.SIZE-1 ] = 0;
	
	var _i = 0;
	for( var _x = 0; _x < _max_index; _x++ ) {
		for( var _y = 0; _y < E_SCRIBBLE.SIZE; _y++ ) {
			_uvs[ _x, _y ] = _uvs_list[| _i ];
			_i++;
		}
	}
	
	_map[? "uvs" ] = _uvs;
	ds_list_destroy( _uvs_list );
	
}

global.scribble_sprite = sprite_add( _scribble_texture, 0, false, false, 0, 0 );
global.scribble_texture = sprite_get_texture( global.scribble_sprite, 0 );

if ( sprite_get_width(  global.scribble_sprite ) != SCRIBBLE_SURFACE_SIZE )
|| ( sprite_get_height( global.scribble_sprite ) != SCRIBBLE_SURFACE_SIZE ) {
	trace_error( false, "Scribble texture size mismatch, check export and import macros match" );
}
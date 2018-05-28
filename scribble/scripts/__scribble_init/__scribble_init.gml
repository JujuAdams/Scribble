global.__scribble_image_map     = ds_map_create();
global.__scribble_image_x_map   = ds_map_create();
global.__scribble_image_y_map   = ds_map_create();
global.__scribble_glyphs_map    = ds_map_create();
global.__scribble_cache_map     = ds_map_create();
global.__scribble_cjk_wrapping  = false;
global.__scribble_internal_time = current_time/1000;
global.__scribble_time          = global.__scribble_internal_time;

if ( SCRIBBLE_USE_INTERNAL_TIMER && !instance_exists( oScribble ) ) instance_create_depth( 0, 0, 0, oScribble );

vertex_format_begin();
vertex_format_add_position();
vertex_format_add_texcoord();
vertex_format_add_colour();
vertex_format_add_custom( vertex_type_float4, vertex_usage_colour );
vertex_format_add_custom( vertex_type_float3, vertex_usage_colour );
global.__scribble_vertex_format = vertex_format_end();

if ( array_length_1d( SCRIBBLE_FONT_ARRAY ) ) scribble_load_fonts( SCRIBBLE_FONT_ARRAY );
__scribble_additional_init_commands();
/// @param texturePageSize

if ( variable_global_exists( "__scribble_init_font_array" ) )
{
    show_error( "scribble_init_start() may not be called twice\n ", false );
    exit;
}

global.__scribble_texture_page_size = argument0;
global.__scribble_image_map         = ds_map_create();
global.__scribble_image_x_map       = ds_map_create();
global.__scribble_image_y_map       = ds_map_create();
global.__scribble_glyphs_map        = ds_map_create();
global.__scribble_cache_map         = ds_map_create();
global.__scribble_sprite_font_map   = ds_map_create();
global.__scribble_sprites           = ds_list_create();
global.__scribble_host_destroyed    = false;
global.__scribble_init_font_array   = [];
global.__scribble_default_font      = "";

vertex_format_begin();
vertex_format_add_position();
vertex_format_add_texcoord();
vertex_format_add_colour();
vertex_format_add_custom( vertex_type_float4, vertex_usage_colour );
vertex_format_add_custom( vertex_type_float3, vertex_usage_colour );
global.__scribble_vertex_format = vertex_format_end();
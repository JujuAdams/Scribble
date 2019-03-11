/// @param fontDirectory
/// @param texturePageSize
///
/// 

if ( variable_global_exists( "__scribble_texture_page_size" ) )
{
    show_error( "scribble_init_start() may not be called twice\n ", false );
    exit;
}

var _font_directory = argument0;
var _tpage_size     = argument1;

//Fix the font directory name if it's weird
var _char = string_char_at( _font_directory, string_length( _font_directory ) );
if ( _char != "\\" ) && ( _char != "/" ) _font_directory += "\\";

//Check if the directory exists
if ( !directory_exists( _font_directory ) )
{
    show_error( "Font directory \"" + string( _font_directory ) + "\" could not be found in \"" + game_save_id + "\"!\n ", true );
    exit;
}

//Check texture page size for user error
var _exp = ln(_tpage_size)/ln(2);
if ( round(_exp) != _exp )
{
    var _fixed_tpage_size = clamp( power( 2, ceil(_exp) ), 1024, 8192 );
    show_error( "Texture page size \"" + string( _tpage_size ) + "\" isn't a power of 2. Did you mean \"" + string( _fixed_tpage_size ) + "\"?\n ", false );
    _tpage_size = _fixed_tpage_size;
}

if (_tpage_size < 512) || (_tpage_size > 8192)
{
    show_error( "Texture page size \"" + string( _tpage_size ) + "\" is not supported by Scribble!\n ", true );
    exit;
}

//Declare global variables
global.__scribble_font_directory    = _font_directory;
global.__scribble_texture_page_size = _tpage_size;
global.__scribble_font_data         = ds_map_create();
global.__scribble_glyphs_map        = ds_map_create();
global.__scribble_sprites           = ds_list_create();
global.__scribble_sprite_font_map   = ds_map_create();
global.__scribble_colours           = ds_map_create(); //Stores colour definitions, including custom colours
global.__scribble_events            = ds_map_create(); //Stores event bindings
global.__scribble_default_font      = "";

//Cache uniform indexes
global.__scribble_uniform_time            = shader_get_uniform( shScribble, "u_fTime"               );
global.__scribble_uniform_colour          = shader_get_uniform( shScribble, "u_vColour"             );
global.__scribble_uniform_options         = shader_get_uniform( shScribble, "u_vOptions"            );
global.__scribble_uniform_char_t          = shader_get_uniform( shScribble, "u_fCharFadeT"          );
global.__scribble_uniform_char_smoothness = shader_get_uniform( shScribble, "u_fCharFadeSmoothness" );
global.__scribble_uniform_line_t          = shader_get_uniform( shScribble, "u_fLineFadeT"          );
global.__scribble_uniform_line_smoothness = shader_get_uniform( shScribble, "u_fLineFadeSmoothness" );

//Create a vertex format for our text
vertex_format_begin();
vertex_format_add_position();
vertex_format_add_texcoord();
vertex_format_add_colour();
vertex_format_add_custom( vertex_type_float4, vertex_usage_colour ); //R = character index, G = line index, B = unused, A = unused
vertex_format_add_custom( vertex_type_float3, vertex_usage_colour ); //R = wave boolean, G = shake boolean, B = rainbow boolean
global.__scribble_vertex_format = vertex_format_end();

//Duplicate GM's native colour constants in string form for access in scribble_create()
scribble_add_custom_colour( "c_aqua",    c_aqua    );
scribble_add_custom_colour( "c_black",   c_black   );
scribble_add_custom_colour( "c_blue",    c_blue    );
scribble_add_custom_colour( "c_dkgray",  c_dkgray  );
scribble_add_custom_colour( "c_fuchsia", c_fuchsia );
scribble_add_custom_colour( "c_green",   c_green   );
scribble_add_custom_colour( "c_lime",    c_lime    );
scribble_add_custom_colour( "c_ltgray",  c_ltgray  );
scribble_add_custom_colour( "c_maroon",  c_maroon  );
scribble_add_custom_colour( "c_navy",    c_navy    );
scribble_add_custom_colour( "c_olive",   c_olive   );
scribble_add_custom_colour( "c_orange",  c_orange  );
scribble_add_custom_colour( "c_purple",  c_purple  );
scribble_add_custom_colour( "c_red",     c_red     );
scribble_add_custom_colour( "c_silver",  c_silver  );
scribble_add_custom_colour( "c_teal",    c_teal    );
scribble_add_custom_colour( "c_white",   c_white   );
scribble_add_custom_colour( "c_yellow",  c_yellow  );
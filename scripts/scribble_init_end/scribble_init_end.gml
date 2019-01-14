if ( !variable_global_exists( "__scribble_image_map" ) )
{
    show_error( "scribble_init_end() can only be called after scribble_init_start()\n ", false );
    exit;
}

if ( global.__scribble_image_map == undefined )
{
    show_error( "scribble_init_end() may only be called once\n ", false );
    exit;
}

scribble_load_fonts( global.__scribble_init_font_array );
global.__scribble_init_font_array = undefined;
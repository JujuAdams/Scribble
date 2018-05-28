draw_set_colour( c_white );
draw_set_font( fnt_consolas );

switch( test_mode ) {
    case 0:
        draw_text( 5, 5, "SCRIBBLE" );
        var _t = get_timer();
        scribble_draw( 15, 40, lorem_ipsum_json, UD, UD, (current_time/5000) mod 2 );
        _t = get_timer() - _t;
    break;
    case 1:
        draw_text( 5, 5, "NATIVE" );
        var _t = get_timer();
        draw_text_ext( 15, 40, lorem_ipsum_plain, 20, 800 );
        _t = get_timer() - _t;
    break;
    case 2:
        draw_text( 5, 5, "SCROLLBOX" );
        var _t = get_timer();
        scribble_scrollbox_draw( scrollbox_x, scrollbox_y, scrollbox, scrollbox_json );
        _t = get_timer() - _t;
    break;
}

draw_text( 150, 5, "Press any key to switch example." );
render_time_smoothed = lerp( render_time_smoothed, _t, 0.01 );
draw_text( 500, 5, concat( "Render time=", floor( render_time_smoothed )/1000, "ms" ) );
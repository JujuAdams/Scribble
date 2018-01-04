if ( keyboard_check_pressed( vk_anykey ) && !keyboard_check_pressed( vk_space ) ) test_mode = ( test_mode + 1 ) mod 2;

if ( test_mode == 1 ) {
    /*
    //This script returns <noone> when the text has fully faded out
    var _result = text_scrollbox_step( scrollbox_x, scrollbox_y, scrollbox, scrollbox_focus_text, mouse_x, mouse_y, false );
    if ( _result < 0 ) {
        introduction_text_json = noone;
        scrollbox_focus_text = outro_text_json;
    }
    */
    /*
    if ( os_browser != browser_not_a_browser ) { //Callbacks don't work properly in HTML5 due to obfuscation :(
        if ( scribble_test_for_click( scrollbox_focus_text, "unique name"  ) ) example_do_bork();
        if ( scribble_test_for_click( scrollbox_focus_text, "twinned link" ) ) example_do_close();
        if ( scribble_test_for_click( scrollbox_focus_text, "url"          ) ) example_open_url();
    }
    */
}
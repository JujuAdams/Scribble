scribble_init();

render_time_smoothed = 200;
test_mode = 0;

lorem_ipsum_plain = concat( LOREM_IPSUM, "\n\n",
                            LOREM_IPSUM, "\n\n",
                            LOREM_IPSUM, "\n\n",
                            LOREM_IPSUM, "\n\n",
                            LOREM_IPSUM );

var _string = concat( LOREM_IPSUM_FANCY, "\n\n",
                      LOREM_IPSUM_FANCY, "\n\n",
                      LOREM_IPSUM_FANCY, "\n\n",
                      LOREM_IPSUM_FANCY, "\n\n",
                      LOREM_IPSUM_FANCY );
                      
//btw "UD" means "undefined"
lorem_ipsum_json = scribble_create( _string, 800, fnt_consolas, UD, UD, 20 );
scribble_set_shader( lorem_ipsum_json, shd_scribble_fade_char, 50, E_SCRIBBLE_FADE.PER_CHAR );

var _str = @"This is text.

[$DADA21]This text is coloured with a hex code.
[fa_right]This is justified right.
[fa_centre][fnt_tnr_32]This is[] text [c_blue]in [fnt_verdana_32_bold]various [c_red][fnt_tnr_41]styles.[]

[fa_left]This is a [fnt_verdana_32_bold]line of text[] that is much longer than the (900px) [fnt_verdana_32_bold]maximum width[]. [fnt_tnr_41_italics]It is also possible to insert images [link|unique name|example_do_bork][spr_pug][/link].[]

[fa_centre][link|twinned link|example_do_close]Click here to destroy this text[/link]
[fnt_tnr_41](or on the grumpy pug [link|twinned link][spr_pug][/link])[].";
introduction_text_json = scribble_create( _str, 800, fnt_verdana_32, UD, UD, 65 );

var _str = "Nothing more to see here!#Made by [link|url|example_open_url]@jujuadams";
outro_text_json = scribble_create( _str, 800, fnt_verdana_32, UD, UD, 65 );

scrollbox_json = introduction_text_json;
scrollbox = scribble_scrollbox_create( 940, 500, 30, 30, c_gray );
scrollbox_x = ( room_width  - scrollbox[? "width"  ] ) div 2;
scrollbox_y = ( room_height - scrollbox[? "height" ] ) div 2;
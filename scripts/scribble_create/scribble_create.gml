/// @description Creates, and returns, a Scribble JSON, and its vertex buffer, built from a string
///
/// @param string
/// @param [box_width]
/// @param [font]
/// @param [line_halign]
/// @param [colour]
/// @param [line_height]
/// @param [make_vbuff]

var _timer = get_timer();

var _str             = __scribble_replace_newlines( argument[0] );
var _width_limit     = ((argument_count<2) || (argument[1]==undefined))? 9999999999                                      : argument[1];
var _def_font        = ((argument_count<3) || (argument[2]==undefined))? SCRIBBLE_DEFAULT_FONT                           : argument[2];
var _def_halign      = ((argument_count<4) || (argument[3]==undefined))? fa_left                                         : argument[3];
var _def_colour      = ((argument_count<5) || (argument[4]==undefined))? c_white                                         : argument[4];
var _line_min_height = ((argument_count<6) || (argument[5]==undefined))? scribble_font_char_get_height( _def_font, " " ) : argument[5];
var _generate_vbuff  = ((argument_count<7) || (argument[6]==undefined))? true                                            : argument[6];

var _def_space_width = scribble_font_char_get_width( _def_font, " " );



#region Create the JSON

//Create data structures
var _json = ds_map_create();

//Input values
_json[? "string"         ] = _str;
_json[? "default font"   ] = _def_font;
_json[? "default colour" ] = _def_colour;
_json[? "default halign" ] = _def_halign;
_json[? "width limit"    ] = _width_limit;
_json[? "line height"    ] = _line_min_height;

//Main data structure for text storage
var _text_root_list = ds_list_create();
ds_map_add_list( _json, "lines list", _text_root_list );

//Box alignment and dimensions
_json[? "halign" ] = fa_left;
_json[? "valign" ] = fa_top;
_json[? "width"  ] = 0;
_json[? "height" ] = 0;
_json[? "left"   ] = 0;
_json[? "top"    ] = 0;
_json[? "right"  ] = 0;
_json[? "bottom" ] = 0;

//Stats
_json[? "length" ] = 0;
_json[? "lines"  ] = 0;
_json[? "words"  ] = 0;

//Hyperlink handling
var _hyperlink_map          = ds_map_create();
var _hyperlink_regions_list = ds_list_create();
var _hyperlink_list         = ds_list_create();
ds_map_add_map(  _json, "hyperlinks"       , _hyperlink_map );
ds_map_add_list( _json, "hyperlink regions", _hyperlink_regions_list );
ds_map_add_list( _json, "hyperlink list"   , _hyperlink_list );
_json[? "hyperlink fade in rate"  ] = 0.05;
_json[? "hyperlink fade out rate" ] = 0.05;

//Vertex buffer/shader values
var _vbuff_list = ds_list_create();
ds_map_add_list( _json, "vertex buffer list", _vbuff_list );
__scribble_default_shader_values( _json );

//Sprite slots
var _sprite_slot_list = ds_list_create();
ds_map_add_list( _json, "sprite slots", _sprite_slot_list );
repeat( SCRIBBLE_MAX_SPRITE_SLOTS ) {
    var _slot_map = ds_map_create();
    _slot_map[? "sprite" ] = undefined;
    _slot_map[? "name"   ] = "<unknown>";
    _slot_map[? "image"  ] = 0;
    _slot_map[? "speed"  ] = 1;
    _slot_map[? "frames" ] = 1;
    ds_list_add( _sprite_slot_list, _slot_map );
    ds_list_mark_as_map( _sprite_slot_list, ds_list_size( _sprite_slot_list )-1 );
}

//Event triggering
var _events_character_list = ds_list_create();
var _events_name_list      = ds_list_create();
var _events_data_list      = ds_list_create();
ds_map_add_list( _json, "events character list", _events_character_list );
ds_map_add_list( _json, "events name list"     , _events_name_list      );
ds_map_add_list( _json, "events data list"     , _events_data_list      );
ds_map_add_list( _json, "events triggered list", ds_list_create()       );
ds_map_add_map(  _json, "events triggered map" , ds_map_create()        );
ds_map_add_map(  _json, "events value map"     , ds_map_create()        );
ds_map_add_map(  _json, "events changed map"   , ds_map_create()        );
ds_map_add_map(  _json, "events previous map"  , ds_map_create()        );
ds_map_add_map(  _json, "events different map" , ds_map_create()        );

#endregion



#region Parser

//Parser state
var _text_x = 0;
var _text_y = 0;

var _map = noone;
var _line_map = noone;
var _line_list = noone;
var _line_length = 0;
var _line_max_height = _line_min_height;

var _text_font      = _def_font;
var _text_colour    = _def_colour;
var _text_halign    = _def_halign;
var _text_hyperlink = "";
var _text_rainbow   = false;
var _text_shake     = false;
var _text_wave      = false;

var _font_line_height = _line_min_height;
var _font_space_width = _def_space_width;



//Find the first separator
var _sep_pos = string_length( _str ) + 1;
var _sep_prev_char = "";
var _sep_char = "";

var _result = __scribble_find_separator( _str, " "    , _sep_char, _sep_pos ); _sep_char = _result[0]; _sep_pos = _result[1];
    _result = __scribble_find_separator( _str, chr(13), _sep_char, _sep_pos ); _sep_char = _result[0]; _sep_pos = _result[1];
    _result = __scribble_find_separator( _str, "["    , _sep_char, _sep_pos ); _sep_char = _result[0]; _sep_pos = _result[1];

if ( global.__scribble_cjk_wrapping ) {
    if ( _sep_pos > 1 ) {
        _sep_char = "";
        _sep_pos = 2;
    }
}

//Iterate over the entire string...
while( string_length( _str ) > 0 ) {
    
    var _skip = false;
    var _force_newline = false;
    var _new_word = false;
    
    var _substr_width       = 0;
    var _substr_height      = 0;
    var _substr_length      = _sep_pos - 1;
    var _substr_sprite      = noone;
    var _substr_image       = undefined;
    var _substr_sprite_slot = undefined;
    
    var _input_substr = string_copy( _str, 1, _substr_length );
    var _substr = _input_substr;
    
    if ( _sep_char ==  " " )
    || ( _sep_char == chr(13) )
    || ( _sep_char == "[" )
    || ( _sep_char == "]" ) {
        _str = string_delete( _str, 1, _sep_pos );
    } else {
        _str = string_delete( _str, 1, _substr_length );
    }
    
    var _first_character = false;
    if ( _line_list == noone ) {
        _first_character = true;
    } else if ( ds_list_size( _line_list ) <= 1 ) {
        _first_character = true;
    }
    
    if ( _sep_prev_char == "[" ) && ( _sep_char == "]" ) {
            
        #region Command Handling
        
        //Commands (typically) occupy no space when using the typewriter functionality
        _substr_length = 0;
        
        //Strip out commands and parameters
        var _work_str = _substr + "|";
        var _pos = string_pos( "|", _work_str );
        var _parameters = undefined;
        var _count = 0;
        while( _pos > 0 ) {
                
            _parameters[_count] = string_copy( _work_str, 1, _pos - 1 );
            _count++;
                
            _work_str = string_delete( _work_str, 1, _pos );
            _pos = string_pos( "|", _work_str );
                
        }
        
        //If the dev has used the [] command to reset draw state...
        if ( _parameters[0] == "" ) {
            
            #region Reset formatting
            
            _skip = true;
            
            _text_font      = _def_font;
            _text_colour    = _def_colour;
            _text_hyperlink = "";
                
            _text_rainbow   = false;
            _text_shake     = false;
            _text_wave      = false;
            
            _font_line_height = _line_min_height;
            _font_space_width = _def_space_width;
            
            #endregion
            
            #region Events
        
        } else if ( _parameters[0] == "event" ) || ( _parameters[0] == "ev" ) {
            
            var _parameter_count = array_length_1d( _parameters );
            if ( _parameter_count <= 1 ) {
                
                show_error( "Not enough parameters for event!", false );
                _skip = true;
                
            } else {
                
                var _name = _parameters[1];
                var _data = [];
                array_copy( _data, 0, _parameters, 2, _parameter_count-2 );
                
                ds_list_add( _events_character_list, _json[? "length" ] );
                ds_list_add( _events_name_list     , _name              );
                ds_list_add( _events_data_list     , _data              );
                
            }
            
            _skip = true;
            
            #endregion
         
            #region Dynamic effects
        
        //Rainbow effect
        } else if ( _parameters[0] == "rainbow" ) { 
                
            _text_rainbow = true;
            _skip = true;
                
        } else if ( _parameters[0] == "/rainbow" ) { 
                
            _text_rainbow = false;
            _skip = true;
        
        
        //Shake effect
        } else if ( _parameters[0] == "shake" ) { 
                
            _text_shake = true;
            _skip = true;
                
        } else if ( _parameters[0] == "/shake" ) { 
                
            _text_shake = false;
            _skip = true;
        
        
        //Wave effect
        } else if ( _parameters[0] == "wave" ) { 
                
            _text_wave = true;
            _skip = true;
                
        } else if ( _parameters[0] == "/wave" ) { 
                
            _text_wave = false;
            _skip = true;
        
            #endregion
        
            #region Change font
        
        //Changing font
        } else if ( scribble_font_exists( _parameters[0] ) ) {
            
            _text_font = _parameters[0];
            _font_space_width = scribble_font_char_get_width(  _text_font, " " );
            _font_line_height = scribble_font_char_get_height( _text_font, " " );
            _skip = true;
            
            #endregion
            
            #region Hyperlinks
        
        //Creating a hyperlink
        } else if ( _parameters[0] == "link" ) {
                        
            if ( array_length_1d( _parameters ) >= 2 ) {
                            
                _text_hyperlink = _parameters[1];
                
                if ( !ds_map_exists( _hyperlink_map, _text_hyperlink ) ) {
                    
                    _map = ds_map_create();
                    ds_map_add_map( _hyperlink_map, _text_hyperlink, _map );
                    _map[? "over"  ] = false;
                    _map[? "down"  ] = false;
                    _map[? "index" ] = ds_list_size( _hyperlink_list );
                    _map[? "mix"   ] = 0;
                                
                    if ( array_length_1d( _parameters ) >= 3 ) {
                        _map[? "script name" ] = _parameters[2];
                        _map[? "script"      ] = asset_get_index( _parameters[2] );
                    } else {
                        _map[? "script name" ] = "";
                        _map[? "script"      ] = asset_get_index( "" );
                    }
                    
                    ds_list_add( _hyperlink_list, _text_hyperlink );
                    if ( ds_list_size( _hyperlink_list ) > SCRIBBLE_MAX_HYPERLINKS ) show_debug_message( "Warning! Maximum hyperlink count (" + string( SCRIBBLE_MAX_HYPERLINKS ) + ") exceeded!" );
                    
                }
                        
                            
            } else {
                            
                _text_hyperlink = "";
                            
            }
                    
            _skip = true;
                    
        } else if ( _parameters[0] == "/link" ) {
                        
            _text_hyperlink = "";
            _skip = true;
            
            #endregion
        
            #region Font alignment
        
        //The command is an alignment keyphrase... set the alignment for the line and force a newline if the previous had content
        } else if ( _parameters[0] == "fa_left" ) {
            
            _text_halign = fa_left;
            _substr = "";
            if ( _first_character ) {
                if ( _line_map != noone ) _line_map[? "halign" ] = _text_halign;
            } else {
                _force_newline = true;
            }
            
        } else if ( ( _parameters[0] == "fa_center" ) || ( _parameters[0] == "fa_centre" ) ) {
            
            _text_halign = fa_center;
            _substr = "";
            if ( _first_character ) {
                if ( _line_map != noone ) _line_map[? "halign" ] = _text_halign;
            } else {
                _force_newline = true;
            }
                
        } else if ( _parameters[0] == "fa_right" ) {
            
            _text_halign = fa_right;
            _substr = "";
            if ( _first_character ) {
                if ( _line_map != noone ) _line_map[? "halign" ] = _text_halign;
            } else {
                _force_newline = true;
            }
                
            #endregion  
                
        //If the command is something else...
        } else {
            
            //A sprite?
            var _asset = asset_get_index( _parameters[0] );
            if ( _asset >= 0 ) && ( asset_get_type( _parameters[0] ) == asset_sprite ) {
                
                #region Sprites
                
                _substr_sprite = _asset;
                _substr_width  = sprite_get_width(  _substr_sprite );
                _substr_height = sprite_get_height( _substr_sprite );
                _substr_length = 1;
                
                if ( array_length_1d( _parameters ) <= 1 ) {
                    show_debug_message( "Scribble: Warning! Second argument not passed for sprite \"" + sprite_get_name( _substr_sprite ) + "\". Sprite commands must either specify a frame to show (\"[sSprite|2]\"), or a sprite slot (\"[sSprite|$0]\")." );
                    _parameters[1] = "0";
                }
                
                if ( string_copy( _parameters[1], 1, 1 ) != "$" ) {
                    _substr_image = real( _parameters[1] );
                    _substr_sprite_slot = undefined;
                } else {
                    
                    _substr_image = 0;
                    _substr_sprite_slot = real( string_delete( _parameters[1], 1, 1 ) );
                    
                    var _slot_map = _sprite_slot_list[| _substr_sprite_slot ];
                    if ( _slot_map[? "sprite" ] != undefined ) {
                        if ( _slot_map[? "frames" ] != sprite_get_number( _substr_sprite ) ) {
                            show_debug_message( "Scribble: Warning! Sprite length mismatch for slot " + string( _substr_sprite_slot ) + ": New sprite (" + sprite_get_name( _substr_sprite ) + ") has " + string( sprite_get_number( _substr_sprite ) ) + " frames vs. Old sprite (" + _slot_map[? "name" ] + ") has " + string( _slot_map[? "frames" ] ) + " frames" );
                        }
                    }
                    _slot_map[? "sprite" ] = _substr_sprite;
                    _slot_map[? "name"   ] = sprite_get_name( _substr_sprite );
                    _slot_map[? "frames" ] = sprite_get_number( _substr_sprite );
                    
                }
                
                #endregion
                
            } else {
                
                _skip = true;
                
                #region Colours
                
                //Test if it's a colour
                var _colour = __scribble_string_to_colour( _parameters[0] );
                if ( _colour != noone ) {
                            
                    _text_colour = _colour;
                            
                //Test if it's a hexcode
                } else {
                            
                    var _colour_string = string_upper( _parameters[0] );
                    if ( string_length( _colour_string ) <= 7 ) && ( string_copy( _colour_string, 1, 1 ) == "$" ) {
                                
                        var _hex = "0123456789ABCDEF";
                        var _red   = max( string_pos( string_copy( _colour_string, 3, 1 ), _hex )-1, 0 ) + ( max( string_pos( string_copy( _colour_string, 2, 1 ), _hex )-1, 0 ) << 4 );
                        var _green = max( string_pos( string_copy( _colour_string, 5, 1 ), _hex )-1, 0 ) + ( max( string_pos( string_copy( _colour_string, 4, 1 ), _hex )-1, 0 ) << 4 );
                        var _blue  = max( string_pos( string_copy( _colour_string, 7, 1 ), _hex )-1, 0 ) + ( max( string_pos( string_copy( _colour_string, 6, 1 ), _hex )-1, 0 ) << 4 );
                        _text_colour = make_colour_rgb( _red, _green, _blue );
                                
                    }
                            
                }
                
                #endregion
                        
            }
                
        }
        
            
    } else {
            
        _substr_width  = scribble_font_string_get_width(  _text_font, _substr );
        _substr_height = scribble_font_char_get_height(   _text_font, " " );
        //_substr_height = scribble_font_string_get_height( _text_font, _substr );
         
        #endregion
        
    }
    
    if ( !_skip ) {
        
        #region Position and store word
        
        //If we've run over the maximum width of the string
        if ( _substr_width + _text_x > _width_limit ) || ( _line_map == noone ) || ( _sep_prev_char == chr(13) ) || ( _force_newline ) {
            
            if ( _line_map != noone ) {
                
                _line_map[? "width"  ] = _text_x;
                _line_map[? "height" ] = _line_max_height;
                
                _text_x = 0;
                _text_y += _line_max_height;
                _line_length = 0;
                
                _line_max_height = _line_min_height;
                
            }
            
            if ( _map != noone ) {
                // _map still holds the previous word
                var _next_separator = _map[? "next separator" ];
                if ( _next_separator == " " ) || ( _next_separator == "[" ) {
                    _map[? "width" ] -= _font_space_width; //If the previous separation character was whitespace, correct the length of the previous word
                    _line_map[? "width" ] -= _font_space_width; //...and the previous line
                }
            }
            
            _line_map = ds_map_create();
            _line_list = ds_list_create();
            
            ds_list_add( _text_root_list, _line_map );
            ds_list_mark_as_map( _text_root_list, ds_list_size( _text_root_list )-1 );
            
            _line_map[? "x"      ] = 0;
            _line_map[? "y"      ] = _text_y;
            _line_map[? "width"  ] = 0;
            _line_map[? "height" ] = _line_min_height;
            _line_map[? "length" ] = 0;
            _line_map[? "halign" ] = _text_halign;
            ds_map_add_list( _line_map, "words", _line_list );
            
        }
        
        
        if ( !_force_newline ) && ( _substr != "" ) {
            
            _line_max_height = max( _line_max_height, _substr_height );
            
            //Add a new word
            _new_word = true;
            var _map = ds_map_create();
            _map[? "x"              ] = _text_x;
            _map[? "y"              ] = 0;
            _map[? "width"          ] = _substr_width;
            _map[? "height"         ] = _substr_height;
            _map[? "valign"         ] = fa_middle;
            _map[? "string"         ] = _substr;
            _map[? "input string"   ] = _input_substr;
            _map[? "sprite"         ] = _substr_sprite;
            _map[? "image"          ] = _substr_image;
            _map[? "sprite slot"    ] = _substr_sprite_slot;
            _map[? "length"         ] = _substr_length; //Include the separator character!
            _map[? "font"           ] = _text_font;
            _map[? "colour"         ] = _text_colour;
            _map[? "hyperlink"      ] = _text_hyperlink;
            _map[? "rainbow"        ] = _text_rainbow;
            _map[? "shake"          ] = _text_shake;
            _map[? "wave"           ] = _text_wave;
            _map[? "next separator" ] = "";
        
            //If we've got a word with a hyperlink, add it to our list of hyperlink regions
            if ( _text_hyperlink != "" ) {
                var _region_map = ds_map_create();
                _region_map[? "hyperlink" ] = _text_hyperlink;
                _region_map[? "line"      ] = ds_list_size( _text_root_list )-1;
                _region_map[? "word"      ] = ds_list_size( _line_list );
                ds_list_add( _hyperlink_regions_list, _region_map );
                ds_list_mark_as_map( _hyperlink_regions_list, ds_list_size( _hyperlink_regions_list )-1 );
            }
        
            //Add the word to the line list
            ds_list_add( _line_list, _map );
            ds_list_mark_as_map( _line_list, ds_list_size( _line_list )-1 );
        
        }
        
        _text_x += _substr_width;
        if ( _sep_char == " " ) _text_x += _font_space_width; //Add spacing if the separation character is a space
        
        if ( ( _sep_char == " " ) && _new_word && ( _substr != "" ) ) _map[? "width" ] += _font_space_width;
        
        _line_map[? "length" ] += _substr_length;
        if ( _substr_length > 0 ) _json[? "words" ]++;
        
        _json[? "length" ] += _substr_length;
        
        #endregion
        
    }
    
    //Find the next separator
    _sep_prev_char = _sep_char;
    _sep_char = "";
    _sep_pos = string_length( _str ) + 1;
    
    if ( _sep_prev_char == "[" ) {
        
        _result = __scribble_find_separator( _str, "]"    , _sep_char, _sep_pos ); _sep_char = _result[0]; _sep_pos = _result[1];
        
    } else {
        
        _result = __scribble_find_separator( _str, " "    , _sep_char, _sep_pos ); _sep_char = _result[0]; _sep_pos = _result[1];
        _result = __scribble_find_separator( _str, chr(13), _sep_char, _sep_pos ); _sep_char = _result[0]; _sep_pos = _result[1];
        _result = __scribble_find_separator( _str, "["    , _sep_char, _sep_pos ); _sep_char = _result[0]; _sep_pos = _result[1];
        
        if ( global.__scribble_cjk_wrapping ) {
            if ( _sep_pos > 1 ) {
                _sep_char = "";
                _sep_pos = 2;
            }
        }
        
    }
    
    if ( _new_word ) _map[? "next separator" ] = _sep_char;
    
}

//Finish defining the last line
_line_map[? "width"  ] = _text_x;
_line_map[? "height" ] = _line_max_height;
_json[? "lines" ] = ds_list_size( _json[? "lines list" ] );

#endregion



#region Set box width/height and adjust line positions

//Textbox width and height
var _lines_size = ds_list_size( _text_root_list );

var _textbox_width = 0;
for( var _i = 0; _i < _lines_size; _i++ ) {
    var _line_map = _text_root_list[| _i ];
    _textbox_width = max( _textbox_width, _line_map[? "width" ] );
}

var _line_map = _text_root_list[| _lines_size - 1 ];
var _textbox_height = _line_map[? "y" ] + _line_map[? "height" ];
  
_json[? "width" ]  = _textbox_width;
_json[? "height" ] = _textbox_height;

var _hyperlink_region_size = ds_list_size( _hyperlink_regions_list );

//Adjust word positions
for( var _i = 0; _i < _lines_size; _i++ ) {
    
    var _line_map = _text_root_list[| _i ];
    var _halign = _line_map[? "halign" ];
    
    switch( _halign ) {
        case fa_left:
            _line_map[? "x" ] = 0;
        break;
        case fa_center:
            _line_map[? "x" ] += ( _textbox_width - _line_map[? "width" ] ) div 2;
        break;
        case fa_right:
            _line_map[? "x" ] += _textbox_width - _line_map[? "width" ];
        break;
    }
    
    var _line_height = _line_map[? "height" ];
    var _word_list   = _line_map[? "words"  ];
    
    var _word_count = ds_list_size( _word_list );
    for( var _word = 0; _word < _word_count; _word++ ) {
        var _word_map = _word_list[| _word ];
        switch ( _word_map[? "valign" ] ) {
            case fa_top:
                _word_map[? "y" ] = 0;
            break;
            case fa_middle:
                _word_map[? "y" ] = ( _line_height - _word_map[? "height" ] ) div 2;
            break;
            case fa_bottom:
                _word_map[? "y" ] = _line_height - _word_map[? "height" ];
            break;
        }
    }
    
}

scribble_set_box_alignment( _json );

#endregion



#region Make vertex buffers

if ( _generate_vbuff ) scribble_rebuild_vertex_buffers( _json );

#endregion



show_debug_message( "scribble_create() took " + string( get_timer() - _timer ) + "us" );

return _json;
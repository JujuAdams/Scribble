/// @description Nicely formats a JSON string so it's easier to read
///
/// With thanks to yal.cc
///
/// @param json_string
/// @param [indent_size]
/// @param [newline_char]
/// @param [map_spacing]

var _json_string  = argument[0];
var _indent_size  = ((argument_count>1) && (argument[1]!=undefined))? argument[1] : 4;
var _newline_char = ((argument_count>2) && (argument[2]!=undefined))? argument[2] : chr(13) + chr(10);
var _map_space    = ((argument_count>3) && (argument[3]!=undefined))? argument[3] : 1;

var _in_string        = false;
var _string_escape    = false;
var _string_delimiter = undefined;

var _in_number_string = false;
var _number_string = "";
var _number_string_dot = 0;
var _number_string_last_sig = 0;

var _output = "";
var _indent = 0;

var _index = 0;
repeat( string_length( _json_string ) ) {
    _index++;
    
    var _char = string_char_at( _json_string, _index );
    var _ord = ord( _char );
    var _do_main = true;
    
    if ( _in_string ) {
        
        if ( ( _ord == _string_delimiter ) && !_string_escape ) {
            _in_string = false;
        } else if ( _ord == 92 ) && ( !_string_escape ) {
            _string_escape = true;
        } else {
            _string_escape = false;
        }
        
        _output += _char;
        _do_main = false;
        
    } else if ( _in_number_string ) {
        
        if ( _ord < 45 ) || ( _ord == 47 ) || ( _ord > 57 ) {
            
            _in_number_string = false;
            if ( _number_string_dot >= _number_string_last_sig ) _number_string_last_sig = _number_string_dot-1;
            _output += string_copy( _number_string, 1, _number_string_last_sig );
            
        } else {
            
            _do_main = false;
            _number_string += _char;
            
            if ( _ord == 46 ) {
                _number_string_dot = string_length( _number_string );
                _number_string_last_sig = _number_string_dot;
            } else if ( _number_string_dot == 0 ) || ( _ord != 48 ) {
                _number_string_last_sig++;
            }
            
        }
        
    }
    
    if ( _do_main ) switch( _ord ) {
        
        case 58: // :
            if ( _map_space ) {
                _output += ":";
                repeat( _map_space ) _output += " ";
            } else {
                _output += ":";
            }
        break;
        
        case 34: // "
        case 39: // '
            _string_delimiter = _ord;
            _in_string = true;
            _output += _char;
        break;
        
        case 44: // ,
            _output += _char;
            _output += _newline_char;
            repeat( _indent ) _output += " ";
        break;
        
        case  91: // [
        case 123: // {
            _output += _char;
            _indent += _indent_size;
            _output += _newline_char;
            repeat( _indent ) _output += " ";
        break;
        
        case  93: // ]
        case 125: // }
            _indent -= _indent_size;
            _output += _newline_char;
            repeat( _indent ) _output += " ";
            _output += _char;
        break;
        
        case  9: //remove whitespace
        case 10:
        case 11:
        case 12:
        case 13:
        case 32:
        break;
        
        case  45: // -
        case  46: // .
        case  48: // 0
        case  49: // 1
        case  50: // 2
        case  51: // 3
        case  52: // 4
        case  53: // 5
        case  54: // 6
        case  55: // 7
        case  56: // 8
        case  57: // 9
            _number_string = _char;
            _in_number_string = true;
            _number_string_dot = 0;
            _number_string_last_sig = 1;
        break;
        
        default:
            _output += _char;
        break;
        
    }
    
}

return _output;
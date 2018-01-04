/// @param separator
/// @param indent

var _separator = (( argument_count < 1 ) || ( argument[0] == undefined ))? NL   : argument[0];
var _indent    = (( argument_count < 2 ) || ( argument[1] == undefined ))? "  " : argument[1];

var _string = "";
var _array = debug_get_callstack();
var _size = array_length_1d( _array )-1;
for( var _i = 1; _i < _size; _i++ ) {
    repeat( _i ) _string += _indent;
    _string += string( _array[ _i ] ) + ((_i < _size-1)? _separator : "");
}
return _string;
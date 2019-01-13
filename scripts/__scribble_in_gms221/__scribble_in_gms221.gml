var _string = GM_runtime_version;

var _major = string_copy( _string, 1, string_pos( ".", _string )-1 );
_string = string_delete( _string, 1, string_pos( ".", _string ) );

var _minor = string_copy( _string, 1, string_pos( ".", _string )-1 );
_string = string_delete( _string, 1, string_pos( ".", _string ) );

var _patch = string_copy( _string, 1, string_pos( ".", _string )-1 );

var _rev = string_delete( _string, 1, string_pos( ".", _string ) );

if ( real( _major ) >= 2 ) && ( real( _minor ) >= 2 ) && ( real( _patch ) >= 1 ) return true;
return false;
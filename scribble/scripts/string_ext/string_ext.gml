/// @param value

if ( is_undefined( argument0 ) ) {
    return "<undefined>";
} else if ( is_string( argument0 ) ) {
    if ( argument0 == "" ) {
        return "<empty string>";
    } else {
        return argument0;
    }
} else {
    return string( argument0 );
}
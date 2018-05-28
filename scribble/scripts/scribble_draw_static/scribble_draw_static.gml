/// @param json
/// @param [shader]

if ( argument_count == 1 ) {
    return scribble_draw( argument[0], 0, 0 );
} else {
    return scribble_draw( argument[0], 0, 0, argument[1] );
}
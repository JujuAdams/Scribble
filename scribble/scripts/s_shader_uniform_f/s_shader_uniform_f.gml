/// @description Sets a float uniform in the current shader
/// @param uniform
/// @param data
/// @param [data...]

if ( global.shader_focus == undefined ) exit;

switch( argument_count ) {
    case 2: shader_set_uniform_f( shader_get_uniform( global.shader_focus, argument[0] ), argument[1] ); break;
    case 3: shader_set_uniform_f( shader_get_uniform( global.shader_focus, argument[0] ), argument[1], argument[2] ); break;
    case 4: shader_set_uniform_f( shader_get_uniform( global.shader_focus, argument[0] ), argument[1], argument[2], argument[3] ); break;
    case 5: shader_set_uniform_f( shader_get_uniform( global.shader_focus, argument[0] ), argument[1], argument[2], argument[3], argument[4] ); break;
    default: trace_error( "illegal number of arguments to script (", argument_count, ")" ); break;
}
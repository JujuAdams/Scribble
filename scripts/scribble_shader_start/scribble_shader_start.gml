/// @param [shader]

var _shader = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : SCRIBBLE_DEFAULT_SHADER;

shader_set( _shader );

shader_set_uniform_f( shader_get_uniform( shader_current(), "u_vColour" ), 1, 1, 1, 0 ); //RGB+mix
shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fAlpha"  ), 1 );

shader_set_uniform_f( shader_get_uniform( shader_current(), "u_vOptions" ), 0, 0, 0 );
shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fTime"    ), current_time/1000 );

shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fCharFadeT"          ), 1 );
shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fCharFadeSmoothness" ), 0 );

shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fLineFadeT"          ), 1 );
shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fLineFadeSmoothness" ), 0 );

shader_set_uniform_f( shader_get_uniform( shader_current(), "u_fHyperlinkOver"      ), -1 );
shader_set_uniform_f( shader_get_uniform( shader_current(), "u_vHyperlinkColour"    ), 1, 1, 1, 0 );
/// @param  scrollbox json 
//
//  April 2017
//  Juju Adams
//  julian.adams@email.com
//  @jujuadams
//
//  This code and engine are provided under the Creative Commons "Attribution - NonCommerical - ShareAlike" international license.
//  https://creativecommons.org/licenses/by-nc-sa/4.0/

var _scroll_json = argument0;

if ( surface_exists( _scroll_json[? "surface" ] ) ) tr_surface_free( _scroll_json[? "surface" ] );
tr_map_destroy( _scroll_json );

return noone;

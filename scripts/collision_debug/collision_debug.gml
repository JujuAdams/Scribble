/// @param sprite
/// @param index
/// @param filename

var _border = 2;

var _sprite   = argument0;
var _index    = argument1;
var _filename = argument2;

var _old_sprite = sprite_index;
var _old_index  = image_index;
var _old_mask   = mask_index;
var _old_x      = x;
var _old_y      = y;
var _old_xscale = image_yscale;
var _old_yscale = image_xscale;
var _old_angle  = image_angle;

sprite_index = _sprite;
image_index  = _index;
mask_index   = _sprite;
x            = sprite_get_xoffset( _sprite );
y            = sprite_get_yoffset( _sprite );
image_xscale = 1;
image_yscale = 1;
image_angle  = 0;

var _w  = sprite_get_width(  _sprite );
var _h  = sprite_get_height( _sprite );
var _surface = surface_create( _w+2*_border, _h+2*_border );

surface_set_target( _surface );

draw_sprite_stretched_ext( sPixel, 0, 0, 0, _w+2*_border, _h+2*_border, c_black, 1 );
draw_sprite_stretched_ext( sPixel, 0, 0, 0, _w+2*_border, _border, c_gray, 1 );
draw_sprite_stretched_ext( sPixel, 0, 0, 0, _border, _h+20, c_gray, 1 );
draw_sprite_stretched_ext( sPixel, 0, 0, _h+_border, _w+2*_border, _border, c_gray, 1 );
draw_sprite_stretched_ext( sPixel, 0, _w+_border, 0, _border, _h+2*_border, c_gray, 1 );

var _min_x = _w + _border + 1;
var _min_y = _h + _border + 1;
var _max_x = -_border - 1;
var _max_y = -_border - 1;

for( var _y = -_border; _y < _h+_border; _y++ )
{
    for( var _x = -_border; _x < _w+_border; _x++ )
    {
        if ( collision_point( _x, _y, id, true, false ) )
        {
            _min_x = min( _min_x, _x );
            _min_y = min( _min_y, _y );
            _max_x = max( _max_x, _x );
            _max_y = max( _max_y, _y );
            draw_sprite( sPixel, 0, _x+_border, _y+_border );
        }
    }
}
surface_reset_target();

surface_save( _surface, _filename );
surface_free( _surface );

sprite_index = _old_sprite;
image_index  = _old_index;
mask_index   = _old_mask;
x            = _old_x;
y            = _old_y;
image_yscale = _old_xscale;
image_xscale = _old_yscale;
image_angle  = _old_angle;

return [ _min_x, _min_y, _max_x, _max_y ];
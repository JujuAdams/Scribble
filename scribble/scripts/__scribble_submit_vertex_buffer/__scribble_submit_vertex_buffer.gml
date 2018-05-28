/// @param vbuff
/// @param texture
/// @param x
/// @param y

var _vbuff   = argument0;
var _texture = argument1;
var _x       = argument2;
var _y       = argument3;

if ( _x != 0 ) || ( _y != 0 ) {
    
    var _old_matrix = matrix_get( matrix_world );
    
    var _matrix;
    _matrix[15] =  1;
    _matrix[ 0] =  1;
    _matrix[ 5] =  1;
    _matrix[10] =  1;
    _matrix[12] = _x;
    _matrix[13] = _y;
    matrix_set( matrix_world, _matrix );
    
    vertex_submit( _vbuff, pr_trianglelist, _texture );
    
    matrix_set( matrix_world, _old_matrix );
    
} else {
    
    vertex_submit( _vbuff, pr_trianglelist, _texture );
    
}
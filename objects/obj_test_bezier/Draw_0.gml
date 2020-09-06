draw_primitive_begin(pr_linestrip);

var _t = 0;
var _inv_t = 1;
repeat(21)
{
    var _delta = _t / _inv_t;
    var _coeff = _inv_t*_inv_t*_inv_t;
    
    var _x = 0; 
    var _y = 0;
    
    _x += _coeff*x0;
    _y += _coeff*y0;
    _coeff *= _delta;
    _x += 3*_coeff*x1;
    _y += 3*_coeff*y1;
    _coeff *= _delta;
    _x += 3*_coeff*x2;
    _y += 3*_coeff*y2;
    _coeff *= _delta;
    _x += _coeff*x3;
    _y += _coeff*y3;
    
    draw_vertex(_x, _y);
    
    _t += 0.05;
    _inv_t -= 0.05;
}

draw_primitive_end();

//scribble_set_bezier(x1-x0, y1-y0, x2-x0, y2-y0, x3-x0, y3-y0);
scribble_draw(x0, y0, "woooow [wobble][spr_large_coin] Bezier curves in Scribble");
scribble_reset();
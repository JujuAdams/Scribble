draw_set_alpha(0.2);

draw_circle(x0, y0, 4, false);
draw_circle(x1, y1, 4, false);
draw_circle(x2, y2, 4, false);
draw_circle(x3, y3, 4, false);

draw_line(x0, y0, x1, y1);
draw_line(x1, y1, x2, y2);
draw_line(x2, y2, x3, y3);

draw_primitive_begin(pr_linestrip);

var _count = 20;
var _t = 0;
repeat(_count)
{
    var _inv_t = 1 - _t;
    draw_vertex(_inv_t*_inv_t*_inv_t*x0 + 3.0*_inv_t*_inv_t*_t*x1 + 3.0*_inv_t*_t*_t*x2 + _t*_t*_t*x3,
                _inv_t*_inv_t*_inv_t*y0 + 3.0*_inv_t*_inv_t*_t*y1 + 3.0*_inv_t*_t*_t*y2 + _t*_t*_t*y3);
    _t += 1/(_count-1);
}

draw_primitive_end();

draw_set_alpha(1.0);

scribble("[pin_center]woooow Bezier curves in Scribble! they even wrap and create new lines").bezier(x0, y0, x1, y1, x2, y2, x3, y3).draw(x0, y0);
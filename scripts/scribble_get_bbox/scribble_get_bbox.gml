/// Gets the position of the axis-aligned and oriented bounding box for a text element
/// 
/// Returns: 14-element array containing the positions of the bounding box for a text element
/// @param x                    x-position in the room that the text is being drawn at
/// @param y                    y-position in the room that the text is being drawn at
/// @param string/textElement   The text to get the bounding box for. Alternatively, you can pass a text element into this script
/// @param [leftMargin]         Extra space on the left-hand side of the textbox. Positive values create more space. Defaults to 0
/// @param [topMargin]          Extra space on the top of the textbox. Positive values create more space. Defaults to 0
/// @param [rightMargin]        Extra space on the right-hand side of the textbox. Positive values create more space. Defaults to 0
/// @param [bottomMargin]       Extra space on the bottom of the textbox. Positive values create more space. Defaults to 0
/// @param [occuranceName]      Unique identifier to differentiate particular occurances of a string within the game
/// 
/// To use the size of the current page rather than the size of the overall text element, please see scribble_set_box_align(),
/// specifically the [usePageSize] argument.
/// 
/// The array returned by scribble_get_bbox() has 14 elements as defined by the enum SCRIBBLE_BBOX.

function scribble_get_bbox()
{
	enum SCRIBBLE_BBOX
	{
	    L, T, R, B,
	    W, H,
	    X0, Y0, //Top left corner
	    X1, Y1, //Top right corner
	    X2, Y2, //Bottom left corner
	    X3, Y3, //Bottom right corner
	    __SIZE
	}

	var _x              = argument[0];
	var _y              = argument[1];
	var _scribble_array = argument[2];
	var _margin_l       = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 0;
	var _margin_t       = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 0;
	var _margin_r       = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : 0;
	var _margin_b       = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : 0;
    var _occurance_name = ((argument_count > 7) && (argument[7] != undefined))? argument[7] : SCRIBBLE_DEFAULT_OCCURANCE_NAME;

	if (is_string(_x) || is_array(_x))
	{
	    show_error("Scribble:\nThe argument order for scribble_get_bbox() has changed\nPlease review your code\n ", false);
	    exit;
	}
    
	_scribble_array = scribble_cache(_scribble_array);
	if (_scribble_array == undefined) return array_create(SCRIBBLE_BBOX.__SIZE, 0);
    
    if (global.scribble_state_box_align_page)
    {
        //Find our occurance data
        var _occurances_map = _scribble_array[SCRIBBLE.OCCURANCES_MAP];
        var _occurance_array = _occurances_map[? _occurance_name];
        
        //Find our page data
        var _element_pages_array = _scribble_array[SCRIBBLE.PAGES_ARRAY];
        var _page_array = _element_pages_array[_occurance_array[__SCRIBBLE_OCCURANCE.PAGE]];
        
        //Pull out our actual dimensions
        var _box_l = _page_array[__SCRIBBLE_PAGE.MIN_X ];
        var _box_r = _page_array[__SCRIBBLE_PAGE.MAX_X ];
        var _box_w = _page_array[__SCRIBBLE_PAGE.WIDTH ];
        var _box_h = _page_array[__SCRIBBLE_PAGE.HEIGHT];
    }
    else
    {
        var _box_l = _scribble_array[SCRIBBLE.MIN_X ];
        var _box_r = _scribble_array[SCRIBBLE.MAX_X ];
        var _box_w = _scribble_array[SCRIBBLE.WIDTH ];
        var _box_h = _scribble_array[SCRIBBLE.HEIGHT];
    }
    
	switch(global.scribble_state_box_halign)
	{
	    case fa_center:
            _box_l -= _box_w div 2;
            _box_r -= _box_w div 2;
	    break;
        
	    case fa_right:
            _box_l -= _box_w;
            _box_r -= _box_w;
	    break;
	}
    
    var _valign = global.scribble_state_box_valign;
    if (_valign == fa_top) _valign = _scribble_array[SCRIBBLE.VALIGN];
    
	switch(_valign)
	{
	    case fa_top:
	        var _box_t = 0;
            var _box_b = _box_h;
	    break;
        
	    case fa_middle:
            var _box_t = -(_box_h div 2);
	        var _box_b = -_box_t;
	    break;
        
	    case fa_bottom:
            var _box_t = -_box_h;
	        var _box_b = 0;
	    break;
	}

	if ((global.scribble_state_xscale == 1)
	&&  (global.scribble_state_yscale == 1)
	&&  (global.scribble_state_angle == 0))
	{
	    //Avoid using matrices if we can
	    var _l = _x + _box_l - _margin_l;
	    var _t = _y + _box_t - _margin_t;
	    var _r = _x + _box_r + _margin_r;
	    var _b = _y + _box_b + _margin_b;
    
	    var _x0 = _l;   var _y0 = _t;
	    var _x1 = _r;   var _y1 = _t;
	    var _x2 = _l;   var _y2 = _b;
	    var _x3 = _r;   var _y3 = _b;
	}
	else
	{
        //TODO - Make this faster with custom code
	    var _matrix = matrix_build(_x, _y, 0, 
	                               0, 0, global.scribble_state_angle,
	                               global.scribble_state_xscale, global.scribble_state_yscale, 1);
    
	    var _l = _box_l - _margin_l;
	    var _t = _box_t - _margin_t;
	    var _r = _box_r + _margin_r;
	    var _b = _box_b + _margin_b;
    
	    var _vertex = matrix_transform_vertex(_matrix, _l, _t, 0); var _x0 = _vertex[0]; var _y0 = _vertex[1];
	    var _vertex = matrix_transform_vertex(_matrix, _r, _t, 0); var _x1 = _vertex[0]; var _y1 = _vertex[1];
	    var _vertex = matrix_transform_vertex(_matrix, _l, _b, 0); var _x2 = _vertex[0]; var _y2 = _vertex[1];
	    var _vertex = matrix_transform_vertex(_matrix, _r, _b, 0); var _x3 = _vertex[0]; var _y3 = _vertex[1];
    
	    var _l = min(_x0, _x1, _x2, _x3);
	    var _t = min(_y0, _y1, _y2, _y3);
	    var _r = max(_x0, _x1, _x2, _x3);
	    var _b = max(_y0, _y1, _y2, _y3);
	}

	var _w = 1 + _r - _l;
	var _h = 1 + _b - _t;

	return [ _l,  _t,
	         _r,  _b,
	         _w,  _h,
	        _x0, _y0,
	        _x1, _y1,
	        _x2, _y2,
	        _x3, _y3 ];
}
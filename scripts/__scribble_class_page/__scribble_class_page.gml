enum __SCRIBBLE_PAGE
{
	LINES,                // 0
	START_CHAR,           // 1
	LAST_CHAR,            // 2
	LINES_ARRAY,          // 3
	VERTEX_BUFFERS_ARRAY, // 4
    START_EVENT,          // 5
    MAX_X,                // 6
    MIN_X,                // 7
    WIDTH,                // 8
    HEIGHT,               // 9
	__SIZE
}

function __scribble_class_page() constructor
{
    lines               = 0;
    start_char          = undefined;
    last_char           = undefined;
    lines_array         = [];
    vertex_buffer_array = [];
    start_event         = undefined;
    max_x               = 0;
    min_x               = 0;
    width               = 0;
    height              = 0;
}
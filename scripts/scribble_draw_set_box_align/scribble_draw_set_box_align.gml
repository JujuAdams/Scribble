function scribble_draw_set_box_align(argument0, argument1) {
	if (SCRIBBLE_WARNING_DRAW_SET_DEPRECATED)
	{
	    show_error("Scribble:\scribble_draw_set_box_align() has been deprecated, please use scribble_set_box_align()\n(Set SCRIBBLE_WARNING_DRAW_SET_DEPRECATED to <false> to hide this message)\n ", false);
	}

	return scribble_set_box_align(argument0, argument1);


}

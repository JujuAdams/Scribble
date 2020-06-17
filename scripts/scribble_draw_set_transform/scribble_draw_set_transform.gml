function scribble_draw_set_transform(argument0, argument1, argument2) {
	if (SCRIBBLE_WARNING_DRAW_SET_DEPRECATED)
	{
	    show_error("Scribble:\scribble_draw_set_transform() has been deprecated, please use scribble_set_transform()\n(Set SCRIBBLE_WARNING_DRAW_SET_DEPRECATED to <false> to hide this message)\n ", false);
	}

	return scribble_set_transform(argument0, argument1, argument2);


}

///// @param element
//
//global.__scribble_generator_state = {};
//
//function __scribble_generate_model(_element)
//{
//    with(global.__scribble_generator_state)
//    {
//        element          = _element;
//        glyph_count      = 0;
//        control_count    = 0;
//        word_count       = 0;
//        line_count       = 0;
//        line_height_min  = 0;
//        line_height_max  = 0;
//        model_max_width  = 0;
//        model_max_height = 0;
//        
//        bezier_lengths_array = undefined;
//    };
//    
//    __scribble_generator_model_limits_and_bezier_curves()
//    __scribble_generator_line_heights();
//    __scribble_generator_parser();
//    __scribble_generator_build_words();
//    __scribble_generator_build_pages();
//    __scribble_generator_position_words();
//    __scribble_generator_write_vbuffs();
//    
//    //Wipe the control grid so we don't accidentally hold references to event structs
//    ds_grid_clear(global.__scribble_control_grid, 0);
//    
//    return true;
//}
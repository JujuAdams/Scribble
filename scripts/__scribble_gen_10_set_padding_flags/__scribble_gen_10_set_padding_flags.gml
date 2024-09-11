// Feather disable all
function __scribble_gen_10_set_padding_flags()
{
    static _generator_state = __scribble_initialize().__generator_state;
    with(_generator_state)
    {
        var _uses_halign_left   = __uses_halign_left;
        var _uses_halign_center = __uses_halign_center;
        var _uses_halign_right  = __uses_halign_right;
    }
    
    //Figure out how to pad the bounding box based on what alignments have been used
    switch(__valign)
    {
        case fa_top:    __pad_bbox_t = false; __pad_bbox_b = true;  break;
        case fa_middle: __pad_bbox_t = true;  __pad_bbox_b = true;  break;
        case fa_bottom: __pad_bbox_t = true;  __pad_bbox_b = false; break;
    }
    
    if (_uses_halign_center)
    {
        __pad_bbox_l = true;
        __pad_bbox_r = true;
    }
    else if (_uses_halign_left)
    {
        if (_uses_halign_right)
        {
            __pad_bbox_l = true;
            __pad_bbox_r = true;
        }
        else
        {
            __pad_bbox_l = false;
            __pad_bbox_r = true;
        }
    }
    else if (_uses_halign_right)
    {
        __pad_bbox_l = true;
        __pad_bbox_r = false;
    }
    else
    {
        __pad_bbox_l = false;
        __pad_bbox_r = true;
    }
}

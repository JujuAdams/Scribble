/// Sets Scribble's box horizontal alignment state
/// 
/// @param boxHAlign       Horizontal alignment of the text element relative to the text element's origin. Accepts fa_left, fa_right, and fa_center
/// @param boxVAlign       Vertical alignment of the text element relative to the text element's origin. Accepts fa_top, fa_bottom, and fa_middle
/// @param [usePageSize]   Whether to use the size of a page rather than the size of the whole text element. Defaults to <false>
/// 
/// Setting either argument to <undefined> or a value less than 0 will not set the alignment for a particular axis.
/// e.g. to only set the vertical alignment:
///     scribble_set_box_align(-1, fa_bottom);
/// 
/// This script sets Scribble's draw state. All text drawn with scribble_draw() will use these settings until they're overwritten, either by
/// calling this script again or by calling scribble_reset() or scribble_set_state().

function scribble_set_box_align()
{
    if ((argument[0] != undefined) && (argument[0] >= 0)) global.scribble_state_box_halign = argument[0];
    if ((argument[1] != undefined) && (argument[1] >= 0)) global.scribble_state_box_valign = argument[1];
    if ((argument_count > 2) && (argument[2] != undefined) && (argument[2] >= 0)) global.scribble_state_box_align_page = argument[2];
}
//Scaling values passed to Scribblet*Ext functions will scale up and down text. However, you may
//not want to scale sprites that have been inserted into the string in the same way. Setting this
//macro to <false> will keep sprites unscaled (scaling factor = 1) relative to the specified text
//scale.
//
// N.B. If ScribbletShrinkExt() or ScribbletFitExt() require the string to be scaled down then
//      sprites will be scaled down regardless of this macro's value.
#macro SCRIBBLET_SCALE_SPRITES  true

//Whether to reset draw state after Scribblet calls. This will slighly negatively impact
//performance but is convenient.
#macro SCRIBBLET_RESET_DRAW_STATE  true

//How many iterations to perform when fitting text inside the bounding box. This only applies to
//ScribbletFit() and ScribbletFitExt(). Higher numbers are more accurate but slower.
#macro SCRIBBLET_FIT_ITERATIONS  6

//Whether to progressively build vertex buffers. This distributes the up-front cost of building
//vertex buffers over a few frames. Setting this macro to <false> will instead build vertex buffers
//entirely on the first frame that Scribblet draws some text.
#macro SCRIBBLET_PROGRESSIVE_BUILD  true

//Amount of time per frame that Scribblet is allowed to build vertex buffers. This limit is
//approximate. If SCRIBBLET_PROGRESSIVE_BUILD is set to <false> then this limit will not apply.
#macro SCRIBBLET_BUDGET  200 //microseconds

//How many glyphs to write per text element per frame during progressive building. Higher values
//will build vertex buffers faster but may cause Scribblet to exceed the time budget.
#macro SCRIBBLET_BUILD_GLYPH_ITERATIONS  20

//Default "forceNative" value for Scribblet draw calls. Settings this macro to <true> will force
//draw calls to use GameMaker's native draw calls. This is useful if you don't want to use
//Scribblet's vertex buffer implementation at all.
#macro SCRIBBLET_DEFAULT_FORCE_NATIVE  false

//Whether to emit lots of additional debug messages to help track Scribblet's behaviour.
#macro SCRIBBLET_VERBOSE  false

//Functions to call when Scribblet emits messages. Change these if you want to redirect Scribblet
//messages to something other than the console / native error handler.
#macro SCRIBBLET_SHOW_DEBUG_MESSAGE  show_debug_message //Warnings and general information
#macro SCRIBBLET_SHOW_ERROR          show_error         //Fatal errors
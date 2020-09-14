/// Defines an event - a script that can be executed (with parameters) by an in-line command tag
/// 
/// @param name              Name of the new formatting tag to add e.g. portrait adds the tag [portrait] for use
/// @param function/method   Function or method to execute
/// 
/// Events are scripts that are executed during an autotype fade in animation. As each character is revealed,
/// Scribble will check if any events are present at that position in the text and, if so, Scribble will
/// immediately execute that script. This can be used for many purposes including triggering sound effects,
/// changing character portraits, starting movement of instances, starting weather effects, giving the player
/// items, and so on.
/// 
/// It is possible to send parameters into an executed script from your text. Parameters passed into event
/// scripts are only ever strings. The syntax is similar to normal GameMaker functions; [popup,0.1,0.2,hello world]
/// has three parameters: 0.1, 0.2, and hello world, all of which are strings.
/// 
/// 
/// Event scripts are executed with two arguments:
///   0.  Text element that caused the script to be executed
///   1.  An array of strings that contains the parameters defined in the text. See above
/// 
/// Your script should be formatted such that they can unpack parameters from the provided array. Scripts are
/// executed in the scope of the instance that ran scribble_draw() and in the associated GameMaker object event
/// (typically the Draw event).
/// 
/// 
/// Here's an example. Let's say we run this code in the Create event of an object:
///    scribble_autotype_add_event("rumble", callbackRumble);
///    element = scribble_draw("Here's some[rumble,0.2] rumble!);
///    scribble_autotype_fade_in(element, 0.5, 0, false);
/// 
/// And then in the Draw event we run:
///    scribble_draw(x, y, element);
/// 
/// The object will draw the text Here's some rumble!, slowly revealling the text character by character.
/// When the e of the word some is displayed, Scribble will automatically call the script callbackRumble().
/// 
///    /// description callbackRumble(element, parameterArray)
///    /// param element
///    /// param parameterArray
///    
///    var _element = argument0; //Not used but good practice to label it
///    var _parameter_array = argument1;
///    
///    var _amount = real(_parameter_array[0]);
///    gamepad_set_vibration(global.current_gamepad, _amount, _amount);
/// 
/// Here, callbackRumble() will fetch the parameter from the array and use it to vibrate the player's
/// gamepad. Given that the formatting tag was [rumble,0.2], the function gamepad_set_vibration() will be
/// given 0.2 as its input value.

function scribble_add_autotype_event(_name, _function)
{
	if (!variable_global_exists("__scribble_lcg"))
	{
	    show_error("Scribble:\nscribble_add_event() should be called after initialising Scribble.\n ", false);
	    exit;
	}
    
	if (!is_string(_name))
	{
	    show_error("Scribble:\nEvent names should be strings.\n(Input to script was \"" + string(_name) + "\")\n ", false);
	    exit;
	}
    
	if (!is_method(_function))
	{
        if (is_real(_function))
        {
            if (!script_exists(_function))
            {
        	    show_error("Scribble:\nScript with asset index " + string(_function) + " doesn't exist\n ", false);
        	    exit;
            }
        }
        else
        {
    	    show_error("Scribble:\nInvalid function provided\n(Input datatype was \"" + typeof(_function) + "\")\n ", false);
    	    exit;
        }
	}
    
	if (ds_map_exists(global.__scribble_colours, _name))
	{
	    show_debug_message("Scribble: WARNING! Event name \"" + _name + "\" has already been defined as a colour");
	    exit;
	}
    
	if (ds_map_exists(global.__scribble_effects, _name))
	{
	    show_debug_message("Scribble: WARNING! Event name \"" + _name + "\" has already been defined as an effect");
	    exit;
	}
    
	var _old_function = global.__scribble_autotype_events[? _name];
	if (!is_undefined(_old_function))
	{
	    show_debug_message("Scribble: WARNING! Overwriting event [" + _name + "] tied to \"" + (is_method(_old_function)? string(_old_function) : script_get_name(_old_function)) + "\"");
	}
    
	global.__scribble_autotype_events[? _name] = _function;
	if (SCRIBBLE_VERBOSE) show_debug_message("Scribble: Tying event [" + _name + "] to \"" + (is_method(_function)? string(_function) : script_get_name(_function)) + "\"");
}
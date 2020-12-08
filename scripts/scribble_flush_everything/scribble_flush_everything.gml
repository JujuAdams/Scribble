/// This function will clear out all memory that Scribble is currently using. You will not normally need
/// to call this function (Scribble automatically garbage collects resources that haven't been used recently)
/// but it's occasionally useful when you need memory to be available immediately.

function scribble_flush_everything()
{
    //Flush all models
    var _i = 0;
    repeat(array_length(global.__scribble_mcache_array))
    {
        global.__scribble_mcache_array[_i].flush();
        ++_i;
    }
    
    global.__scribble_mcache_dict       = {};
    global.__scribble_mcache_array      = [];
    global.__scribble_mcache_test_index = 0;
    
    //Flush elements
    var _i = 0;
    repeat(array_length(global.__scribble_ecache_array))
    {
        global.__scribble_ecache_array[_i].flush();
        ++_i;
    }
    
    global.__scribble_ecache_dict       = {};
    global.__scribble_ecache_array      = [];
    global.__scribble_ecache_test_index = 0;
}
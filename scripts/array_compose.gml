/// array_compose(argument0 .. argument1);
// because gms1 doesn't let you define arrays like [a, b, c]

// if only?
//return array_copy(array, 0, argument, 0, argument_count);

var array = array_create(argument_count);

for (var i = 0; i < argument_count; i++){
    array[i] = argument[i];
}

return array;

//! Currently broken b/c I am a dumb dumb
const std = @import("std");
//const stdio = std.io.getStdOut().writer();
const print = std.debug.print;

pub fn quicksort(slice: []u17) void {
    if (slice.len <= 1) {
        return;
    }

    const pivot = slice[slice.len - 1];

    var left_pivot: usize = 0;
    for (0..slice.len) |right_pivot| {
        if (slice[right_pivot] > pivot) {
            continue;
        } else if (slice[right_pivot] <= pivot) {
            const new_right_pivot: u17 = slice[left_pivot];
            slice[left_pivot] = slice[right_pivot];
            slice[right_pivot] = new_right_pivot;
            left_pivot += 1;
        }
    }
    left_pivot -= 1; // This accounts for the offset that usize denies us.

    //left_pivot should be the final position of the pivot at the end of the loop
    quicksort(slice[0..left_pivot]);
    quicksort(slice[left_pivot + 1 ..]);
}

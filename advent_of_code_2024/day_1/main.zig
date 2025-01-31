const std = @import("std");
const quicksort = @import("quicksort.zig").quicksort;
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var array = [_]u32{ 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 };
    try stdout.print("{any}\n", .{array});
    quicksort(&array);
    try stdout.print("{any}\n", .{array});
}

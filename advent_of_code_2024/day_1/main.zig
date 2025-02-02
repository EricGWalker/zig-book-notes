const std = @import("std");
const quicksort = @import("quicksort.zig").quicksort;
const stdout = std.io.getStdOut().writer();
const test_allocator = std.testing.allocator;

pub fn main() !void {
    const puzzle_input = try std.fs.cwd().openFile("puzzle_input.txt", .{});
    defer puzzle_input.close();

    var buffered_reader = std.io.bufferedReader(puzzle_input.reader());

    var content_buffer: [14]u8 = undefined; //size is 14 b/c each line of puzzle_input has 14 chars.
    @memset(content_buffer[0..], 0);

    const contents = try buffered_reader.reader().readUntilDelimiterOrEof(content_buffer[0..], '\n');

    try stdout.print("{?s}", .{contents});
}

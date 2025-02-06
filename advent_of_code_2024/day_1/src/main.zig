//! This file is going to be allocating memory based off of obvious known inputs from the puzzle
//! Notably, that each column is 1000 lines long, and the indices for where each number is on a line.
//! This is not the best general purpose solution
//! Something more general would probably use a minheap instead of quicksort to save on memory and time complexity
//! (Arraylists would cost extra memory, hand initializing two 1000 len arrays saves the need to read the file 2x)
//!
//! The following code is produced from reading the book linked in this github's ./README.md as well as
//! with the assistance of conversationally interacting with claude 3.5 sonnet
//! that being said, everything written here, is something that I spent the time to understand.

const std = @import("std");
const quicksort = @import("quicksort.zig").quicksort;
const stdout = std.io.getStdOut().writer();

const column_length: usize = 1000;

fn loadColumns(column_1: *[column_length]u17, column_2: *[column_length]u17) !void {
    const puzzle_input = try std.fs.cwd().openFile("puzzle_input.txt", .{});
    defer puzzle_input.close();

    var buffered_reader = std.io.bufferedReaderSize(8192, puzzle_input.reader()); // allocating 8192 bytes b/c file is 14kb
    const in_stream = buffered_reader.reader();

    var content_buffer: [14]u8 = [_]u8{0} ** 14;

    for (0..column_length) |i| {
        if (try in_stream.readUntilDelimiterOrEof(&content_buffer, '\n')) |line| {
            const column_1_str = @as([]const u8, line[0..5]);
            const column_2_str = @as([]const u8, line[8..13]);
            column_1[i] = try std.fmt.parseUnsigned(u17, column_1_str, 10);
            column_2[i] = try std.fmt.parseUnsigned(u17, column_2_str, 10);
        } else {
            return error.UnexpectedEOF;
        }
    }
}

fn iterAdd(column_1: *[column_length]u17, column_2: *[column_length]u17) !u64 {
    var total_distance: u64 = 0;

    for (column_1[0..], column_2[0..]) |col1_value, col2_value| {
        //lazy eric
        const inner_distance: u17 = @max(col1_value, col2_value) - @min(col1_value, col2_value);
        total_distance += @as(u64, inner_distance);
    }

    return total_distance;
}

/// This is the function that solves the advent of code question part 2
/// This day's code is crude so that I can just move on and start fresh on another project.
fn similarityScore2(allocator: std.mem.Allocator, column_1: *[column_length]u17, column_2: *[column_length]u17) !u64 {
    var hashmap = std.AutoHashMap(u17, u64).init(allocator);
    defer hashmap.deinit();

    // Initialize hashmap with column 1 as keys
    for (column_1[0..]) |col1_value| {
        try hashmap.put(col1_value, 0);
    }

    for (column_2[0..]) |col2_value| {
        const ptr = hashmap.getPtr(col2_value);
        if (ptr) |value_ptr| {
            value_ptr.* = value_ptr.* + 1;
        }
    }

    var total_distance: u64 = 0;
    var iterator = hashmap.iterator();
    while (iterator.next()) |kvp| {
        total_distance += kvp.key_ptr.* * kvp.value_ptr.*;
    }

    return total_distance;
}

pub fn main() !void {
    var column_1: [1000]u17 = [_]u17{0} ** 1000;
    var column_2: [1000]u17 = [_]u17{0} ** 1000;

    try stdout.print("LOADING COLUMNS\n", .{});
    try loadColumns(&column_1, &column_2);

    try stdout.print("SORTING COLUMNS\n", .{});
    quicksort(&column_1);
    quicksort(&column_2);

    try stdout.print("CALCULATING TOTAL DISTANCE\n", .{});
    const total_distance: u64 = try iterAdd(&column_1, &column_2);

    try stdout.print("Problem 1:\n", .{});
    try stdout.print("Total distance is {d}\n", .{total_distance});

    try stdout.print("Problem 2:\n", .{});
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const total_distance2 = try similarityScore2(allocator, &column_1, &column_2);
    try stdout.print("Distance 2 is:\n{any}\n", .{total_distance2});
}

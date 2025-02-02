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
const dprint = std.debug.print;

const column_length: usize = 1000;

fn loadColumns(column_1: *[column_length]u17, column_2: *[column_length]u17) !void {
    const puzzle_input = try std.fs.cwd().openFile("puzzle_input.txt", .{});
    defer puzzle_input.close();

    var buffered_reader = std.io.bufferedReaderSize(8192, puzzle_input.reader()); // allocating 8192 bytes b/c file is 14kb
    const in_stream = buffered_reader.reader();

    var content_buffer: [14]u8 = [_]u8{0} ** 14;

    for (0..column_length) |i| {
        dprint("{d}", .{i});
        if (try in_stream.readUntilDelimiterOrEof(&content_buffer, '\n')) |line| {
            dprint("{any}\n", .{line[1..6]});
            dprint("{any}\n", .{@TypeOf(line[1..6])});
            // column_1[i] = try std.fmt.parseUnsigned(u17, line[1..6], 10);
            // column_2[i] = try std.fmt.parseUnsigned(u17, line[9..14], 10);
            _ = column_1;
            _ = column_2;
        } else {
            return error.UnexpectedEOF;
        }
    }
}

pub fn main() !void {
    var column_1: [1000]u17 = [_]u17{0} ** 1000;
    var column_2: [1000]u17 = [_]u17{0} ** 1000;

    try stdout.print("Column 1: {any}\n", .{column_1});
    try stdout.print("Column 2: {any}\n", .{column_2});

    try loadColumns(&column_1, &column_2);

    try stdout.print("Column 1: {any}\n", .{column_1});
    try stdout.print("Column 2: {any}\n", .{column_2});
}

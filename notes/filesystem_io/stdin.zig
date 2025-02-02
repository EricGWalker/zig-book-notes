const std = @import("std");
const stdout = std.io.getStdOut().writer(); //GenericWriter Object
const stdin = std.io.getStdIn().reader(); //GenericReader Object
//Generic Readers and Writers are not buffered,
//this means that they make a lot of syscalls
//thus resulting in slow performance

pub fn main() !void {
    try stdout.writeAll("Type your name\n");
    var buffer: [20]u8 = undefined;
    @memset(buffer[0..], 0);
    _ = try stdin.readUntilDelimiterOrEof(buffer[0..], '\n');
    try stdout.print("Your name is: {s}\n", .{buffer});
}

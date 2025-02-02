const std = @import("std"); //standard library
const stdout = std.io.getStdOut().writer(); //stdout is a file descriptor, .writer makes it a generic writer
pub fn main() !void {
    try stdout.writeAll("This message was written into stdout.\n");
}

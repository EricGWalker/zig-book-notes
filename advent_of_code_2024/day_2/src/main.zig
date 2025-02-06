const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    const file = std.fs.cwd().openFile("puzzle_input.txt", .{}) catch |err| {
        std.log.err("Failed to open file: {s}", .{@errorName(err)});
        return;
    };
    defer file.close();

    var safe_reports: usize = 0;
    file_reader: while (file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', std.math.maxInt(usize)) catch |err| {
        std.log.err("Failed to read line: {s}", .{@errorName(err)});
        return;
    }) |line| {
        defer allocator.free(line);
        var iterator = std.mem.splitSequence(u8, line, " ");

        const states = enum { init, increase, decrease };
        var state = states.init;
        var previous_value: i8 = 0;
        while (iterator.next()) |digit_str| {
            std.debug.print("{s} ", .{digit_str});
            switch (state) {
                states.init => {
                    const current_value = try std.fmt.parseInt(i8, digit_str, 10);
                    const next_value = try std.fmt.parseInt(i8, iterator.next().?, 10);
                    std.debug.print("{any} ", .{next_value});
                    const diff = current_value - next_value;

                    switch (diff) {
                        -3...-1 => {
                            state = states.decrease;
                            previous_value = next_value;
                        },
                        1...3 => {
                            state = states.increase;
                            previous_value = next_value;
                        },
                        else => {
                            std.debug.print(" bad sequence\n", .{});
                            continue :file_reader;
                        },
                    }
                },
                states.increase => {
                    const next_value = try std.fmt.parseInt(i8, digit_str, 10);
                    const diff = previous_value - next_value;

                    switch (diff) {
                        1...3 => {
                            previous_value = next_value;
                        },
                        else => {
                            std.debug.print(" bad sequence\n", .{});
                            continue :file_reader;
                        },
                    }
                },
                states.decrease => {
                    const next_value = try std.fmt.parseInt(i8, digit_str, 10);
                    const diff = previous_value - next_value;

                    switch (diff) {
                        -3...-1 => {
                            previous_value = next_value;
                        },
                        else => {
                            std.debug.print(" bad sequence\n", .{});
                            continue :file_reader;
                        },
                    }
                },
            }
        }
        std.debug.print(" Good Sequence\n", .{});
        safe_reports += 1;
    }

    try std.io.getStdOut().writer().print("Total Safe Reports = {any}", .{safe_reports});
}

const std = @import("std");
const stdout = std.io.getStdOut().writer();
const states = enum {
    increase_inbounds,
    decrease_inbounds,
    increase_outbounds,
    decrease_outbounds,
    nochange,

    pub fn checkPair(first: i8, second: i8) states {
        const diff = second - first;
        switch (diff) {
            0 => {
                return states.nochange;
            },
            1...3 => {
                return states.increase_inbounds;
            },
            -3...-1 => {
                return states.decrease_inbounds;
            },
            else => {
                if (diff > 3) {
                    return states.increase_outbounds;
                } else if (diff < -3) {
                    return states.decrease_outbounds;
                } else unreachable;
            },
        }
    }
};

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
    var no_strike_safe_reports: usize = 0;
    line_reader: while (file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', std.math.maxInt(usize)) catch |err| {
        std.log.err("Failed to read line: {s}", .{@errorName(err)});
        return;
    }) |line| {
        defer allocator.free(line);
        var iterator = std.mem.splitSequence(u8, line, " ");
        // Initialize with first value
        var previous_value = try std.fmt.parseInt(i8, iterator.next().?, 10);
        var previous_state: states = states.checkPair(previous_value, try std.fmt.parseInt(i8, iterator.peek().?, 10));
        var strike: bool = false;
        while (iterator.next()) |digit_str| {
            const next_value = try std.fmt.parseInt(i8, digit_str, 10);
            const next_state = states.checkPair(previous_value, next_value);
            switch (strike) {
                false => {
                    strike = (next_state == states.increase_outbounds or
                        next_state == states.decrease_outbounds or
                        next_state == states.nochange);
                    if (previous_state != next_state) {
                        previous_state = next_state;
                        strike = true;
                    }
                },
                true => {
                    switch (previous_state) {
                        states.increase_outbounds, states.decrease_outbounds, states.nochange => {
                            continue :line_reader;
                        },
                        else => {},
                    }
                },
            }
            previous_value = next_value;
            // This line shouldn't be needed, but I'm leaving it incase I need to uncomment it to get a different answer
            previous_state = next_state;
        }

        safe_reports += 1;
        no_strike_safe_reports += if (strike) 0 else 1;
    }
    try std.io.getStdOut().writer().print("Total Safe Reports = {any}\n", .{safe_reports});
    try std.io.getStdOut().writer().print("Total Safe No Strike Reports = {any}\n", .{no_strike_safe_reports});
}

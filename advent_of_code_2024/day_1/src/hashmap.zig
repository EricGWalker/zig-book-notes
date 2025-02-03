const std = @import("std");
const dprint = std.debug.print;
pub fn KeyValuePair(comptime K: type, comptime V: type) type {
    return struct {
        key: K,
        value: V,

        pub fn init(key: K, value: V) void {
            return .{
                .key = key,
                .value = value,
            };
        }
    };
}

pub fn HashMap (
    comptime K: type,
    comptime V: type,
    comptime allocator: std.mem.Allocator,
    comptime rehash_threshold_percent: u64,
) type {
    const KVPair: type = KeyValuePair(K, V);

    return struct {
        //wip when I get back
    };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var allocator = gpa.allocator();

    const arraylist = try allocator.alloc(u8, 8);
    defer allocator.free(arraylist);

    var hasher1 = std.hash.Wyhash.init(0);
    std.hash.autoHash(&hasher1, @as(u8, 10));
    dprint("{any}\n", .{hasher1.final()});

    var hasher2 = std.hash.Wyhash.init(0);
    std.hash.autoHash(&hasher2, @as(u8, 10));
    dprint("{any}\n", .{hasher2.final()});
}

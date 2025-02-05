const std = @import("std");
const dprint = std.debug.print;

///Creates a KeyValuePair struct with attributes .key and .value
pub fn KeyValuePair(comptime K: type, comptime V: type) type {
    return struct {
        /// I couldn't find the right way to make key immutible
        /// so please don't mutate it :)
        key: K,
        value: V,

        const Self = @This();
        pub fn init(k: K, v: V) Self {
            return .{
                .key = k,
                .value = v,
            };
        }
    };
}

pub fn HashMap(
    comptime KVPair: type,
    comptime allocator: std.mem.Allocator,
    /// Legal values lie on the range: 1...100
    comptime rehash_threshold_percent: usize,
) !type {
    if (rehash_threshold_percent > 100 or rehash_threshold_percent < 1) {
        @compileError("rehash_threshold_percent must lie on the range 1...100 (inclusive)");
    }
    if (!@hasField(KVPair, "key")) {
        @compileError("KVPair must have field 'key'");
    }
    if (!@hasField(KVPair, "value")) {
        @compileError("KVPair must have field 'value'");
    }

    return struct {
        /// Number of elements in the hashmap;
        var size: usize = 0;
        const KVPairList: type = std.SinglyLinkedList(KVPair);
        var array: []KVPairList = allocator.alloc(KVPairList, 1);
        const Self = @This();
        /// Only way I learned how to get the datatype of the key field
        /// was by asking Claude
        /// I actually understand this line, but I would not have known
        /// I could write it without artificial knowledge
        const KeyType = @typeInfo(KVPair).Struct.fields[0].type;

        ///Free's array from allocator and destroys self
        pub fn deinit(self: *Self) void {
            allocator.free(array);
            self.* = undefined; // stole this from std.heap.GeneralPurposeAllocator's deinit function
        }
        fn exceedsThreshold() bool {
            const threshold: usize = array.len * rehash_threshold_percent / 100;
            return size >= threshold;
        }
        fn indexOf(key: KeyType) usize {
            var hasher = std.hash.Wyhash.init(0);
            std.hash.autoHash(&hasher, key);
            const key_hash = hasher.final();
            const index: usize = @intCast(key_hash % array.len);
            return index;
        }
        /// insert a new KVPair
        /// O(N) where N is the number of collisions, so it should be small
        pub fn insert(pair: KVPair) !void {
            const index: usize = indexOf(pair.key);
            var iterator: *?KVPair = array[index].first;
            // looking to see if the key already exists so we can throw a fit.
            while(iterator) |iterated_node| : (iterator = iterated_node.*) {
                iterated_node.*.
            }
            


        }
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

    const kvp = KeyValuePair(u64, u32);
    // const pair = kvp.init(64, 32);
    dprint("{any}\n", .{@typeInfo(kvp).Struct.fields[0].type});
}

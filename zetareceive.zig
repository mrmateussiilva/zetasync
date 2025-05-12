const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const address = try std.net.Address.parseIp("0.0.0.0", 9999);
    var server = try std.net.StreamServer.listen(.{
        .allocator = allocator,
        .address = address,
    });
    defer server.deinit();

    std.debug.print("Servidor aguardando conexões...\n", .{});

    while (true) {
        const conn = try server.accept();
        defer conn.stream.close();

        var reader = conn.stream.reader();
        var filename_buf: [256]u8 = undefined;
        const len = try reader.readUntilDelimiter(&filename_buf, '\n');
        const filename = filename_buf[0..len];

        var file = try std.fs.cwd().createFile(filename, .{});
        defer file.close();

        var buffer: [1024]u8 = undefined;
        while (true) {
            const bytes_read = try reader.read(&buffer);
            if (bytes_read == 0) break;
            _ = try file.writeAll(buffer[0..bytes_read]);
        }

        std.debug.print("Arquivo '{s}' recebido com sucesso.\n", .{filename});
    }
}

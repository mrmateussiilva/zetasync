const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 3) {
        std.debug.print("Uso: zetasend <ip> <arquivo>\n", .{});
        return;
    }

    const ip = args[1];
    const path = args[2];

    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    const address = try std.net.Address.parseIp(ip, 9999);
    var stream = try std.net.tcpConnectToAddress(address);
    defer stream.close();

    // Envia o nome do arquivo
    try stream.writer().print("{s}\n", .{path});

    var buffer: [1024]u8 = undefined;
    while (true) {
        const bytes_read = try file.read(&buffer);
        if (bytes_read == 0) break;
        _ = try stream.writeAll(buffer[0..bytes_read]);
    }

    std.debug.print("Arquivo enviado com sucesso.\n", .{});
}

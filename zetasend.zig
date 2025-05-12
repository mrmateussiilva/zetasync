const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const args = try std.process.argsAlloc(std.heap.page_allocator);
    if (args.len < 2) {
        try stdout.print("Uso: zetasend <arquivo>\n", .{});
        return;
    }

    const filename = args[1];
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const address = try std.net.Address.parseIp4("127.0.0.1", 9999);
    var stream = try std.net.tcpConnectToAddress(address);
    defer stream.close();

    var buf: [1024]u8 = undefined;
    while (true) {
        const n = try file.read(&buf);
        if (n == 0) break;
        _ = try stream.writer().writeAll(buf[0..n]);
    }

    try stdout.print("Arquivo \"{s}\" enviado com sucesso!\n", .{filename});
}

const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const address = try std.net.Address.parseIp4("0.0.0.0", 9999);
    var listener = try address.listen(.{ .reuse_address = true });
    defer listener.deinit();

    try stdout.print("Aguardando conexão na porta 9999...\n", .{});
    var conn = try listener.accept();
    defer conn.stream.close();

    const file = try std.fs.cwd().createFile("recebido.bin", .{});
    defer file.close();

    var buf: [1024]u8 = undefined;
    while (true) {
        const n = try conn.stream.reader().read(&buf);
        if (n == 0) break;
        _ = try file.writeAll(buf[0..n]);
    }

    try stdout.print("Arquivo recebido como \"recebido.bin\"\n", .{});
}

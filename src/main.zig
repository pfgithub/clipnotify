const std = @import("std");
const c = @cImport({
    @cInclude("X11/Xatom.h");
    @cInclude("X11/Xlib.h");
    @cInclude("X11/extensions/Xfixes.h");
});

pub fn main() !void {
    var args = std.process.args();
    _ = args.skip();

    var arenaAllocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arenaAllocator.deinit();

    var alloc = &arenaAllocator.allocator;

    const Clipboard = enum { primary, clipboard };
    var clipboard: Clipboard = .clipboard;

    while (args.next(alloc)) |mbyArg| {
        const arg = try mbyArg;
        if (std.mem.eql(u8, arg, "-b") or std.mem.eql(u8, arg, "--clipboard")) {
            const nxt = try args.next(alloc) orelse return error.MissingClipboard;
            clipboard = std.meta.stringToEnum(Clipboard, nxt) orelse
                return error.InvalidClipboard;
            continue;
        }
        return error.InvalidArg;
    }

    var display = c.XOpenDisplay(null) orelse return error.DisplayOpenFailed;
    defer _ = c.XCloseDisplay(display);

    var root = c.XDefaultRootWindow(display);

    var clip: c.Atom = switch (clipboard) {
        .primary => 1, //c.XA_PRIMARY,
        .clipboard => c.XInternAtom(display, "CLIPBOARD", c.False),
    };
    c.XFixesSelectSelectionInput(display, root, clip, c.XFixesSetSelectionOwnerNotifyMask);

    var event: c.XEvent = undefined;
    _ = c.XNextEvent(display, &event);
}

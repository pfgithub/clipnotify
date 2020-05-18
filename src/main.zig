const std = @import("std");
const c = @cImport({
    @cInclude("X11/Xatom.h");
    @cInclude("X11/Xlib.h");
    @cInclude("X11/extensions/Xfixes.h");
});

pub fn main() !void {
    var display = c.XOpenDisplay(null) orelse return error.DisplayOpenFailed;
    defer _ = c.XCloseDisplay(display);

    var root = c.XDefaultRootWindow(display);
    
    var clip = c.XInternAtom(display, "CLIPBOARD", c.False);
    c.XFixesSelectSelectionInput(display, root, clip, c.XFixesSetSelectionOwnerNotifyMask);

    var event: c.XEvent = undefined;
    _ = c.XNextEvent(display, &event);
}

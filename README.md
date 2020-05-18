this program https://github.com/cdown/clipnotify but written in zig

also doesn't notify on changes to the "primary" clipboard

example usage:

```bash
while clipnotify; do notify-send "Clipboard Changed" -i notifications -t 300; done
```

(fish:)
```fish
while clipnotify; notify-send "Clipboard Changed" -i notifications -t 300; end
```
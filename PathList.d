import std.container.array;
import Path;

public class PathList {
    private Path[] path_list;

    this() {
        this.path_list = [];
    }

    public PathList add(Path path) {
        this.path_list ~= path;
        return this;
    }

    public ulong length() {
        return this.path_list.length;
    }

    public void join(PathList list) {
        this.path_list = list.get();
    }

    public Path[] get() {
        return this.path_list;
    }
}

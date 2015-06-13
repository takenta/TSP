import std.stdio;
import std.container.array;
import Path;

public class PathList {
    private Path[] path_list;

    this() {
        this.path_list = [];
    }

    this(PathList path_list) {
        this.path_list = path_list.get().dup;
    }

    public PathList add(Path path) {
        this.path_list ~= path;
        return this.dup();
    }

    public ulong length() {
        return this.path_list.length;
    }

    public PathList join(PathList list) {
        this.path_list ~= list.get();
        return this.dup();
    }

    public Path[] get() {
        return this.path_list;
    }

    public PathList dup() {
        return new PathList(this);
    }

    public void setPathAll(int[][] arc_info, Path prev_route) {
        this.path_list = this.generatePathAll(arc_info, prev_route, 1);
    }

    private Path[] generatePathAll(int[][] arc_info, Path prev_route, int genelation) {
        Path[] buffer = [];
        int num_points = arc_info.length;

        assert(prev_route.length == genelation);

        if (prev_route.length() >= num_points) {
            return [prev_route.add(0)];
        }

        foreach(now_point; 0..num_points) {
            if(!prev_route.canFind(now_point)) {
                buffer ~= generatePathAll(arc_info, prev_route.dup().add(now_point), genelation + 1);
            }
        }

        return buffer;
    }
}

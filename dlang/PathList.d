import std.array;
import std.stdio;
import std.container.array;
import Path;

public class PathList {
    private Path[] path_list;
    private Path max_cost;
    private Path min_cost;

    this() {
        this.path_list = [];
        this.max_cost = null;
        this.min_cost = null;
    }

    this(PathList path_list) {
        this.path_list = path_list.getList;
        this.max_cost = path_list.getMaxCost;
        this.min_cost = path_list.getMinCost;
    }

    public PathList add(Path path) {
        this.path_list ~= path;
        return this.dup;
    }

    public ulong length() {
        return this.path_list.length;
    }

    public Path[] getList() {
        return this.path_list.dup;
    }

    public Path getMaxCost() {
        return this.max_cost.dup;
    }

    public Path getMinCost() {
        return this.min_cost.dup;
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
            prev_route.add(prev_route.get.front);
            if (this.max_cost is null || this.max_cost.getCost - prev_route.getCost < 0)
                this.max_cost = prev_route;
            if (this.min_cost is null || this.min_cost.getCost - prev_route.getCost > 0)
                this.min_cost = prev_route;
            return [prev_route];
        }

        foreach(now_point; 0..num_points) {
            if(!prev_route.canFind(now_point)) {
                buffer ~= generatePathAll(arc_info, prev_route.dup().add(now_point), genelation + 1);
            }
        }

        return buffer;
    }
}

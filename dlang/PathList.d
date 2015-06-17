import std.array;
import std.stdio;
import std.conv;
import std.container.array;
import Path;

public class PathList {
    private const int start_point;
    private Path[] path_list;
    private Path max_cost;
    private Path min_cost;

    this(in int start_point) {
        this.start_point = start_point;
        this.path_list = [];
        this.max_cost = null;
        this.min_cost = null;
    }

    this(PathList path_list) {
        this.start_point = path_list.getStartPoint;
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

    public int getStartPoint() {
        return this.getStartPoint;
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

    /**
     * すべてのpathを生成して、フィールドに格納する。
     * @param arc_info arcの情報
     * @param path
     */
    public void setPathAll(int[][] arc_info) {
        this.path_list = this.generatePathAll(arc_info, new Path(arc_info, this.start_point));
    }

    /**
     * すべてのpathを生成して、それを配列に格納して返す。
     * @param arc_info arcの情報
     * @param prev_route 現状のルート
     */
    private Path[] generatePathAll(int[][] arc_info, Path prev_route) {
        Path[] buffer = [];
        int num_points = arc_info.length.to!int;

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
                buffer ~= generatePathAll(arc_info, prev_route.dup().add(now_point));
            }
        }

        return buffer;
    }

    /**
     * 順次生成・比較法によってコストが最大・最小のpathを発見し、フィールドに代入する。
     * @param arc_info arcの情報
     * @param prev_route 現状のルート
     */
    public void setMaxMinPath(int[][] arc_info, Path prev_route) {
        int num_points = arc_info.length.to!int;

        if (prev_route.length() >= num_points) {
            prev_route.add(prev_route.get.front);
            if (this.max_cost is null || this.max_cost.getCost - prev_route.getCost < 0)
                this.max_cost = prev_route;
            if (this.min_cost is null || this.min_cost.getCost - prev_route.getCost > 0)
                this.min_cost = prev_route;
        }

        foreach(now_point; 0..num_points) {
            if(!prev_route.canFind(now_point)) {
                setMaxMinPath(arc_info, prev_route.dup.add(now_point));
            }
        }
    }
}

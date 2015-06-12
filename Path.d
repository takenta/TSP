import std.array;
import std.algorithm;
import std.container;

public class Path {
    private const int[][] arc_info;
    private int[] path;
    private int cost;

    this(in int[][] arc_info, int[] route) {
        this.arc_info = arc_info;
        this.path = route;
        this.cost = 0;
    }

    this(Path path) {
        this.arc_info = path.arc_info;
        this.path = path.path.dup;
        this.cost = path.cost;
    }

    /**
     * pathにnodeを追加する。また、追加に伴ってpathのcostも更新する。
     * @param node 追加するノード
     */
    public Path add(int node) {
        auto prev_node = this.path.back;
        this.path ~= node;
        this.cost += arc_info[prev_node][node];
        return new Path(this);
    }

    public int[] getPath() {
        return this.path;
    }

    public int getCost() {
        return this.cost;
    }

    public bool canFind(int node) {
        return std.algorithm.canFind(path, node);
    }

    public int length() {
        return this.path.length;
    }
}

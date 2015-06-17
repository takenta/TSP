import std.array;
import std.conv;
import std.algorithm;
import std.container.array;

public class Path {
    private const int[][] arc_info;
    private int[] path;
    private int cost;

    this(in int[][] arc_info) {
        this.arc_info = arc_info;
        this.path = [];
        this.cost = 0;
    }

    this(in int[][] arc_info, int start_point) {
        this.arc_info = arc_info;
        this.path = [start_point];
        this.cost = 0;
    }

    this(Path path) {
        this.arc_info = path.arc_info;
        this.path = path.path.dup;
        this.cost = path.cost;
    }

    /**
     * pathにnodeを追加する。また、追加に伴ってpathのcostも更新する。
     * 式の中で使用するために自身の複製を返す。
     * @param node 追加するノード
     * @return pathの複製
     */
    public Path add(int node) {
        auto prev_node = this.path.back;
        this.path ~= node;
        this.cost += arc_info[prev_node][node];
        return this.dup;
    }

    public int[] get() {
        return this.path.dup;
    }

    public int getCost() {
        return this.cost;
    }

    public bool canFind(int node) {
        return std.algorithm.canFind(path, node);
    }

    public int length() {
        return this.path.length.to!int;
    }

    public Path dup() {
        return new Path(this);
    }
}

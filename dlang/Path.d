import std.stdio;
import std.conv;
import std.array;
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
        return this.dup;
    }

    public Path insert(int before_node, int node) {
        auto index = this.indexOf(before_node) + 1;
        this.path.insertInPlace(index, node);
        return this.dup;
    }

    public uint indexOf(int node) {
        foreach (int i, int sample; this.path) {
            if (node == sample) return i;
        }
        return this.path.length;
    }

    public int[] get() {
        return this.path.dup;
    }

    public int getCost() {
        return this.calc(this.arc_info, this.path, 0);
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

    public int calc(in int[][] arc_info, in int[] path, in int cost) {
        int[] cloned_path = path.dup;

        if (cloned_path.length <= 1) return cost;

        int arc_cost = arc_info[cloned_path[0]][cloned_path[1]];
        return cost + this.calc(arc_info, cloned_path.remove(0), arc_cost);
    }
}

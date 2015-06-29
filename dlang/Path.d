import std.stdio;
import std.conv;
import std.array;
import std.algorithm;
import std.container.array;

public class Path {
    private const int[][] arc_info;
    private int[] path;
    private int path_cost;

    this(in int[][] arc_info) {
        this.arc_info = arc_info;
        this.path = [];
        this.path_cost = 0;
    }

    this(in int[][] arc_info, int start_point) {
        this.arc_info = arc_info;
        this.path = [start_point];
        this.path_cost = 0;
    }

    this(Path path) {
        this.arc_info = path.arc_info;
        this.path = path.path.dup;
        this.path_cost = path.cost;
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

    /**
     * 指定したnodeの後ろに新たなnodeを挿入する。
     * @param before_node 挿入する箇所
     * @param node 挿入するnode
     */
    public Path insert(int before_node, int node) {
        auto index = this.indexOf(before_node) + 1;
        this.path.insertInPlace(index, node);
        return this.dup;
    }

    /**
     * 指定したnodeのindexを取得する。
     * @param 指定するnode
     * @return 指定したnodeのindex
     */
    public uint indexOf(int node) {
        foreach (int i, int sample; this.path) {
            if (node == sample) return i;
        }
        return this.path.length.to!uint;
    }

    /**
     * pathをint型の配列として取得する。
     * @return pathを格納したint型配列
     */
    public int[] get() {
        return this.path.dup;
    }

    /**
     * pathのコストをint型で取得する。
     * @return pathのコスト
     */
    public int cost() {
        return this.path_cost;
    }

    /**
     * pathのコストを算出し、フィールドに格納する。
     */
    public void setCost() {
        this.path_cost = this.calc(this.path, 0);
    }

    /**
     * pathの長さ(path内のnodeの数)を取得する。
     * @return pathの長さ
     */
    public int length() {
        return this.path.length.to!int;
    }

    /**
     * pathの複製を取得する。
     * @return 複製されたpath
     */
    public Path dup() {
        return new Path(this);
    }

    /**
     * 指定されたpathのコストを算出する。
     * @param path コストを算出するpath
     * @param cost コストの初期値
     * @return 算出したpathのコスト
     */
    public int calc(in int[] path, in int cost) {
        int[] cloned_path = path.dup;

        if (cloned_path.length <= 1) return cost;

        int arc_cost = this.arc_info[cloned_path[0]][cloned_path[1]];
        return cost + this.calc(cloned_path.remove(0), arc_cost);
    }

    /**
     * pathの最後に始点を追加することで、強制的に閉路を形成する。
     */
    public void close() {
        this.add(this.path.front);
        this.setCost;
    }
}

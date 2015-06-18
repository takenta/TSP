import std.stdio;
import std.array;
import std.conv;
import std.container.array;
import std.algorithm.searching;
import std.algorithm.iteration;
import Path;

public class PathList {
    private const int start_point;
    private Path[] path_list;
    private Path optimal_path;

    this(in int start_point) {
        this.start_point = start_point;
        this.path_list = [];
        this.optimal_path = null;
    }

    this(PathList path_list) {
        this.start_point = path_list.getStartPoint;
        this.path_list = path_list.getList;
        this.optimal_path = path_list.optimal_path;
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

    public Path getOptimalPath() {
        return this.optimal_path.dup;
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
     * @param prev_path 現状のpath
     */
    private Path[] generatePathAll(int[][] arc_info, Path prev_path) {
        Path[] buffer = [];
        int num_node = arc_info.length.to!int;

        if (prev_path.length() >= num_node) {
            prev_path.add(prev_path.get.front);
            if (this.optimal_path is null || this.optimal_path.getCost - prev_path.getCost > 0)
                this.optimal_path = prev_path;
            return [prev_path];
        }

        foreach(now_node; 0..num_node) {
            if(!prev_path.canFind(now_node)) {
                buffer ~= generatePathAll(arc_info, prev_path.dup().add(now_node));
            }
        }

        return buffer;
    }

    public void setOptimalPath(string method, int[][] arc_info) {
        switch (method) {
            case "BF":
                writeln("Brute Force method");
                this.byBruteForce(arc_info, new Path(arc_info, this.start_point));
                break;
            case "NA":
                writeln("Nearest Addtion method");
                this.byNearestAddition(arc_info, new Path(arc_info, this.start_point));
                break;
            case "G":
                writeln("Greedy method");
                this.byGreedy(arc_info, new Path(arc_info, this.start_point));
                break;
            case "NN":
                writeln("Nearest Neighbor method");
                this.byNearestNeighbor(arc_info, new Path(arc_info, this.start_point));
                break;
            default:
                writeln("It's not exists.");
        }
    }

    /**
     * 順次生成・比較法によってコストが最大・最小のpathを発見し、フィールドに代入する。
     * @param arc_info arcの情報
     * @param prev_path 現状のpath
     */
    public void byBruteForce(int[][] arc_info, Path prev_path) {
        int num_node = arc_info.length.to!int;

        if (prev_path.length() >= num_node) {
            prev_path.add(prev_path.get.front);
            if (this.optimal_path is null || this.optimal_path.getCost - prev_path.getCost > 0)
                this.optimal_path = prev_path;
            return; // 探索打ち切り
        }

        foreach(now_node; 0..num_node) {
            if(prev_path.canFind(now_node)) continue;

            this.byBruteForce(arc_info, prev_path.dup.add(now_node));
        }
    }

    /**
     * Nearest Addtion法によってコストが最大・最小のpathを発見し、フィールドに代入する。
     * @param arc_info arcの情報
     * @param prev_path 現状のpath
     */
    public void byNearestAddition(in int[][] arc_info, Path prev_path) {
        int num_node = arc_info.length.to!int;
        Path path = prev_path.dup;

        if (path.length <= 1) {
            path.add(start_point);
        }

        // すべての node が path に加えられたら、始点を終点として追加して終了
        if (path.length >= num_node + 1) {
            this.optimal_path = prev_path;
            return; // 探索打ち切り
        }

        // path に追加されている node (既存 node )とされていない node (新規 node )からコストが最小の組を一つ選出する。
        int[] min_pair = null;
        foreach (prev_node; path.get) {
            foreach (next_node; 0..num_node) {
                if (path.canFind(next_node)) continue; // 既に path に含まれている node は弾く

                if (min_pair is null || arc_info[prev_node][next_node] < arc_info[min_pair[0]][min_pair[1]]) {
                    min_pair = [prev_node, next_node];
                }
            }
        }

        // 既存nodeのインデックスを取得し、その後ろに新規nodeを挿入する。
        this.byNearestAddition(arc_info, path.insert(min_pair[0], min_pair[1]));
    }

    /**
     * Greedy法によってコストが最大・最小のpathを発見し、フィールドに代入する。
     * @param arc_info arcの情報
     * @param prev_path 現状のpath
     */
    public void byGreedy(in int[][] arc_info, Path prev_path) {
        ;
    }

    /**
     * Nearest Neighbor法によってコストが最大・最小のpathを発見し、フィールドに代入する。
     * @param arc_info arcの情報
     * @param prev_path 現状のpath
     */
    public void byNearestNeighbor(in int[][] arc_info, Path prev_path) {
        int num_node = arc_info.length.to!int;

        // すべてのnodeがpathに加えられたら、始点を終点として追加して終了
        if (prev_path.length() >= num_node) {
            this.optimal_path = prev_path.add(prev_path.get.front);
            return; // 探索打ち切り
        }

        int now_node = prev_path.get.back; // 現在のノード
        int next_node = now_node;
        foreach (node; 0..num_node) {
            if (prev_path.canFind(node)) continue;

            if (next_node == now_node || arc_info[now_node][next_node] - arc_info[now_node][node] > 0) {
                next_node = node;
            }
        }

        this.byNearestNeighbor(arc_info, prev_path.dup.add(next_node));
    }
}

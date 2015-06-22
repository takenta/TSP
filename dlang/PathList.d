import std.stdio;
import std.array;
import std.conv;
import std.container.array;
import std.algorithm;
import std.typecons;
import Path;

public class PathList {
    private const int[][] arc_info;
    private const int start_point;
    private Path[] path_list;
    private Path optimal_path;

    this(in int[][] arc_info, in int start_point) {
        this.arc_info = arc_info;
        this.start_point = start_point;
        this.path_list = [];
        this.optimal_path = null;
    }

    this(PathList path_list) {
        this.arc_info = path_list.arc_info.dup;
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

    public Path[] sort() {
        this.path_list.sort!("a.getCost < b.getCost");
        return this.path_list.dup;
    }

    public PathList dup() {
        return new PathList(this);
    }

    /**
     * すべてのpathを生成して、フィールドに格納する。
     */
    public void setPathAll() {
        int[] unused_nodes = [];
        foreach (num; 0..this.arc_info.length) unused_nodes ~= num.to!int;

        Path[] generatePathAll(Path prev_path, int[] unused_nodes) {
            Path[] buffer = [];

            if (unused_nodes.empty) {
                prev_path.add(prev_path.get.front);
                return [prev_path];
            }

            unused_nodes.each!((node) {
                buffer ~= generatePathAll(prev_path.dup.add(node), unused_nodes.dup.remove!(a => a == node));
            });

            return buffer;
        }

        this.path_list = generatePathAll(new Path(this.arc_info, this.start_point), unused_nodes.remove!(a => a == this.start_point));
    }


    public void setOptimalPath(string method) {
        int[] unused_nodes = [];
        foreach (num; 0..this.arc_info.length) unused_nodes ~= num.to!int;
        unused_nodes.remove!(a => a == this.start_point);

        switch (method) {
            case "AE":
                writeln("All Enumration method");
                this.optimal_path = this.byAllEnumerate(new Path(this.arc_info, this.start_point));
                break;
            case "BF":
                writeln("Brute Force method");
                this.optimal_path = this.byBruteForce(new Path(this.arc_info, this.start_point), unused_nodes);
                break;
            case "NA":
                writeln("Nearest Addtion method");
                this.optimal_path = this.byNearestAddition(new Path(this.arc_info, this.start_point), unused_nodes);
                break;
            case "G":
                writeln("Greedy method");
                this.optimal_path = this.byGreedy();
                break;
            case "NN":
                writeln("Nearest Neighbor method");
                this.optimal_path = this.byNearestNeighbor(new Path(this.arc_info, this.start_point), unused_nodes);
                break;
            default:
                writeln("It's not exists.");

        }
    }

    /**
     * 完全列挙法によってコストが最小のpathを発見し、返す。
     * @param prev_path 現状のpath
     * @return コストが最小のpath
     */
    private Path byAllEnumerate(Path prev_path) {
        Path optimal_path = null;

        this.setPathAll;    // すべてのパスを生成する
        this.sort;          // パスをコストの昇順にソートする
        this.path_list.each!((path){
            if (optimal_path is null || optimal_path.getCost > path.getCost)
                optimal_path = path;
        });

        return optimal_path;
    }

    /**
     * 順次生成・比較法によってコストが最小のpathを発見し、フィールドに代入する。
     * @param prev_path 現状のpath
     */
    private Path byBruteForce(Path prev_path, int[] unused_nodes) {
        if (unused_nodes.empty) {
            prev_path.add(prev_path.get.front);
            return prev_path;
        }

        Path optimal_path = null;
        unused_nodes.each!((node) {
            Path temp = byBruteForce(prev_path.dup.add(node), unused_nodes.dup.remove!(a => a == node));
            if (optimal_path is null || optimal_path.getCost > temp.getCost)
                optimal_path = temp;
        });
        return optimal_path;
    }

    /**
     * Nearest Addtion法によってコストが最小のpathを発見し、フィールドに代入する。
     * @param prev_path 現状のpath
     */
    private Path byNearestAddition(Path prev_path, int[] unused_nodes) {
        Path path = prev_path.dup;

        if (path.length <= 1) {
            path.add(start_point);
        }

        // すべての node が path に加えられたら、始点を終点として追加して終了
        if (unused_nodes.empty) {
            return prev_path;
        }

        // path に追加されている node (既存 node )とされていない node (新規 node )からコストが最小の組を一つ選出する。
        int[] min_pair = null;
        foreach (prev_node; path.get) {
            foreach (next_node; unused_nodes) {
                if (min_pair is null || arc_info[prev_node][next_node] < arc_info[min_pair[0]][min_pair[1]]) {
                    min_pair = [prev_node, next_node];
                }
            }
        }

        // 既存nodeのインデックスを取得し、その後ろに新規nodeを挿入する。
        return byNearestAddition(path.insert(min_pair[0], min_pair[1]), unused_nodes.remove!(a => a == min_pair[1]));
    }

    /**
     * Greedy法によってコストが最小のpathを発見し、フィールドに代入する。
     */
    private Path byGreedy() {
        // Tuple([int int], int)の配列を生成する。
        alias Arc = Tuple!(int, "prev", int, "next", int, "cost");
        Arc[] arcs = [];

        // 全てのArcとそのコストを組み合わせて、配列に格納する。
        foreach (i; 0..this.arc_info.length) {
            foreach (j; 0..this.arc_info.length) {
                arcs ~= Arc(i.to!int, j.to!int, this.arc_info[i][j]);
            }
        }

        // 配列をコストについて昇順に
        arcs.sort!("a.cost < b.cost");
        arcs = arcs.remove!(a => a.prev == a.next || a.next == this.start_point);

        Path generateOptimalPath(Path prev_path, Arc[] unused_arcs) {
            Path path = prev_path.dup;

            if (unused_arcs.empty) {
                path.add(path.get.front);
                return path;
            }

            int last_node = path.get.back;
            Arc next_arc = unused_arcs.filter!(a => a.prev == last_node).front;
            return generateOptimalPath(path.add(next_arc.next), unused_arcs.remove!(a => a.next == next_arc.next));
        }

        return generateOptimalPath(new Path(this.arc_info, this.start_point), arcs);
    }

    /**
     * Nearest Neighbor法によってコストが最小のpathを発見し、フィールドに代入する。
     * @param arc_info arcの情報
     * @param prev_path 現状のpath
     */
    private Path byNearestNeighbor(Path prev_path, int[] unused_nodes) {
        // すべてのnodeがpathに加えられたら、始点を終点として追加して終了
        if (unused_nodes.empty) {
            return prev_path.add(prev_path.get.front);
        }

        int now_node = prev_path.get.back; // 現在のノード
        int next_node = now_node;
        foreach (node; unused_nodes) {
            if (next_node == now_node || arc_info[now_node][next_node] - arc_info[now_node][node] > 0) {
                next_node = node;
            }
        }

        return byNearestNeighbor(prev_path.dup.add(next_node), unused_nodes.remove!(a => a == next_node));
    }
}

import std.stdio;
import std.array;
import std.range;
import std.conv;
import std.container.array;
import std.algorithm;
import std.typecons;
import std.mathspecial;
import std.parallelism;
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

    /**
     * リストにpathを追加する。
     * @param 追加するpath
     * @return pathを追加したリストの複製
     */
    public PathList add(Path path) {
        this.path_list ~= path;
        return this.dup;
    }

    /**
     * リストに追加されているpathの個数を取得する。
     * @return リストに追加されているpathの個数
     */
    public ulong length() {
        return this.path_list.length;
    }

    /**
     * リストに登録されているpathの始点を取得する。
     * @return リストに登録されているpathの始点
     */
    public int getStartPoint() {
        return this.getStartPoint;
    }

    /**
     * リストに登録されているpathを配列として取得する。
     * @return リストに登録されているpathを格納した配列
     */
    public Path[] getList() {
        return this.path_list;
    }

    /**
     * Arcの情報から最適に近いpathを取得する。
     * @return 最適に近いpath
     */
    public Path getOptimalPath() {
        return this.optimal_path;
    }

    /**
     * リストの複製を取得する。
     * @return 複製されたpathのリスト
     */
    public PathList dup() {
        return new PathList(this);
    }

    /**
     * すべてのpathを生成して、フィールドに格納する。
     */
    public void setPathAll() {
        Path[] generatePathAll(Path prev_path, int[] unused_nodes) {
            // 未使用のnodeがなくなったら終了
            if (unused_nodes.empty) {
                prev_path.close; // pathの末尾に始点を追加して、コストを算出
                return [prev_path];
            }

            // 未使用のnodeそれぞれについて枝を伸ばす
            return unused_nodes.map!(node => generatePathAll(prev_path.dup.add(node), unused_nodes.dup.remove!(a => a == node)))
                .reduce!((a,b) => a ~ b);
        }

        // 未使用nodeの集合を生成する
        int[] unused_nodes = recurrence!((a, n) => a[n-1] + 1)(0).take(this.arc_info.length).array;

        this.path_list = generatePathAll(new Path(this.arc_info, this.start_point), unused_nodes.remove!(a => a == this.start_point));
    }

    /**
     * アルゴリズムに従って最適であろう閉路を生成し、フィールドに格納する。
     * 使用するアルゴリズムは引数での指定に従う。使用できるアルゴリズムは以下の５つ。
     *   完全列挙法(AE)
     *   順次生成・比較法(BF)
     *   最近追加法(NA)
     *   貪欲法(G)
     *   近傍法(NN)
     * @param method 使用するアルゴリズム
     */
    public void setOptimalPath(string method) {
        switch (method) {
            case "AE":
                this.optimal_path = this.byAllEnumerate();
                break;
            case "BF":
                int[] unused_nodes = recurrence!((a, n) => a[n-1] + 1)(0).take(this.arc_info.length).array;
                this.optimal_path = this.byBruteForce(new Path(this.arc_info, this.start_point), unused_nodes);
                break;
            case "NA":
                int[] unused_nodes = recurrence!((a, n) => a[n-1] + 1)(0).take(this.arc_info.length).array;
                this.optimal_path = this.byNearestAddition(new Path(this.arc_info, this.start_point), unused_nodes);
                break;
            case "Gr":
                this.optimal_path = this.byGreedy();
                break;
            case "NN":
                int[] unused_nodes = recurrence!((a, n) => a[n-1] + 1)(0).take(this.arc_info.length).array;
                this.optimal_path = this.byNearestNeighbor(new Path(this.arc_info, this.start_point), unused_nodes);
                break;
            default:
                writeln("The command don't exists.");
        }
    }

    /**
     * 完全列挙法によってコストが最小のpathを発見し、返す。
     * @param prev_path 生成途中のpath
     * @return コストが最小のpath
     */
    private Path byAllEnumerate() {
        this.setPathAll;    // すべてのパスを生成する

        return this.path_list.reduce!((a, b) {
            if (a.cost < b.cost)
                return a;
            else
                return b;
        });
    }

    /**
     * 順次生成・比較法によってコストが最小のpathを発見し、フィールドに代入する。
     * @param prev_path 生成途中のpath
     * @param unused_nodes pathに含まれていないnodeの集合
     * @return コストが最小のpath
     */
    private Path byBruteForce(Path prev_path, int[] unused_nodes) {
        if (unused_nodes.empty) {
            prev_path.close;
            return prev_path;
        }

        return unused_nodes.map!(node => byBruteForce(prev_path.dup.add(node), unused_nodes.dup.remove!(a => a == node)))
            .reduce!((a,b) {
                if (a.cost < b.cost)
                    return a;
                else
                    return b;
            });
    }

    /**
     * Nearest Addtion法によってコストが最小のpathを発見し、フィールドに代入する。
     * @param prev_path 生成途中のpath
     * @param unused_nodes pathに含まれていないnodeの集合
     * @return コストが最小のpath
     */
    private Path byNearestAddition(Path prev_path, int[] unused_nodes) {
        if (prev_path.length <= 1) {
            prev_path.add(start_point);
        }

        // すべての node が path に加えられたら、始点を終点として追加して終了
        if (unused_nodes.empty) {
            prev_path.setCost;
            return prev_path;
        }

        // path に追加されている node (既存 node )とされていない node (新規 node )からコストが最小の組を一つ選出する。
        auto min_pair = cartesianProduct(prev_path.get, unused_nodes).reduce!((a, b) {
            if (arc_info[a[0]][a[1]] < arc_info[b[0]][b[1]])
                return a;
            else
                return b;
        });

        // 既存nodeのインデックスを取得し、その後ろに新規nodeを挿入する。
        return byNearestAddition(prev_path.dup.insert(min_pair[0], min_pair[1]), unused_nodes.remove!(a => a == min_pair[1]));
    }

    /**
     * Greedy法によってコストが最小のpathを発見し、フィールドに代入する。
     * @return コストが最小のpath
     */
    private Path byGreedy() {
        // Tuple([int int], int)型をArc型として定義
        alias Arc = Tuple!(int, "prev", int, "next", int, "cost");

        // 全てのArcとそのコストを組み合わせて、配列に格納
        // 1. 全てのArc（2つのnodeの組み合わせ）を生成
        // 2. それらのArcとそのコストの組み合わせを生成
        // 3. 同一地点へのArc（0から0、1から1のようなArc）および0に向かうArcを（途中で始点に戻らないように）削除する
        int[] nodes = recurrence!((a, n) => a[n-1] + 1)(0).take(this.arc_info.length).array;
        Arc[] arcs = cartesianProduct(nodes, nodes).map!(a => Arc(a[0], a[1], arc_info[a[0]][a[1]]))    // Arcとそのコストを組み合わせを生成
            .filter!(a => a.prev != a.next && a.next != this.start_point)                               // 邪魔なArcの削除
            .array;                                                                                     // 配列化

        // Arcの配列をコストについて昇順にソート
        arcs.sort!((a, b) => a.cost < b.cost);

        Path generateOptimalPath(Path prev_path, Arc[] unused_arcs) {
            if (unused_arcs.empty) {
                prev_path.close;
                return prev_path;
            }

            int last_node = prev_path.get.back;
            Arc next_arc = unused_arcs.filter!(a => a.prev == last_node).front;
            return generateOptimalPath(prev_path.add(next_arc.next), unused_arcs.remove!(a => a.next == next_arc.next || a.prev == next_arc.prev));
        }

        return generateOptimalPath(new Path(this.arc_info, this.start_point), arcs);
    }

    /**
     * Nearest Neighbor法によってコストが最小のpathを発見し、フィールドに代入する。
     * @param prev_path 生成途中のpath
     * @param unused_nodes pathに含まれていないnodeの集合
     * @return コストが最小のpath
     */
    private Path byNearestNeighbor(Path prev_path, int[] unused_nodes) {
        // すべてのnodeがpathに加えられたら、始点を終点として追加して終了
        if (unused_nodes.empty) {
            prev_path.close;
            return prev_path;
        }

        int now_node = prev_path.get.back; // 現在のノード
        int next_node = unused_nodes.reduce!((next, node) {
            if (arc_info[now_node][next] < arc_info[now_node][node])
                return next;
            else
                return node;
        });

        return byNearestNeighbor(prev_path.dup.add(next_node), unused_nodes.remove!(a => a == next_node));
    }
}

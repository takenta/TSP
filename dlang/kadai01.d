import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import Path;
import PathList;


void main() {
    int[][] arc_info = [];
    auto start_point = 0;
    auto fin = File("arc_list.txt");

    // Arc情報の読み込み
    foreach(input; fin.byLine) {
        int[] line;
        foreach(num; input.split(" ")) {
            line ~= num.to!int;
        }
        arc_info ~= line;
        line.writeln;
    }

    // path情報の生成
    PathList path_list = new PathList();
    path_list.setPathAll(arc_info, new Path(arc_info ,start_point));

    writeln("==========");

    // 全てのpathの内容とコストを表示
    Path min_cost;
    foreach(path; path_list.getList) {
        writeln("path: ", path.get);
        writeln("cost: ", path.getCost);
    }

    writeln("==========");

    // pathの総数とコストが最大・最小のpathを表示
    writeln("num_path: ", path_list.length);
    writeln("max_cost: ", path_list.getMaxCost.get, ",", path_list.getMaxCost.getCost);
    writeln("min_cost: ", path_list.getMinCost.get, ",", path_list.getMinCost.getCost);
}

import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import Path;
import PathList;


void main() {
    int[][] arc_info = [];
    int start_point = 0;
    auto fin = File("arc_info_10.txt");

    // Arc情報の読み込み
    foreach(input; fin.byLine) {
        int[] line;
        foreach(num; input.split(" ")) {
            line ~= num.to!int;
        }
        arc_info ~= line;
    }

    PathList path_list = new PathList(start_point);

    // 全てのpathの内容とコストを表示
    path_list.setPathAll(arc_info);    // path情報の生成
    auto sorted_list = path_list.getList.sort!("a.getCost < b.getCost");
    Path optimal_path = null;
    foreach(path; sorted_list) {
        //writeln("path: ", path.get);
        //writeln("cost: ", path.getCost);
        if (optimal_path is null || optimal_path.getCost - path.getCost > 0)
            optimal_path = path;
    }
    writeln("All Enumration method");
    writeln("optimal_path: ", optimal_path.get, "(", optimal_path.getCost, ")");
}

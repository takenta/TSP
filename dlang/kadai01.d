import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import Path;
import PathList;


void main() {
    int[][] arc_info = [];
    int start_point = 0;
    auto fin = File("arc_info_100.txt");

    // Arc情報の読み込み
    foreach(input; fin.byLine) {
        int[] line;
        foreach(num; input.split(" ")) {
            line ~= num.to!int;
        }
        arc_info ~= line;
        //line.writeln;
    }

    PathList path_list = new PathList(start_point);

    writeln("==========");

    // 全てのpathの内容とコストを表示
    path_list.setPathAll(arc_info);    // path情報の生成
    auto sorted_list = path_list.getList.dup.sort!("a.getCost < b.getCost");
    Path max_cost = null;
    Path min_cost = null;
    foreach(path; sorted_list) {
        //writeln("path: ", path.get);
        //writeln("cost: ", path.getCost);
        if (max_cost is null || max_cost.getCost - path.getCost < 0)
            max_cost = path;
        if (min_cost is null || min_cost.getCost - path.getCost > 0)
            min_cost = path;
    }
    writeln("max_cost: ", max_cost.get, "(", max_cost.getCost, ")");
    writeln("min_cost: ", min_cost.get, "(", min_cost.getCost, ")");

    writeln("==========");
}

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

    writeln("==========");

    // pathのコストが最大・最小のpathを表示
    path_list.setMaxMinPath(arc_info, new Path(arc_info ,start_point));
    writeln("max_cost: ", path_list.getMaxCost.get, "(", path_list.getMaxCost.getCost, ")");
    writeln("min_cost: ", path_list.getMinCost.get, "(", path_list.getMinCost.getCost, ")");

    writeln("==========");
}

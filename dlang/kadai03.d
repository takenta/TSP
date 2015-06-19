import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import Path;
import PathList;


void main() {
    int[][] arc_info = [];
    int start_point = 0;
    auto input_file = args[1];
    auto fin = File(input_file);

    // Arc情報の読み込み
    foreach(input; fin.byLine) {
        int[] line;
        input.split(" ").each!((num){
            line ~= num.to!int;
        });
        arc_info ~= line;
    }

    PathList path_list = new PathList(start_point);

    // pathのコストが最大・最小のpathを表示
    path_list.setOptimalPath("NA", arc_info);
    writeln("Optimal Path: ", path_list.getOptimalPath.get, "(", path_list.getOptimalPath.getCost, ")");
}

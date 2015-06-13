import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import Path;
import PathList;


void main() {
    auto fin = File("arc_list.txt");
    int[][] arc_info = [];
    auto start_point = 0;

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
    foreach(path; path_list.get()) {
        writeln("path: ", path.getPath());
        writeln("cost: ", path.getCost());
    }
}

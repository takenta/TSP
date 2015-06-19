import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import Path;
import PathList;


void main(string[] args) {
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
        line.writeln;
    }

    PathList path_list = new PathList(arc_info, start_point);

    foreach (method; ["AE", "BF", "NA", "NN"]) {
        writeln("================");
        path_list.setOptimalPath(method);
        writeln("Optimal Path: ", path_list.getOptimalPath.get, "(", path_list.getOptimalPath.getCost, ")");
    }
}

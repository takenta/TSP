import std.stdio;
import std.string;
import std.array;
import std.algorithm;
import std.conv;
import core.time;
import PathList;


void main(string[] args) {
    immutable uint repeat = 10;
    immutable uint start_point = 0;
    auto input_file = args[1];
    auto fin = File(input_file);

    // Arc情報の読み込み
    int[][] arc_info = fin.byLine.map!((input) => input.split(" ").map!(num => num.to!int).array).array;
    arc_info.map!(a => a.map!(to!string).join(" ")).join("\n").writeln;

    PathList path_list = new PathList(arc_info, start_point);

    string[string] methods = ["AE": "All Enumerate",
                              "BF": "Brute Force",
                              "NA": "Nearest Addtion",
                              "Gr": "Greedy",
                              "NN": "Nearest Neighbor"];
    foreach (method; ["AE", "BF", "NA", "Gr", "NN"]) {
        writeln("================");
        writeln(methods[method]);
        auto before = MonoTime.currTime;
        foreach (i; 0..repeat) {
            path_list.setOptimalPath(method);
        }
        auto after = MonoTime.currTime;
        writeln("Optimal Path: ", path_list.getOptimalPath.get, "(", path_list.getOptimalPath.cost, ")");
        writeln("Execute Time: ", (after - before)/repeat);
    }
}

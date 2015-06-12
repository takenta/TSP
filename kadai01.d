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

    //Arc情報の読み込み
    foreach(input; fin.byLine) {
        int[] line;
        foreach(num; input.split(" ")) {
            line ~= num.to!int;
        }
        arc_info ~= line;
        line.writeln;
    }

    foreach(path; getPathList(arc_info, new Path(arc_info ,[start_point])).get()) {
        writeln("path: ", path.getPath());
        writeln("cost: ", path.getCost());
    }
}

PathList getPathList(int[][] arc_info, Path route) {
    PathList path_list = new PathList();
    int num_points = arc_info.length;

    if (route.length() >= num_points) {
        return path_list.add(route.add(0));
    }

    foreach(now_point; 0..num_points) {
        if(!route.canFind(now_point)) {
            path_list.join(getPathList(arc_info, new Path(route.add(now_point))));
        }
        writeln("route: ", route.getPath());
    }

    return path_list;
}

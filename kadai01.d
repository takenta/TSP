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

    PathList path_list = new PathList();
    path_list = setPathAll(arc_info, new Path(arc_info ,start_point), 1);
    foreach(path; path_list.get()) {
        writeln("path: ", path.getPath());
        writeln("cost: ", path.getCost());
    }
}

public PathList setPathAll(int[][] arc_info, Path prev_route, int genelation) {
    PathList buffer = new PathList();
    int num_points = arc_info.length;

    assert(prev_route.length == genelation);

    if (prev_route.length() >= num_points) {
        return buffer.add(prev_route.add(0));
    }

    foreach(now_point; 0..num_points) {
        if(!prev_route.canFind(now_point)) {
            buffer.join(setPathAll(arc_info, prev_route.dup().add(now_point), genelation + 1));
        }
    }

    return buffer;
}

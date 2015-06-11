import std.stdio;
import std.string;
import std.algorithm;
import std.conv;

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

    int i = 0;
    foreach(path; getPathList(arc_info.length.to!int, [start_point])) {
        path.writeln;
        i++;
    }
    writeln("num route: ",i);
}

int[][] getPathList(int num_points, int[] route) {
    int[][] path_list = [];

    if (route.length >= num_points) {
        return [route ~ 0];
    }

    foreach(now_point; 0..num_points) {
        if(!canFind(route, now_point)) {
            path_list ~= getPathList(num_points, route ~ now_point);
        }
    }

    return path_list;
}

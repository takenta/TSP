import std.stdio;
import std.string;
import std.algorithm;
import std.conv;

void main() {
    int[][] arc_info = [];
    auto start_point = 0;

    //Arc情報の読み込み
    foreach(input; stdin.byLine) {
        int[] line;
        foreach(num; input.split(" ")) {
            line ~= num.to!int;
        }
        arc_info ~= line;
    }

    auto path_list = getPath(arc_info, [], [], start_point, start_point);
    writeln("path_list:", path_list);
}

int[][] getPath(int[][] arc_info, int[][] path_list, int[] path, int start_point, int end_point) {
    if (path.length == arc_info.length) {
        path ~= end_point;
        path_list ~= path;

        writeln("path: ", path);
        writeln("=> this route get a goal");
        return path_list;
    }

    foreach(next_points; arc_info[start_point]) {
        foreach(next_point; 0..arc_info.length) {
            // まだpathに登録されていなかったら、登録して再帰呼出し
            if (!canFind(path, next_point)) {
                path ~= next_point.to!int; path.writeln;
                path_list ~= getPath(arc_info, path_list, path.dup, next_point.to!int, end_point);
            }
        }
    }

    return path_list;
}

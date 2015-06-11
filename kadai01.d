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

    writeln("start_point: ", start_point);
    writeln("arc_info");
    foreach(line; arc_info) {
        line.writeln;
    }
}

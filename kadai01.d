import std.stdio;
import std.string;
import std.algorithm;
import std.conv;

void main(char[][] args) {
    int[][] arc_info = [];
    auto start_point = args[0].to!int;

    //Arc情報の読み込み
    foreach(input; stdin.byLine) {
         arc_info ~= input.split(" ").map!(to!int);
    }

    writeln("start_point: ", start_point);
    writeln("arc_info: ", arc_info);
}

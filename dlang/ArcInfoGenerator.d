import std.stdio;
import std.string;
import std.conv;
import std.array;
import std.random;
import std.algorithm;

void main(string[] args) {
    uint num_node = args[1].to!uint;
    auto arc_info = new ulong[][](num_node, num_node);
    auto seed = Random(unpredictableSeed);

    foreach (i; 0..num_node) {
        foreach (j; i..num_node) {
            if (i == j) {
                arc_info[i][j] = 0;
                continue;
            }

            arc_info[i][j] = uniform(1, 10, seed);
            arc_info[j][i] = arc_info[i][j];
        }
    }

    arc_info.map!(a => a.map!(to!string).join(" ")).join("\n").writeln;
}

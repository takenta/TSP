import std.stdio;
import std.string;
import std.conv;
import std.random;
import std.algorithm;

void main() {
    immutable uint num_node = 10;
    ulong arc_info[num_node][num_node];

    foreach (i; 0..num_node) {
        foreach (j; i..num_node) {
            if (i == j) {
                arc_info[i][j] = 0;
                continue;
            }

            arc_info[i][j] = dice(0,10,10,10,10,10,10,10,10,10);
            arc_info[j][i] = arc_info[i][j];
        }
    }

    foreach (line; arc_info) {
        foreach (node; line) {
            write(node, " ");
        }
        writeln;
    }
}

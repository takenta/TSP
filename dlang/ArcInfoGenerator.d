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
            /* i==j の時、つまりは今いる点に移動する場合のコストは 0 */
            if (i == j) {
                arc_info[i][j] = 0;
                continue;
            }

            /* 最大値は10未満 */
            /* さらに既に設定されている数値について、三角不等式を満たす */
            auto limit = 10L;
            //foreach (k; 0..i.to!uint) {
            //    auto cost = arc_info[i][k] + arc_info[k][j];
            //    if (cost < limit) limit = cost;
            //}

            arc_info[i][j] = uniform(1, limit, seed);
            arc_info[j][i] = arc_info[i][j];
        }
    }

    arc_info.map!(a => a.map!(to!string).join(" ")).join("\n").writeln;
}

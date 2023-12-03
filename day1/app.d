import std.stdio;
import std.algorithm;
import std.array;
import std.format;
import std.conv;

int main() {
	File("input")
		.byLine
		.map!((str) {
			auto numbers = str.filter!((c) { return c >= '0' && c <= '9'; }).map!((c) { return to!int(c - '0'); }).array;
			return numbers[0] * 10 + numbers[numbers.length - 1];
		})
		.sum
		.writeln;
	return 0;
}

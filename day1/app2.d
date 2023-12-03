version = Part2;

import std.stdio;
import std.algorithm;
import std.array;
import std.format;
import std.conv;
import std.string;

int[string] numberMap;

static this() {
	numberMap = [
		"one": 1,
		"two": 2,
		"three": 3,
		"four": 4,
		"five": 5,
		"six": 6,
		"seven": 7,
		"eight": 8,
		"nine": 9
	];
}

int findNum(T)(T /*char[] and string; since example and file read are different*/ str, bool reverse) {
	for(size_t i = reverse ? str.length - 1: 0; reverse ? i >= 0 : i < str.length; i += (reverse ? -1 : 1)) {
		auto c = str[i];
		if(c >= '0' && c <= '9')
			return to!int(c - '0');
		version(Part2) {
			foreach(key, value; numberMap) {
				if(key.length > str.length - i)
					continue;
				if(str[i..i+key.length] == key) {
					return value;
				}
			}
		}
	}
	writeln(str, " ", reverse);
	assert(false);
}

int main() {
	File("input")
		.byLine
	/*[
		"two1nine",
		"eightwothree",
		"abcone2threexyz",
		"xtwone3four",
		"4nineeightseven2",
		"zoneight234",
		"7pqrstsixteen"
	]*/
		.map!((str) {
			auto firstNum = findNum(str, false);
			auto secNum = findNum(str, true);
			auto code = firstNum * 10 + secNum;
			return code;
		})
		.sum
		.writeln;
	return 0;
}

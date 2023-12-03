import std.stdio;
import std.container;
import std.algorithm;
import std.ascii;
import std.conv;
import std.array;

struct Num {
	ulong value;
	size_t line;
	size_t startIdx;
	size_t endIdx;
}

int main() {
	auto lines = File("input")
		.byLineCopy
		.array;

	auto nums = Array!Num();
	
	int l = 0;
	foreach(str; lines) {
		size_t startIdx = 0;
		bool inNum = false;
		for(size_t i = 0; i < str.length; i++) {
			if(str[i].isDigit) {
				if(!inNum)
					startIdx = i;
				inNum = true;
			} else {
				if(inNum) {
					Num n = { to!int(str[startIdx..i]), l, startIdx, i - 1 };
					nums.insertBack(n);
				}
				inNum = false;
			}
		}

		if(inNum) {
			Num n = { to!int(str[startIdx..str.length]), l, startIdx, str.length };
			nums.insertBack(n);
		}

		l++;
	}
	
	ulong sum = 0;
	foreach(num; nums) {
		bool valid = false;

		writeln(num.value, " ", num.line, " ", num.startIdx, " ", num.endIdx, " ", valid);
		writeln(num.startIdx - 1, " ", num.endIdx + 1);
		for(size_t i = num.startIdx == 0 ? 0 : num.startIdx - 1; i <= num.endIdx + 1; i++) {
			writeln(i);
			for(size_t j = num.line == 0 ? 0 : num.line - 1; j <= num.line + 1; j++) {
				writeln(j);
				if(j < 0 || j >= lines.length)
					continue;
				if(i < 0 || i >= lines[j].length)
					continue;

				char c = lines[j][i];
				writeln(j, " ", i, " ", c);
				if(!c.isDigit && c != '.')
					valid = true;
			}
		}

		writeln(num.value, " ", num.line, " ", num.startIdx, " ", num.endIdx, " ", valid);
		if(valid)
			sum += num.value;
	}
	writeln(sum);

	return 0;
}

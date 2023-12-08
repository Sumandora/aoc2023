import std;

long gcd(long a, long b)
{
    if(a < b)
        swap(a, b);
    while(b != 0)
    {
        a = a % b;
        swap(a, b);
    }
    return a;
}

long lcm(long a, long b)
{
    return a / gcd(a, b) * b;
}

struct Node {
	string id;

	string left;
	string right;
}

Node[string] nodeMap;
string path;

string walkPath(char insn, string node) {
	auto nodeObj = nodeMap[node];

	if(insn == 'L') {
		return nodeObj.left;
	} else if(insn == 'R') {
		return nodeObj.right;
	} else {
		assert(0);
	}
}

int main() {
	stdin.byLineCopy.each!((line) {
		if(path == null) {
			path = line;
			return;
		}

		if(line.empty())
			return;

		auto s = line.split(" = ");
		auto s2 = s[1][1..$-1].split(", ");

		Node node = { s[0], s2[0], s2[1] };
		nodeMap[s[0]] = node;
		return;
	});

	nodeMap.writeln;

	Array!string currNodes;

	version (Part2) {
		foreach(node; nodeMap.byValue) {
			if(node.id[$-1] == 'A')
				currNodes.insertBack(node.id);
		}
	} else {
		currNodes.insertBack("AAA");
	}

	writeln("Checking ", currNodes);

	Array!ulong solutions;

	foreach(currNode; currNodes) {
		string currPath;
		ulong reps = 0;
		ulong steps = 0;

		while(true) {
			if(currPath.empty()) {
				currPath = path;
				reps++;
			}
			currNode = walkPath(currPath[0], currNode);
			steps++;
			version (Part2) {
				if(currNode[$-1] == 'Z') break;
			} else {
				if(currNode == "ZZZ") break;
			}
			currPath = currPath[1..$];
		}

		solutions.insertBack(steps);
	}

	ulong sol = 1;
	foreach(solution; solutions) {
		sol = lcm(sol, solution);
	}

	writeln("Solution: ", sol);

	return 0;
}

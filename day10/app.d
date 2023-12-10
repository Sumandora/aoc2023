import std;

enum Connection {
	NORTH, SOUTH, EAST, WEST
}

class Elem {
	public ulong x, y;

	public ulong visitLength = ulong.max;
}

class StartPosition : Elem {

	this(ulong x, ulong y) {
		this.x = x;
		this.y = y;
	}
}

class Pipe : Elem {
	Connection conn1, conn2;

	char c;
	Connection traversedDirection;

	this(ulong x, ulong y, Connection conn1, Connection conn2, char c) {
		this.x = x;
		this.y = y;
		this.conn1 = conn1;
		this.conn2 = conn2;
		this.c = c;
	}
}

Array!Elem elements;


Pipe parsePipe(ulong x, ulong y, char c) {
	switch(c) {
		case '|':
			return new Pipe(x, y, Connection.NORTH, Connection.SOUTH, c);
		case '-':
			return new Pipe(x, y, Connection.EAST, Connection.WEST, c);
		case 'L':
			return new Pipe(x, y, Connection.NORTH, Connection.EAST, c);
		case 'J':
			return new Pipe(x, y, Connection.NORTH, Connection.WEST, c);
		case '7':
			return new Pipe(x, y, Connection.SOUTH, Connection.WEST, c);
		case 'F':
			return new Pipe(x, y, Connection.SOUTH, Connection.EAST, c);
		default:
			assert(0); 
	}
}

int[][Connection] cardinalDirections;

static this() {
	cardinalDirections[Connection.EAST] =  [+1, 0];
	cardinalDirections[Connection.WEST] =  [-1, 0];
	cardinalDirections[Connection.SOUTH] = [0, +1];
	cardinalDirections[Connection.NORTH] = [0, -1];
}

ulong safeAdd(T)(ulong a, T b) {
	if(a == 0 && b < 0)
		return 0;
	return a + b;
}

Array!Pipe adjacentPipes(Elem e) {
	Array!Pipe adjacentPipes;
	elements.array.each!((element) {
		if(auto pipe = cast(Pipe) element) {
			auto dir1 = cardinalDirections[pipe.conn1];
			auto dir2 = cardinalDirections[pipe.conn2];

			if(
				(pipe.x.safeAdd(dir1[0]) == e.x && pipe.y.safeAdd(dir1[1]) == e.y) ||
				(pipe.x.safeAdd(dir2[0]) == e.x && pipe.y.safeAdd(dir2[1]) == e.y)
			) {
				adjacentPipes.insertBack(pipe);
			}
		}
	});
	return adjacentPipes;
}

void search(ulong depth, Elem pos) {
	pos.visitLength = depth;
	foreach(pipe; adjacentPipes(pos)) {
		if(pipe.visitLength <= depth)
			continue;
		search(depth+1, pipe);
	}
}

int main() {
	ulong y = 0;
	stdin.byLineCopy.each!((line) {
		for(ulong x = 0; x < line.length; x++) {
			char c = line[x];
			if(c == '.')
				continue;
			if(c == 'S') {
				elements.insertBack(new StartPosition(x, y));
				continue;
			}

			elements.insertBack(parsePipe(x, y, c));
		}
		y++;
		return null;
	});

	elements.writeln;

	Array!StartPosition starts;
	foreach(elem; elements)
		if(auto pos = cast(StartPosition) elem)
			starts.insertBack(pos);
	assert(starts.length == 1);
	auto start = starts[0];

	search(0, start);

	elements.array.filter!(e => e.visitLength != ulong.max).array.map!(e => e.visitLength).maxElement.writeln;

	return 0;
}
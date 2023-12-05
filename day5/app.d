import std;

struct Transformer {
	long destinationIdx;
	long sourceIdx;
	long length;
}

struct Map {
	string from;
	string to;
	std.Array!Transformer transformers;
}

struct Almanac {
	std.Array!long seeds;

	std.Array!Map maps;
}

Almanac almanac;

long calculateLocation(long i) {
	string currentCategory = "seed";
	while(true) {
		std.Array!Map filtered;
		foreach(map; almanac.maps) {
			if(map.from == currentCategory) {
				filtered.insertBack(map);
			}
		}
		if(filtered.length == 0)
			break;
		assert(filtered.length == 1);
		auto first = filtered[0];
		foreach(t; first.transformers) {
			if(i >= t.sourceIdx && i < t.sourceIdx+t.length) {
				i = t.destinationIdx + (i - t.sourceIdx);
				break;
			}
		}
		currentCategory = first.to;
	}
	return i;
}

int main() {
	Map* currentMap = null;
	stdin.byLineCopy.each!((str) {
		if(str.empty())
			return;
		if(str.startsWith("seeds: "))
			foreach(i; str[7..$].split.map!(s => to!long(s)))
				almanac.seeds.insertBack(i);
		if(str.endsWith(" map:")) {
			if(currentMap != null)
				almanac.maps.insertBack(*currentMap);
			auto names = str[0..$-5].split("-to-");
			Map* newMap = new Map(names[0], names[1]);
			currentMap = newMap;
			return;
		}
		if(currentMap) {
			auto numbers = str.split.map!(str => to!long(str));
			Transformer t = { numbers[0], numbers[1], numbers[2] };
			currentMap.transformers.insertBack(t);
			return;
		}
	});
	if(currentMap != null) {
		almanac.maps.insertBack(*currentMap);
		currentMap = null;
	}

	almanac.writeln;

	std.Array!long numbers;

	writeln("Calculating");

	long lowest = long.max;

	version(Part2) {
		long rangeBegin = -1;
		foreach(num; almanac.seeds) {
			if(rangeBegin == -1)
				rangeBegin = num;
			else {
				for(long i = 0; i < num; i++) {
					auto location = calculateLocation(rangeBegin+i);
					if(lowest > location) {
						lowest = location;
						writeln("Found new lowest ", lowest);
					}
				}
				rangeBegin = -1;
			}
		}
	} else {
		foreach(seed; almanac.seeds) {
			auto location = calculateLocation(seed);
			if(lowest > location) {
				lowest = location;
				writeln("Found new lowest ", lowest);
			}
		}
	}

	writeln("Lowest: ", lowest);

	return 0;
}

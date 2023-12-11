import std;

ulong dist(ulong x1, ulong y1, ulong x2, ulong y2) {
	ulong dx = max(x1, x2) - min(x1, x2);
	ulong dy = max(y1, y2) - min(y1, y2);
	return dx + dy;
}

version(Part2)
	ulong reps = 1000000 - 1;
else
	ulong reps = 1;

int main() {
	Array!string lines;

	stdin.byLineCopy.each!((line) {
		lines.insertBack(line);
	});

	writeln("Calculating...");

	struct Galaxy {
		ulong x, y;
	}
	Array!Galaxy galaxies;

	ulong y = 0;
	ulong yr = 0;
	lines.each!((line) {
		if(line.all!(c => c == '.'))
			yr += reps;
		for(ulong x = 0; x < line.length; x++) {
			if(line[x] != '#')
				continue;

			ulong xr = 0;

			for(ulong i = 0; i < x; i++) {
				if(lines.array.all!(l => l[i] == '.'))
					xr += reps;
			}

			galaxies.insertBack(Galaxy(x + xr, y + yr));
		}
		y++;
	});

	ulong sum = 0;
	for(ulong i = 0; i < galaxies.length; i++)
		for(ulong j = 0; j < i; j++) {
			Galaxy g1 = galaxies[i];
			Galaxy g2 = galaxies[j];
			sum += dist(g1.x, g1.y, g2.x, g2.y);
		}

	sum.writeln;

	return 0;
}

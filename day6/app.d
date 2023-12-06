import std;

struct Race {
	ulong time;
	ulong distance;
}

bool simulateRace(Race race, ulong chargeTime) {
	ulong driveTime = race.time - chargeTime;
	assert(chargeTime >= 0);
	ulong speed = chargeTime;
	return speed * driveTime > race.distance;
}

ulong[] parseNumbers(string numbers) {
	version(Part2) {
		return [to!ulong(numbers.replace(" ", ""))];
	} else {
		return numbers.split.map!(x => to!ulong(x)).array;
	}
}

int main() {
	Array!Race races;

	stdin.byLineCopy.each!((str) {
		if(str.startsWith("Time:")) {
			auto numbers = str[5..$].parseNumbers;

			foreach(number; numbers) {
				Race race = { to!ulong(number), 0 }; 
				races.insertBack(race);
			}
		}
		if(str.startsWith("Distance:")) {
			auto numbers = str[9..$].parseNumbers;
			size_t i = 0;
			foreach(number; numbers) {
				races[i].distance = to!ulong(number);
				i++;
			}
		}
		return null;
	});

	races.writeln;

	ulong product = 1;
	races.array.map!((race) {
		size_t solutions = 0;
		for(ulong i = 0; i < race.time; i++) {
			if(simulateRace(race, i))
				solutions++;
		}
		writeln(race, " has ", solutions, " solutions");
		return solutions;
	}).each!(i => product *= i);
	writeln("Solution: ", product);

	return 0;
}

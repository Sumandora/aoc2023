import std.container;
import std.conv;
import std.stdio;
import std.algorithm;
import std.array;

struct Show {
	size_t count;
	string color;
}

struct Round {
	Array!Show shows;
}

struct Game {
	size_t id;
	Array!Round rounds;
}

int main() {
	File("input")
		.byLine
		.map!((str) {
			auto firstSplit = str.split(": ");
			auto gameString = firstSplit[0];
			auto id = gameString[5..gameString.length];

			Game game = { to!size_t(id), Array!Round() };

			auto roundsString = firstSplit[1];
			auto rounds = roundsString.split("; ");

			foreach(round; rounds) {
				Round r;
				auto shows = round.split(", ");
				foreach(showString; shows) {
					auto parts = showString.split(" ");
					Show show = { to!size_t(parts[0]), to!string(parts[1]) };
					r.shows.insertBack(show);
				}
				game.rounds.insertBack(r);
			}

			return game;
		})
		.map!((game) {
			size_t lowestRed = 0;
			size_t lowestGreen = 0;
			size_t lowestBlue = 0;
			foreach(round; game.rounds) {
				foreach(show; round.shows) {
					switch(show.color) {
						case "red":
							lowestRed = max(lowestRed, show.count);
							break;
						case "green":
							lowestGreen = max(lowestGreen, show.count);
							break;
						case "blue":
							lowestBlue = max(lowestBlue, show.count);
							break;
						default: assert(0);
					}
				}
			}
			return lowestRed * lowestGreen * lowestBlue;
		})
		.sum
		.writeln;

	return 0;
}

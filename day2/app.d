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
		.filter!((game) {
			foreach(round; game.rounds) {
				foreach(show; round.shows) {
					switch(show.color) {
						case "red":
							if(show.count > 12)
								return false;
							break;
						case "green":
							if(show.count > 13)
								return false;
							break;
						case "blue":
							if(show.count > 14)
								return false;
							break;
						default: assert(0);
					}
				}
			}
			return true;
		})
		.map!(g => g.id)
		.sum
		.writeln;

	return 0;
}

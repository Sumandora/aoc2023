import std;

struct Card {
	size_t id;
	long[] all;
	long[] winning;
	size_t matches;
	size_t copies = 1; // Part 2
}

int main() {
	Card[size_t] cards;
	stdin.byLineCopy.each!((str) {
		auto idString = str.split(": ");
		auto id = to!size_t(idString[0][5..$].strip);

		auto numbers = idString[1].split(" | ");

		auto all = numbers[0].split(" ").filter!(s => !s.empty()).map!(s => to!long(s)).array;
		auto winning = numbers[1].split(" ").filter!(s => !s.empty()).map!(s => to!long(s)).array;

		auto matches = all.filter!(x => winning.find(x) != null).count();
		
		Card c = { id, all, winning, matches };
		cards[id] = c;
	});

	cards.writeln;

	version(Part2) {
		auto max = cards.byKey.maxElement;
		for(size_t i = 1; i <= max; i++) {
			auto card = cards[i];
			auto matches = card.matches;
			auto copies = card.copies;
			for(size_t k = 0; k < copies; k++) {
				for(size_t j = 1; j <= matches; j++) {
					if(i + j > max) continue;

					cards[i + j].copies++;
				}
			}
		}
		cards.byValue.map!(c => c.copies).sum.writeln;
	} else {
		cards.byValue.map!((c) {
			// This formula really couldn't have been any simplier?
			if(c.matches == 0)
				return 0;
			else if(c.matches == 1)
				return 1;
			else
				return 2 ^^ (c.matches - 1);
		}).sum.writeln;
	}

	return 0;
}

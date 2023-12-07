import std;

enum HandKind {
	FIVE_OF_A_KIND,
	FOUR_OF_A_KIND,
	FULL_HOUSE,
	THREE_OF_A_KIND,
	TWO_PAIR,
	ONE_PAIR,
	HIGH_CARD
}

struct Hand {
	string label;
	ulong score;
	HandKind kind;
}

HandKind calculateKind(Hand hand) {
	int jokers = 0; // Part2

	ulong[char] chars;
	int[ulong] amounts;
	foreach(c; hand.label) {
		version(Part2) {
			if(c == 'J') {
				jokers++;
				continue;
			}
		}

		if(!chars.byKey.canFind(c))
			chars[c] = chars.length;
		amounts[chars[c]]++;
	}

	auto vals = amounts.byValue.array;
	sort!("a > b")(vals);

	if(jokers > 0) {
		if(vals.length >= 1)
			vals[0] += jokers;
		else
			vals = [ jokers ];
	}

	if(vals.length >= 0 && vals[0] == 5)
		return HandKind.FIVE_OF_A_KIND;
	else if(vals.length >= 1 && vals[0] == 4 && vals[1] == 1)
		return HandKind.FOUR_OF_A_KIND;
	else if(vals.length >= 1 && vals[0] == 3 && vals[1] == 2)
		return HandKind.FULL_HOUSE;
	else if(vals.length >= 2 && vals[0] == 3 && vals[1] == 1 && vals[2] == 1)
		return HandKind.THREE_OF_A_KIND;
	else if(vals.length >= 3 && vals[0] == 2 && vals[1] == 2 && vals[2] == 1)
		return HandKind.TWO_PAIR;
	else if(vals.length >= 4 && vals[0] == 2 && vals[1] == 1 && vals[2] == 1 && vals[3] == 1)
		return HandKind.ONE_PAIR;
	return HandKind.HIGH_CARD;
}

int[char] ranking;

static this() {
	ranking['A'] = 13;
	ranking['K'] = 12;
	ranking['Q'] = 11;
	version(Part2) {
		ranking['J'] = 0;
	} else {
		ranking['J'] = 10;
	}
	ranking['T'] = 9;
	ranking['9'] = 8;
	ranking['8'] = 7;
	ranking['7'] = 6;
	ranking['6'] = 5;
	ranking['5'] = 4;
	ranking['4'] = 3;
	ranking['3'] = 2;
	ranking['2'] = 1;
}

int main() {
	auto hands = stdin.byLineCopy.map!((line) {
		auto splitted = line.split;

		assert(splitted[0].length == 5);
		
		Hand hand = { splitted[0], to!ulong(splitted[1]) };
		hand.kind = hand.calculateKind();

		return hand;
	}).array.sort!((a, b) {
		for(ulong i = 0; i < a.label.length; i++) {
			char ac = a.label[i];
			char bc = b.label[i];

			if(ac == bc)
				continue;

			return ranking[ac] < ranking[bc];
		}
		assert(0);
	}).sort!((a, b) {
		return a.kind > b.kind;
	}, SwapStrategy.stable);

	ulong sum = 0;
	ulong i = 1;
	foreach(hand; hands) {
		sum += hand.score * i;
		i++;
	}

	writeln("Sum: ", sum);

	return 0;
}

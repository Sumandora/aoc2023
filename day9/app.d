import std;

Array!(Array!long) createPyramid(long[] top)
{
	Array!(Array!long) layers;

	layers.insertBack(Array!long(top));

	Array!long currentLayer;

	while (currentLayer.empty || !currentLayer.array.all!(num => num == 0))
	{
		currentLayer = Array!long();
		Array!long prevLayer = layers[$ - 1];
		assert(prevLayer.length > 0);
		for (int i = 0; i < prevLayer.length - 1; i++)
		{
			long topLeft = prevLayer[i];
			long topRight = prevLayer[i + 1];
			currentLayer.insertBack(topRight - topLeft);
		}

		layers.insertBack(currentLayer);
	}
	return layers;
}

int main()
{
	auto pyramids = stdin.byLineCopy
		.map!((str) { return str.split.map!(s => to!long(s)).array; })
		.map!((nums) { return createPyramid(nums); });

	//pyramids.writeln;

	long sum = 0;
	Array!long newValues;
	version (Part2)
	{
		foreach (pyramid; pyramids)
		{
			ulong i = pyramid.length - 1;
			foreach_reverse (layer; pyramid)
			{
				scope (exit)
					i--;

				if (i == pyramid.length - 1)
				{
					newValues.insertBack(0);
					continue;
				}

				long currNum = layer[0];
				long previous = newValues[$-1];
				long newNum = currNum - previous;
				newValues.insertBack(newNum);

				if (i == 0)
				{
					sum += newNum;
					continue;
				}
			}
		}
	}
	else
	{
		foreach (pyramid; pyramids)
		{
			ulong i = pyramid.length - 1;
			foreach_reverse (ref layer; pyramid)
			{
				scope (exit)
					i--;

				if (i == pyramid.length - 1)
				{
					newValues.insertBack(0);
					continue;
				}

				long currNum = layer[$ - 1];
				long previous = newValues[$ - 1];
				long newNum = currNum + previous;
				newValues.insertBack(newNum);

				if (i == 0)
				{
					sum += newNum;
					continue;
				}
			}
		}
	}

	writeln(sum);

	return 0;
}

import std.algorithm;
import std.file;
import std.getopt;
import std.stdio;
import std.string;

void main(string[] args)
{
	string pathA, pathB, pathOut;

	try
	{
		auto result = getopt(args,
		                     std.getopt.config.required,
		                     "a", "List A",
		                     &pathA,

		                     std.getopt.config.required,
		                     "b|e", "List B",
		                     &pathB,

		                     std.getopt.config.required,
		                     "o", "Output list",
		                     &pathOut);

		if (result.helpWanted)
		{
			defaultGetoptPrinter("List A except B", result.options);
			return;
		}

		bool[string] set;

		File(pathB).byLine()
		           .map!(strip)
		           .filter!(x => !x.empty)
		           .each!(x => set[x.idup] = true);

		auto fileOut = File(pathOut, "w");

		File(pathA).byLine()
		           .map!(strip)
		           .filter!(x => (x in set) is null)
		           .each!(x => fileOut.writeln(x));
	}
	catch (Exception ex)
	{
		stderr.writeln(ex.msg);
		return;
	}
}

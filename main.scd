(
// Load factory
"genericFunctions.scd".loadRelative;
"busses.scd".loadRelative;
"nodes.scd".loadRelative;
"events.scd".loadRelative;
"server.scd".loadRelative;
//s.plotTree;
// ###### <initialise global var ######

~out = 0;
~projectPath=PathName(thisProcess.nowExecutingPath).parentPath;
~sampleDirPath=~projectPath++"samples/";

// VSTPlugin.search(dir:"~/.vst3");

// 4 register functions
ServerBoot.add(~loadSamples); // fill up the ~buffers dict
ServerBoot.add(~makeBusses);
ServerQuit.add(~cleanup);

// 5 boot serv
s.waitForBoot({
	s.sync; //wait the server to be ok
	"synthdefs.scd".loadRelative;

	VSTPlugin.search;

	s.sync;
	ServerTree.add(~makeNodes);
	ServerTree.add(~makeEvents);
	s.freeAll;
	s.sync;
	"done".postln;
});

)

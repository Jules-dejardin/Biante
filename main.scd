

(
// Load factory
"genericFunctions.scd".loadRelative;
"busses.scd".loadRelative;
"nodes.scd".loadRelative;
"events.scd".loadRelative;
"server.scd".loadRelative;

// ###### initialise global var ######

~out = 0;
~projectPath=PathName(thisProcess.nowExecutingPath).parentPath;
~sampleDirPath=~projectPath++"samples/";

VSTPlugin.search(dir:"~/.vst3");

// 4 register functions
ServerBoot.add(~loadSamples); // fill up the ~buffers dict
ServerBoot.add(~makeBusses);
ServerQuit.add(~cleanup);

// 5 boot serv
s.waitForBoot({
	s.sync; //wait the server to be ok
	"synthdefs.scd".loadRelative;
/*
	~radio = Synth(\radio, [\in, 0, \out, ~bus[\delayValh]]);
	~radio.set(\amp, 1);
	~radio.free;
*/
	s.sync;
	ServerTree.add(~makeNodes);
	ServerTree.add(~makeEvents);
	s.freeAll;
	s.sync;
	"done".postln;
});

)


s.plotTree;
s.meter;



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


s.plotTree;
s.meter;


// FoxDot integration


(
OSCFunc(
	{
		arg msg, time, addr, port;
		var fn;
		// Get local filename
		fn = msg[1].asString;
		// Print a message to the user
		("Loading SynthDef from" + fn).postln;
		// Add SynthDef to file
		fn = File(fn, "r");
		fn.readAllString.interpret;
		fn.close;
	},
	'foxdot'
);

// StageLimiter.activate(2);
)

/////////// FoxDot MIDI part

arg port=0;
MIDIClient.init;
midiout = MIDIOut(port);

OSCFunc(
	{
		arg msg, time, addr, port;
		var note, vel, sus, channel, nudge;

		// listen for specific MIDI trigger messages from FoxDot
		note    = msg[2];
		vel     = msg[3];
		sus     = msg[4];
		channel = msg[5];
		nudge   = msg[6];

		SystemClock.schedAbs(time + nudge, {midiout.noteOn(channel, note, vel)});
		SystemClock.schedAbs(time + nudge + sus, {midiout.noteOff(channel, note, vel)});
	},
	'foxdot_midi'

);


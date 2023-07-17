
(

// s = Server.new(
// 	"localhost",
// 	NetAddr("localhost", 57112)
// );

// // ServerOptions.outDevices;
// s.options.outDevice_(
// 	"Focusrite USB Au"
// 	//"ASIO4ALL v2"
// 	// "Windows WDM-KS : Line Out (ZOOM U-22 Driver)"
// );
// s.options.inDevice_(
// 	"ASIO4ALL v2"
// 	// "Windows WDM-KS : Ligne (ZOOM U-22 Driver)"
// );

s.options.numInputBusChannels_(8);
s.options.numOutputBusChannels_(6);
s.options.sampleRate_(48000);
s.options.memSize_(2.pow(20)); // ~1 GB of active memory
// s.newBusAllocators;

// ServerBoot.removeAll;
// ServerTree.removeAll;
// ServerQuit.removeAll;






)
//
// s.boot;
//
// s.quit;
//
// ~makeBuffers.value("./samples/");
//
// b = nil;
//
// b[\goutes][0];
//
// b[\goutes][0].play;
//
// { PinkNoise.ar(0.2) + Saw.ar(660, 0.2) }.play;
//
// (
// OSCFunc(
// 	{
// 		arg msg, time, addr, port;
// 		var fn;
// 		// Get local filename
// 		fn = msg[1].asString;
// 		// Print a message to the user
// 		("Loading SynthDef from" + fn).postln;
// 		// Add SynthDef to file
// 		fn = File(fn, "r");
// 		fn.readAllString.interpret;
// 		fn.close;
// 	},
// 	'foxdot'
// );
//
// // StageLimiter.activate(2);
// )
//
// /////////// FoxDot MIDI part
//
// arg port=0;
// MIDIClient.init;
// midiout = MIDIOut(port);
//
// OSCFunc(
// 	{
// 		arg msg, time, addr, port;
// 		var note, vel, sus, channel, nudge;
//
// 		// listen for specific MIDI trigger messages from FoxDot
// 		note    = msg[2];
// 		vel     = msg[3];
// 		sus     = msg[4];
// 		channel = msg[5];
// 		nudge   = msg[6];
//
// 		SystemClock.schedAbs(time + nudge, {midiout.noteOn(channel, note, vel)});
// 		SystemClock.schedAbs(time + nudge + sus, {midiout.noteOff(channel, note, vel)});
// 	},
// 	'foxdot_midi'
//
// );
//
//
//
//
// s.meter;
// s.plotTree;
// //XLine

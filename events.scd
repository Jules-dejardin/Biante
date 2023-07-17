

~makeEvents = {
	MIDIClient.init;
    MIDIIn.connectAll;

	e = Dictionary.new;

	e.add(\init -> {
		~one = Synth(\radio, [\in, 0, \out, ~bus[\delayValh] , \amp, 0], ~mainGrp);//radio
		~recBuff = Buffer.alloc(s, s.sampleRate * 5, 1);
		//~recBuff.plot;
		~radioRead = Synth(\AudioInputMono, [\input, 0, \out, ~bus[\radioBus], \amp, 1], ~radioGrp);
		~radioPtr = Synth(\ptr, [\buf, ~recBuff, \out, ~bus[\ptrBus]], ~ptrGrp);
		~radioRecord = Synth(\rec, [\ptrIn, ~bus[\ptrBus], \micIn, ~bus[\radioBus], \buf, ~recBuff], ~recGrp);

		~vstDelaySynth.open("ValhallaFreqEcho.vst3", editor: true, verbose:true);
		~vstDelaySynth.editor;

		~vstMassiveSynth.open("ValhallaSupermassive.vst3", editor: true, verbose:true);
		~vstMassiveSynth.editor;
	});

	e.add(\event1 -> {
		~clarWeird2.stop;
		~clarWeird3.stop;
		~clarWeird4.stop;
		~chord.stop;
		~snow.set(\relOut, 1, \gate,0);
		//~g.do({ arg n; n.set(\gate, 0) });

		~clarWeird = Pbind(
			\instrument, \clarGran,
			\buf, ~buffers[\oizo][0,1,2],
			\sync, 0,
			\panRand, 1,
			\gDur, Pexprand(0.03, 0.3, inf),
			\dens, Pexprand(10,50, inf),
			\pos, Pexprand(0.01,1,inf),
			\c0, 0.1,
			\rel, 0.1,
			\sus, 0.5,
			\amp, 1,
			\group, ~mainGrp,
			\out, 0,
		).play;
	});

	e.add(\event2 -> {
		~ball.stop;
		~clarWeird.stop;
		~clarWeird4.stop;
		~clarWeird3.stop;
		~chord.stop;
		~snow.set(\relOut, 1, \gate,0);
		//~g.do({ arg n; n.set(\gate, 0) });

		~clarWeird2 = Pbind(
			\instrument, \clarGran,
			\buf,~buffers[\humain][2],
			\sync, 0,
			\panRand, 1,
			\gDur, Pwhite(0.25, 0.7, inf),
			\dens, Pwhite(10,30, inf).round(1),
			\pos, exprand(0.1,1),
			\c0, (-2),
			\rel, 0.2,
			\sus, 1,
			\amp, 1,
			\group, ~mainGrp,
			\out, 0,
		).play;
	});

	e.add(\event3 -> {
		~ball.stop;
		~clarWeird.stop;
		~clarWeird2.stop;
		~clarWeird4.stop;
		~marimba.stop;

		~chord = Pbind(
			\instrument, \bpfsaw,
			\dur, Pwhite(1,5,inf),
			\midinote, Pxrand([
				[23,35,54,63,64],
				[45,52,54,59,61,64],
				[28,40,47,56,59,63],
				[42,52,57,61,63],
			],inf),
			\detune, Pexprand(0.05,0.2,inf),
			\cfmin, 100,
			\cfmax, 1500,
			\rqmin, Pexprand(0.01, 0.15, inf),
			\atk, Pwhite(2.0,2.5,inf),
			\rel, Pwhite(6.5,10.0,inf),
			\ldb, 6,
			\amp, Pfunc({~volumeSynth}, inf),
			\group, ~mainGrp,
			\out, 0,
		).play;

		~chord2room = Pbind(
			\instrument, \bpfsaw,
			\dur, Pwhite(1,7,inf),
			\midinote, Pxrand([
				[23,35,54,63,64],
				[45,52,54,59,61,64],
				[28,40,47,56,59,63],
				[42,52,57,61,63],
			], 10),
			\detune, Pexprand(0.05,0.2,inf),
			\cfmin, 100,
			\cfmax, 1500,
			\rqmin, Pexprand(0.01, 0.15, inf),
			\atk, Pwhite(2.0,2.5,inf),
			\rel, Pwhite(6.5,10.0,inf),
			\ldb, 6,
			\amp, Pfunc({~volumeSynth}, inf),
			\group, ~mainGrp,
			\out,0,
		).play;
	});

	e.add(\event4 -> {
		(
			~recBuff.zero;
			~g =  5.collect({
				arg n;
				Synth(\granRadio, [
					\amp, 0.7,
					\buf, ~recBuff,
					\out, ~bus[\satura],
					\atk, 0.01,
					\rel, 0.5,
					\gate, 1,
					\sync, 1,
					\dens, exprand(20,40),
					\baseDur, exprand(0.3, 0.5),
					\durRand, 1,
					\rate, 1,
					\rateRand, 2.midiratio,
					\pan, 0,
					\panRand, 0.5,
					\grainEnv, -1,
					\ptrBus, ~bus[\ptrBus],
					\ptrSampleDelay, n.linlin(0,4,20000,s.sampleRate*2),
					\ptrRandSamples, 10000,
					\minPtrDelay, 1000
				],~granGrp);
			});
		)
	});

	e.add(\event5 -> {

		~clarWeird.stop;
		~clarWeird2.stop;
		~clarWeird3.stop;
		~chord.stop;
		//~g.do({ arg n; n.set(\gate, 0) });

		~clarWeird4 = Pbind(
			\instrument, \clarGran,
			\buf,~buffers[\mer][0],
			\sync, 0,
			\panRand, 1,
			\gDur, Pwhite(5, 10, inf),
			\dens, 1,
			\pos, Pexprand(0.001,1),
			\c0, 5,
			\c1, 5,
			\rel, 0.5,
			\sus, 1,
			\amp, 1,
			\group, ~mainGrp,
			\out, ~bus[\massive],
		).play;

		~snow = Synth(\highNap, [\amp,0.8]);

	});

	e.add(\event6 -> {
		(
			~melo = Synth(\audioBuf, [\buf, ~buffers[\melo][0], \loop, 0, \out, 0, \amp, 1],~mainGrp);
		)
	});

	e.add(\event7 -> {
		(
			~bass = Pbind(
			\instrument, \bass,
			\dur, Pwhite(1,7,inf),
			\midinote, Pxrand([
				[23,35,54,63,64],
				[45,52,54,59,61,64],
				[28,40,47,56,59,63],
				[42,52,57,61,63],
			], 10),
			\detune, Pexprand(0.05,0.2,inf),
			\cfmin, 100,
			\cfmax, 1500,
			\rqmin, Pexprand(0.01, 0.15, inf),
			\atk, Pwhite(2.0,2.5,inf),
			\rel, Pwhite(6.5,10.0,inf),
			\ldb, 6,
			\amp, Pfunc({~volumeSynth}, inf),
			\group, ~mainGrp,
			\out,0,
		).play;
		)
	});

	//page 1 boutons
	e.add(\sample1 -> {
		(
			~water=Synth(\audioBuf, [\buf, ~buffers[\bateau][0], \loop, 0, \out, ~bus[\satura], \amp, 0.8], ~mainGrp);
		)
	});

	e.add(\sample2 -> {
		(
			Synth(\audioBuf, [\buf, ~buffers[\glouss][[0,1].choose], \loop, 0, \out, ~bus[\satura], \amp, 1], ~mainGrp);
		)
	});

	e.add(\sample3 -> {
		(
			Synth(\audioBuf, [\buf, ~buffers[\dolph][[0,1,2,3,4].choose], \loop, 0, \out, ~bus[\satura], \amp, 0.9],~mainGrp);
		)
	});

	e.add(\sample4 -> {
		(
			Synth(\audioBuf, [\buf, ~buffers[\harpe][[0,1,2].choose], \loop, 0, \out, ~bus[\satura], \amp, 0.9],~mainGrp);
		)
	});

	e.add(\sample5 -> {
		(

		)
	});

	e.add(\sample6 -> {
		(
			Synth(\audioBuf, [\buf, ~buffers[\verrevrac][[0,1,2,3,4,5].choose], \loop, 0, \out, ~bus[\satura], \amp, 0.9],~mainGrp);
		)
	});

	e.add(\sample7 -> {
		(
			Synth(\audioBuf, [\buf, ~buffers[\verre][[0,1,2,3].choose], \loop, 0, \out, ~bus[\satura], \amp, 0.9],~mainGrp);
		)
	});

	e.add(\sample8 -> {
		(
			Synth(\audioBuf, [\buf, ~buffers[\goutes][[0,1,2,3,4].choose], \loop, 0, \out, ~bus[\satura], \amp, 0.9],~mainGrp);
		)
	});


	//page 2 boutons

	e.add(\sample9 -> {
		(
		Synth(\audioBuf, [\buf, ~buffers[\craque][[0,1,2,3].choose], \loop, 0, \out, ~bus[\satura], \amp, 0.9], ~mainGrp)
		)
	});

	e.add(\sample10 -> {
		(
			Synth(\audioBuf, [\buf, ~buffers[\humain][[0,1,2].choose], \loop, 0, \out, ~bus[\satura], \amp, 0.9], ~mainGrp);
		)

	});

	e.add(\sample11 -> {
		(
			Synth(\audioBuf, [\buf, ~buffers[\fxoizo][[0,1,2,3,4,5].choose], \loop, 0, \out, ~bus[\satura], \amp, 0.9],~mainGrp);
		)
	});

	e.add(\sample12 -> {
		(
			Synth(\audioBuf, [\buf, ~buffers[\clic][[0,1,2,3].choose], \loop, 0, \out, ~bus[\satura], \amp, 1],~mainGrp);
		)
	});

	/*Synth(\audioBuf, [\buf, ~buffers[\percu][0], \loop, 0, \out, ~bus[\satura], \amp, 0.9],~mainGrp);*/

	e.add(\quit -> {
		~clarWeird.stop;
		~clarWeird2.stop;
		~clarWeird3.stop;
		~clarWeird4.stop;
		~chord.stop;
		~water.free;
		~snow.set(\relOut, 1, \gate,0);
		~g.do({ arg n; n.set(\gate, 0) });
	});

	e.add(\mayday -> {
		~one.free;
		~oneRoom.free;
		~two.free;
		~three.free;
		~fiveM.free;
		~fiveMRev.free;
		~sixMRev.free;
		~seven.free;
		~eight.free;
		~recBuff.free;
		~radioRead.free;
		~radioPtr.free;
		~radioRecord.free;
		~snow.free;
		MIDIIn.disconnectAll;
		s.quit;
	});


	MIDIdef.noteOn(\controller, {
		arg val, num, chan;
		[val, num, chan].postln;
		case
		{num==73 && val==127 }{e[\event1].value;"witches".postln;}
		{num==74 && val==127 }{e[\event2].value;"voix gran".postln;}
		{num==75 && val==127 }{e[\event3].value;"synth nappa".postln;}
		{num==76 && val==127 }{e[\event4].value;"radio gran".postln;}
		{num==41 && val==127 }{e[\event5].value;"mer".postln;}
		{num==42 && val==127 }{e[\event6].value;"melodie".postln;}
		{num==43 && val==127 }{e[\event7].value;"bass".postln;}
		{num==57 && val==127 && chan==1}{e[\sample1].value;"Boat".postln;}
		{num==58 && val==127 && chan==1}{e[\sample2].value;"Glouss".postln;}
		{num==59 && val==127 && chan==1}{e[\sample3].value;"Clic".postln;}
		{num==60 && val==127 && chan==1}{e[\sample4].value;"Bouche".postln;}
		{num==89 && val==127 && chan==1}{e[\sample5].value;"Craquement".postln;}
		{num==90 && val==127 && chan==1}{e[\sample6].value;"Percu".postln;}
		{num==91 && val==127 && chan==1}{e[\sample7].value;"Verre".postln;}
		{num==92 && val==127 && chan==1}{e[\sample8].value;"Goutes".postln;}
		{num==57 && val==127 && chan==2}{e[\sample9].value;"Verre Vrac".postln;}
		{num==58 && val==127 && chan==2}{e[\sample10].value;"Dauphins".postln;}
		{num==59 && val==127 && chan==2}{e[\sample11].value;"Oiseau FX".postln;}
		{num==60 && val==127 && chan==2}{e[\sample12].value;"Harpe".postln;}
		{num==105 && val==127 }{e[\init].value;"Initialisation".postln;}
		{num==108 && val==127 }{e[\mayday].value;"Panique bouton".postln;}
		{num==106 && val==127 }{e[\quit].value;"quit".postln;}
		{num==107 && val==127 }{
			~freeze = val.linexp(0, 127, 0, 1);
			~one.set(\t_trig, ~freeze);
			"freeze".postln;
		}
		{true}{nil};
	});

	MIDIFunc.cc({
		arg val, ccNum, channel;
		[val, ccNum, channel].postln;

		if(ccNum == 77 /*&& channel == 1*/, { ~volumeSynth = val.linexp(0, 127, 0.001, 0.7);  });
		//if(ccNum == 20 /*&& channel == 1*/, { ~sustainClar = val.linexp(0, 127, 0.2, 1.2);  });
		//if(ccNum == 79 /*&& channel == 1*/, { ~grainDens = val.linexp(0, 127, 1, 10);  });
		if(ccNum == 80 /*&& channel == 1*/, { ~test = val.linexp(0, 127, -0.70, 0); });
		if(ccNum == 83 /*&& channel == 1*/, { ~mixBrick = val.linexp(0, 127, -1, 1) }); // dry/wet du BrickWall

		if(ccNum == 80 /*&& channel == 1*/, {
			~volValh = val.linlin(0, 127, 0, 1);
			~one.set(\amp, ~volValh);
			"Volume Radio".postln;
			~volValh.postln;
		});

		if(ccNum == 79 /*&& channel == 1*/, {
			~mixDel = val.linlin(0, 127, 0, 1);
			~vstDelaySynth.synth.set(\mix, ~mixDel);
			"Mix Delay".postln;
			~mixDel.postln;
		});
		//RQ high nappa
		if(ccNum == 16 /*&& channel == 1*/, {
			~rqHigh = val.linlin(0, 127, 0.01, 0.1);
			~snow.set(\rq, ~rqHigh);
			"Rq snow".postln;
			~rqHigh.postln;
		});
		//Volume high nappa
		if(ccNum == 29 /*&& channel == 1*/, {
			~nappaVol = val.linlin(0, 127, 0, 0.8);
			~snow.set(\amp, ~nappaVol);
			"Volume snow".postln;
			~nappaVol.postln;
		});

		if(ccNum == 17 /*&& channel == 1*/, {
			~msDel = val.linlin(0, 127, 0, 1);
			~vstDelaySynth.synth.set(\ms, ~msDel);
			"Ms Delay".postln;
			~msDel.postln;
		});

		if(ccNum == 18 /*&& channel == 1*/, {
			~phaseDel = val.linlin(0, 127, 0, 1);
			~vstDelaySynth.synth.set(\phase, ~phaseDel);
			"Phase Delay".postln;
			~phaseDel.postln;
		});

		if(ccNum == 19 /*&& channel == 1*/, {
			~fdbackDel = val.linlin(0, 127, 0, 1);
			~vstDelaySynth.synth.set(\fdback, ~fdbackDel);
			"Feedback Delay".postln;
			~fdbackDel.postln;
		});

		if(ccNum == 20 /*&& channel == 1*/, {
			~lcDel = val.linlin(0, 127, 0, 1);
			~vstDelaySynth.synth.set(\lc, ~lcDel);
			"Lc Delay".postln;
			~lcDel.postln;
		});

		if(ccNum == 78 /*&& channel == 1*/, {
			~mixVerb = val.linlin(0, 127, 0, 1);
			~vstMassiveSynth.synth.set(\mix, ~mixVerb);
			"Verb mix".postln;
			~mixVerb.postln;
		});

		//~vstDelaySynth.editor;
		//~vstMassiveSynth.editor;

		//wipe du filtre brickWall
		if(ccNum == 55 /*&& channel == 1*/, {
			~wipeBrick = val.linexp(0, 127, -0.5, -0.999);
			~brickWallSynth.set(\wipe, ~wipeBrick);
		});
		//dry/wet brickWall
		if(ccNum == 83 /*&& channel == 1*/, {
			~mixBrick = val.linlin(0, 127,0, 1).round(0.1);
			~brickWallSynth.set(\mix, ~mixBrick);
			"mix brick".postln;
			~mixBrick.postln;
		});

		//temps de reverb
		if(ccNum == 56 /*&& channel == 1*/, {
			~revTim = val.linlin(0, 127, 0.1, 2).round(0.1);
			~reverbSynth.set(\revtime, ~revTim);
		});
		//dry/wet reverb
		if(ccNum == 84 /*&& channel == 1*/, {
			~revMix = val.linlin(0, 127, 0.01, 0.5).round(0.1);
			~reverbSynth.set(\mix, ~revMix);
			"mix reverb".postln;
			~revMix.postln;
		});

		//temps de delay
		if(ccNum == 54 /*&& channel == 0*/, {
			~delTime = val.linexp(0, 127, 0.01, 1).round(0.1);
			~delaySynth.set(\mTime, ~delTim);
			"delay time".postln;
			~delTime.postln;
		});

		if(ccNum == 34 /*&& channel == 1*/, {
			~delTrail = val.linexp(0, 127, 0.1, 5).round(0.1);
			~delaySynth.set(\decay, ~delTrail);
			"delay decay".postln;
			~delTrail.postln;
		});
/*
		//volume petits sons
		if(ccNum == 19 && channel == 1, {
			~volSound = val.linlin(0, 127, 0, 2).round(0.1);
			~saturator.set(\amp, ~volSound);
			"Volume samples".postln;
			~volSound.postln;
		});
*/
		//mix saturation
		if(ccNum == 81 /*&& channel == 1*/, {
			~mixSat = val.linlin(0, 127, 0, 0.5);
			~saturator.set(\mix, ~mixSat);
			"Mix Saturation".postln;
			~mixSat.postln;
		});

		//saturation
		if(ccNum == 53 /*&& channel == 1*/, {
			~saturPot = val.linlin(0, 127, 0.2, 15);
			~saturator.set(\saturation, ~saturPot);
			"Saturation".postln;
			~saturPot.postln;
		});

		//saturation HPF
		if(ccNum == 33 /*&& channel == 1*/, {
			~saturHpf = val.linlin(0, 127, 10, 7800).round(10);
			~saturator.set(\freqHpf, ~saturHpf);
			"Saturation HPF".postln;
			~saturHpf.postln;
		});

		//dry/wet delay
		if(ccNum == 82 /*&& channel == 1*/, {
			~delMix = val.linlin(0, 127, 0, 1);
			~delaySynth.set(\mix, ~delMix);
			"Delay DryWet".postln;
			~delMix.postln;
		});

		if(ccNum == 13 /*&& channel == 1*/,{
			~dur = val.linlin(0,127,0.01,0.4);
			~g.do({ arg n; n.set(\baseDur, ~dur) });
			"durée granulateur".postln;
			~dur.postln;
		});

		if(ccNum == 14 /*&& channel == 1*/,{
			~rateGran = val.linlin(0,127,0.4, 2);
			~g.do({ arg n; n.set(\rate, ~rateGran) });
			"rate granulateur".postln;
			~rateGran.postln;
		});
	});
};

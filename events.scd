

~makeEvents = {
	MIDIClient.init;
    //MIDIIn.connectAll;

	e = Dictionary.new;

	e.add(\init -> {
		~one = Synth(\radio, [\in, 0, \out, ~bus[\delayValh] , \amp, 0], ~mainGrp);//radio
		~recBuff = Buffer.alloc(s, s.sampleRate * 5, 1);
		//~recBuff.plot;
		~radioRead = Synth(\AudioInputMono, [\input, 0, \out, ~bus[\radioBus], \amp, 1], ~radioGrp);
		~radioPtr = Synth(\ptr, [\buf, ~recBuff, \out, ~bus[\ptrBus]], ~ptrGrp);
		~radioRecord = Synth(\rec, [\ptrIn, ~bus[\ptrBus], \micIn, ~bus[\radioBus], \buf, ~recBuff], ~recGrp);
		~vstDelaySynth.open("ValhallaFreqEcho", editor: true, verbose:true);
		~vstMassiveSynth.open("ValhallaSupermassive", editor: true, verbose:true);
	});

    e.add(\loadPresets-> {
		~vstMassiveSynth.loadPreset("dirtyVerb1");
		// ~vstMassiveSynth.editor;
		// ~vstMassiveSynth.savePreset("dirtyVerb1");
    e.add(\loadPresets-> {
		~vstMassiveSynth.loadPreset("dirtyVerb1");
		// ~vstMassiveSynth.editor;
		// ~vstMassiveSynth.savePreset("dirtyVerb1");
	});

	e.add(\event9
		-> {
			~boucheGran.stop;
			~mer.stop;
			~granOizo.stop;
			~chord.stop;
			~snow.set(\relOut, 1, \gate,0);
			//~g.do({ arg n; n.set(\gate, 0) });

			~granOizo = Pbind(
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

	e.add(\event10 -> {
		~granOizo.stop;
		~mer.stop;
		~chord.stop;
		~snow.set(\relOut, 1, \gate,0);
		//~g.do({ arg n; n.set(\gate, 0) });

		~boucheGran = Pbind(
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
		~granOizo.stop;
		~boucheGran.stop;
		~mer.stop;
		~marimba.stop;
		~chord.stop;

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
	});

	e.add(\event4 -> {

		~g.do({ arg n; n.set(\gate, 0, \rel, 1) });
		(
			~recBuff.zero;
			~g =  5.collect({
				arg n;
				Synth(\granRadio, [
					\amp, 0.8,
					\buf, ~recBuff,
					\out, ~bus[\satura],
					\atk, 0.01,
					\rel, 0.3,
					\gate, 1,
					\sync, 1,
					\dens, exprand(20,40),
					\baseDur, exprand(0.3, 0.5),
					\durRand, 1,
					\rate, 1,
					\rateRand, 2.midiratio,
					\pan, 0,
					\panRand, 1,
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

		~granOizo.stop;
		~boucheGran.stop;
		~mer.stop;
		~chord.stop;
		//~g.do({ arg n; n.set(\gate, 0) });

		~mer = Pbind(
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

		~snow.free;
		~snow = Synth(\highNap, [\amp,0.8]);

	});

	e.add(\event6 -> {
		(
			~melo.free;
			~melo = Synth(\audioBuf, [\buf, ~buffers[\melo][0], \loop, 0, \out, 0, \amp, 1],~mainGrp);
		)
	});

	e.add(\event11 -> {(
		~medium.stop;
		~medium = Routine{
			var sustain = 6, transition = 4, overlap = 5;
			var period = transition*2+sustain/overlap;
			1.5.wait;
			inf.do {
				Synth(\medium, [
					\atk, transition,
					\sus, sustain,
					\rel, transition,
					\pan, 1.0.rand2,
					\freqs, {50.0.rrand(5000)}.dup(12),
					\rings, {0.1.rrand(2)}.dup(12)
				]);
				period.wait;
			}
		};
		~medium.play;
	)});

	e.add(\event14 -> {

		~bass.stop;
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

	e.add(\event15 -> {(
		~cloches = Routine{
			var sustain = 8, transition = 1, overlap = 4;
			var period = transition * 2 + sustain / overlap;
			0.5.wait;            // wait for the synthdef to be sent to the server
			inf.do{
				Synth(\cloches, [
					\atk, transition,
					\sus, sustain,
					\rel, transition,
					\pan, 1.0.rand2,
					\freqs, {200.0.rrand(5000)}.dup(12),
					\rings, {0.1.rrand(2)}.dup(12)
				]);
				period.wait;
			}
		};
		~cloches.play;
	)});

	// ~cloches.stop;

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
			Synth(\audioBuf, [\buf, ~buffers[\humain][[0,1,2].choose], \loop, 0, \out, ~bus[\satura], \amp, 1.2], ~mainGrp);
		)

	});

	e.add(\sample11 -> {
		(
			Synth(\audioBuf, [\buf, ~buffers[\fxoizo][[0,1,2,3,4,5].choose], \loop, 0, \out, ~bus[\satura], \amp, 1],~mainGrp);
		)
	});

	e.add(\sample12 -> {
		(
			Synth(\audioBuf, [\buf, ~buffers[\clic][[0,1,2,3].choose], \loop, 0, \out, ~bus[\satura], \amp, 1.2],~mainGrp);
		)
	});

	e.add(\sample13 -> {
		(
			Synth(\audioBuf, [\buf, ~buffers[\grenouilles][[0,1,2,3,4,5,6,7].choose], \loop, 0, \out, ~bus[\satura], \amp, 1.2],~mainGrp);
	)});

	e.add(\sample14 -> {
		(
			~cri = Routine{
	var period = 0.2;
	4.do{
		Synth(\cricket, [\amp, 0.1, \sus, 0.15, \harmo, 3000, \freq, 55, \out, ~bus[\satura]]);
		period.wait;
	};
};
~cri.play;
	)});
	e.add(\sample15 -> {()});
	e.add(\sample16 -> {()});
	/*Synth(\audioBuf, [\buf, ~buffers[\percu][0], \loop, 0, \out, ~bus[\satura], \amp, 0.9],~mainGrp);*/

	e.add(\quit -> {
		~granOizo.stop;
		~boucheGran.stop;
		~mer.stop;
		~chord.stop;
		~water.free;
		~snow.free;
		~medium.stop;
		~snow.set(\relOut, 5, \gate,0);
		~g.do({ arg n; n.set(\gate, 0, \rel, 10) });
		~medium.stop;
		~cloches.stop;
	});

	e.add(\mayday -> {
		MIDIIn.disconnectAll;
		Server.killAll;
	});

	MIDIdef.noteOn(\controller, {
		arg val, num, chan;
		[val, num, chan].postln;
		case
		//nappes sûr
		{num==76 && val==127 }{e[\event4].value;"Nappe radio".postln;}
		// nappes tableau 1
		{num==73 && val==127 && chan==1}{e[\event1].value;"vide".postln;}
		{num==74 && val==127 && chan==1}{e[\event2].value;"vide".postln;}
		{num==75 && val==127 && chan==1}{e[\event3].value;"Nappe synth".postln;}
		{num==41 && val==127 && chan==1}{e[\event5].value;"Nappe mer".postln;}
		{num==42 && val==127 && chan==1}{e[\event6].value;"Transi harpe".postln;}
		{num==43 && val==127 && chan==1}{e[\event7].value;"vide".postln;}
		{num==44 && val==127 && chan==1}{e[\event8].value;"vide".postln;}
		// nappes tableau 2
		{num==73 && val==127 && chan==2}{e[\event9].value;"Nappe oiseaux".postln;}
		{num==74 && val==127 && chan==2}{e[\event10].value;"Nappe voix".postln;}
		{num==75 && val==127 && chan==2}{e[\event11].value;"medium".postln;}
		{num==41 && val==127 && chan==2}{e[\event12].value;"vide".postln;}
		{num==42 && val==127 && chan==2}{e[\event13].value;"vide".postln;}
		{num==43 && val==127 && chan==2}{e[\event14].value;"Nappe bass".postln;}
		{num==44 && val==127 && chan==2}{e[\event15].value;"Nappe cloches".postln;}
		// samples tableau 1
		{num==57 && val==127 && chan==1}{e[\sample1].value;"Bateau".postln;}
		{num==58 && val==127 && chan==1}{e[\sample2].value;"Glouss".postln;}
		{num==59 && val==127 && chan==1}{e[\sample3].value;"Dauphins".postln;}
		{num==60 && val==127 && chan==1}{e[\sample4].value;"Baleins".postln;}
		{num==89 && val==127 && chan==1}{e[\sample5].value;"Rien".postln;}
		{num==90 && val==127 && chan==1}{e[\sample6].value;"Verre vrac".postln;}
		{num==91 && val==127 && chan==1}{e[\sample7].value;"Verre".postln;}
		{num==92 && val==127 && chan==1}{e[\sample8].value;"Goutes".postln;}
		// samples tableau 2
		{num==57 && val==127 && chan==2}{e[\sample9].value;"Craquement".postln;}
		{num==58 && val==127 && chan==2}{e[\sample10].value;"Humain".postln;}
		{num==59 && val==127 && chan==2}{e[\sample11].value;"Oiseau FX".postln;}
		{num==60 && val==127 && chan==2}{e[\sample12].value;"Clic".postln;}
		{num==89 && val==127 && chan==2}{e[\sample13].value;"Grenouilles".postln;}
		{num==90 && val==127 && chan==2}{e[\sample14].value;"Crickets".postln;}
		{num==91 && val==127 && chan==2}{e[\sample15].value;"Rien".postln;}
		{num==92 && val==127 && chan==2}{e[\sample16].value;"Rien".postln;}
		//device (sur launch ctrl XL)
		{num==105 && val==127 }{e[\init].value;"Initialisation".postln;}
		// Mute (sur launch ctrl XL)
		{num==106 && val==127 }{e[\quit].value;"quit".postln;}
		//record arm (sur launch ctrl XL)
		{num==108 && val==127 }{e[\mayday].value;"Panique bouton".postln;}
		{true}{nil};
	});

	MIDIFunc.cc({
		arg val, ccNum, channel;
		[val, ccNum, channel].postln;

		if(ccNum==107, {
			~freeze = val.linexp(0, 127, 0, 1);
			~one.set(\trig, ~freeze);
			"freeze".postln;
		});

		if(ccNum == 77 /*&& channel == 1*/, {
			~volumeSynth = val.linexp(0, 127, 0.001, 0.7);
		});
		if(ccNum == 80 /*&& channel == 1*/, {
			~test = val.linexp(0, 127, -0.70, 0);
		});
		if(ccNum == 83 /*&& channel == 1*/, {
			~mixBrick = val.linexp(0, 127, -1, 1)
		}); // dry/wet du BrickWall

		if(ccNum == 80 /*&& channel == 1*/, {
			~volValh = val.linlin(0, 127, 0, 1);
			~one.set(\amp, ~volValh);
			"Volume Radio".postln;
			~volValh.postln;
		});

		if(ccNum == 79 /*&& channel == 1*/, {
			~mixDel = val.linlin(0, 127, 0, 0.5);
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
			~rqGran = val.linlin(0,127,0.01,1);
			~g.do({ arg n; n.set(\baseDur, ~dur, \rq, ~rqGran) });
			"durée granulateur".postln;
			~dur.postln;
			"rq granulateur".postln;
			~rqGran.postln;
		});

		if(ccNum == 14 /*&& channel == 1*/,{
			~rateGran = val.linlin(0,127,0.4, 2);
			~freqFilter = val.linlin(0,127,20,7000);
			~g.do({ arg n; n.set(\rate, ~rateGran, \freqFilter, ~freqFilter)});
			"rate granulateur".postln;
			~rateGran.postln;
			"frequence filtre granulateur".postln;
			~freqFilter.postln;
		});
		// volume cloches
	/*	if(ccNum == 32 /*&& channel == 1*/,{
			~volCloches = val.linlin(0,127,0.01, 0.5);
			~cloches.set(\amp, ~volCloches);
			"volume cloches".postln;
			~volCloches.postln;
		});*/

	//volume des samples || enfin !!
		if (ccNum == 36, {
			~volSamples = val.linlin(0,127,0,2);
			~saturator.set(\amp, ~volSamples);
			"Volume samples".postln;
			~volSamples.postln;
		});

		if(ccNum == 105 /*&& channel == 1*/,{
			e[\loadPresets].value;"Load Presets".postln;
		});

		if(ccNum == 105 /*&& channel == 1*/,{
			e[\loadPresets].value;"Load Presets".postln;
		});
	});
};

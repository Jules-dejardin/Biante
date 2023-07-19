
//Générateurs de sons
SynthDef(\audioBuf, {
	arg buf, out = 0, amp=1, pos=0, t_trig=1, rate=1, loop=0, rev=0;
    var sig;

    sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, t_trig, BufFrames.kr(buf) * pos, loop: loop, doneAction:2);
	sig = sig * amp;
	sig = Pan2.ar(sig);
	Out.ar(out, sig);
}).add;

//~water = Synth(\audioBuf, [\buf, b[\selecta][8], \loop, 0, \out, ~bus[\delay]]);

SynthDef(\AudioInputStereoHpf, {
	arg input, out = 0, amp = 0, freqHpf = 0;
    var sig;
    sig = SoundIn.ar(input); // entrée carte son
	sig = sig * amp;
	sig = HPF.ar(sig, freqHpf);
	sig = Pan2.ar(sig);
	Out.ar(out, sig); //sortie directe a un bus
}).add;

SynthDef(\AudioInputStereo, {
	arg input = 0, out = 0, amp = 0;
    var sig;
    sig = SoundIn.ar(input); // entrée carte son
	sig = sig * amp.dbamp.lag(1);
	sig = Pan2.ar(sig);
	Out.ar(out, sig); //sortie directe a un bus
}).add;

SynthDef(\AudioInputMono, {
	arg input = 0, out = 0, amp = 0,  freqHpf=0;
    var sig;
    sig = SoundIn.ar(input) * amp; // entrée carte son
	sig = HPF.ar(sig, freqHpf);
	Out.ar(out, sig); //sortie directe a un bus
}).add;

SynthDef(\ptr, {
	arg out=0, buf=0, rate=1;
	var sig;
	sig = Phasor.ar(0, BufRateScale.kr(buf)*rate, 0, BufFrames.kr(buf));
	Out.ar(out, sig);
}).add;

SynthDef(\rec, {
	arg ptrIn=0, micIn=0, buf=0;
	var sig, ptr;
	ptr = In.ar(ptrIn, 1);
	sig = In.ar(micIn, 1);
	BufWr.ar(sig, buf, ptr);
}).add;

//Bruit Blanc Mer

SynthDef(\highNap, {
	arg freq=2000, lfoRate=0.05, out=0, amp=0.7, rq=0.04, lpf=7000, disto=80, relOut=0, gate=1;
	var sig, lfo1, lfo2, env;

	env = EnvGen.kr(Env.asr(5, 1, relOut, 5),gate, doneAction:2);
	freq = freq+(2000*(SinOsc.kr(0.01)+1));
	lfo1 = 500*SinOsc.kr(lfoRate);
	lfo2 = 500*SinOsc.kr(lfoRate+lfoRate);

	sig = BPF.ar(
		[PinkNoise.ar, PinkNoise.ar],
		[freq+(lfo1), freq+100+(lfo2)],
		rq,);// a moduler
	sig = (sig*Lag.kr(LFNoise1.kr(100).exprange(1,disto).round(0.01), 10)).softclip*0.1; //de 0.025 à 0.05
	sig = sig*env*amp;
	sig = LPF.ar(sig, lpf);
	Out.ar(out, sig);
}).add;

//synthé pluk

SynthDef(\bpfsaw, {
	arg atk=2, sus=0,rel=3, c1=1, c2=(-1), freq=500, detune=0.2, cfhzmin=0.1, cfhzmax=0.3, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, lsf=200, ldb=0, amp=1, out=0, pan=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel], [c1,0,c2]),doneAction:2);
	sig =  Saw.ar(freq * {LFNoise1.kr(0.5, detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin, cfhzmax)).exprange(cfmin, cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2
	);
	sig = BLowShelf.ar(sig, lsf, 0.5, ldb);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	sig = LPF.ar(sig, 10000);
	Out.ar(out,sig);
}).add;

SynthDef(\bass, {
	arg atk=2, sus=0,rel=3, c1=1, c2=(-1), freq=500, detune=0.2, cfhzmin=0.1, cfhzmax=0.3, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, lsf=200, ldb=0, amp=1, out=0, pan=0;
	var sig, env;
	env = EnvGen.kr(Env([0,1,1,0],[atk,sus,rel], [c1,0,c2]),doneAction:2);
	sig =  Saw.ar(freq * {LFNoise1.kr(0.5, detune)}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin, cfhzmax)).exprange(cfmin, cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2
	);
	sig = BLowShelf.ar(sig, lsf, 0.5, ldb);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	sig = LPF.ar(sig, 10000);
	Out.ar(out,sig);
}).add;

//nappes cloches
SynthDef(\cloches, {
arg out=0, amp=0.5, freqs=#[0,0,0,0,0,0,0,0,0,0,0,0], rings=#[0,0,0,0,0,0,0,0,0,0,0,0], atk=5, sus=7, rel=6, pan=0;
var sig, env, trig;

env = EnvGen.kr(Env.linen(atk, sus, rel, amp, 4), doneAction: Done.freeSelf);
trig = Decay.ar(Impulse.ar(Rand(0.8, 2.2)), 0.03, ClipNoise.ar(0.01));
sig = Klank.ar(
`[freqs, nil, rings],    // '=tableau de tableau
trig                    // trigger de cloches
    );
sig = Pan2.ar(sig*env, pan);

Out.ar(out, sig);
}).add;

//nappes douces
SynthDef(\medium,{
arg out=0, freqs=#[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], rings=#[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], atk=5, sus=8, rel=5, pan=0, amp=0.5;
    var env, sig, input;
env = EnvGen.kr(Env.linen(atk, sus, rel, amp, 4), doneAction: Done.freeSelf);
input = BrownNoise.ar(0.00012);
sig = Klank.ar(
        `[freqs, nil, rings],     // specs
        input                 // input
    );
sig = Pan2.ar(sig*env, pan);

    Out.ar(out, sig);
}).add;

//Granulateur
SynthDef(\clarGran,{
	arg sync=1, dens=20, gDur=0.1, durRand=1, buf=0, rate=1, pos=0, posSpeed=0, posRand=0, grainEnv=(-1), pan=0, panHz=0.1, panRand=0, atk=1, sus=1, rel=1, c0=1, c1=2, amp=1, out;

	var sig, env, densCtrl, durCtrl, posCtrl, panCtrl;

	env = EnvGen.ar(Env.new([0,1,0], [atk,sus,rel], [c0,0,c1]), doneAction:2);

	densCtrl = Select.ar(sync, [Dust.ar(dens), Impulse.ar(dens)]);

	durCtrl = gDur * LFNoise1.kr(100).exprange(1/durRand,durRand);

	posCtrl = Phasor.ar(0, posSpeed * BufRateScale.ir(buf), 0, BufSamples.ir(buf)-1);
	posCtrl = posCtrl + LFNoise1.kr(100).bipolar(posRand*SampleRate.ir);
	posCtrl = posCtrl / BufSamples.ir(buf);
	posCtrl = posCtrl + pos;

	panCtrl = pan + LFNoise1.kr(panHz).bipolar(panRand);

	sig = GrainBuf.ar (
		2,
		densCtrl,
		durCtrl,
		buf,
		rate,
		posCtrl,
		2,
		panCtrl,
		grainEnv
	);

	sig = sig * env * amp;

	Out.ar(out,sig);
}).add;

//Env.asr(0.001, 0.5, 1, -10).test(2).plot;

SynthDef(\granRadio,{
	arg sync=1, dens=20, baseDur=0.05, durRand=1, buf=0, rate=1, rateRand=1, grainEnv=(-1), pan=0, panHz=0.1, panRand=0, atk=1, rel=1, amp=1, gate=1, out=0, ptrBus=0, ptrSampleDelay=20000, ptrRandSamples=5000, minPtrDelay=1000, curve=(-10);

	var sig, env, densCtrl, durCtrl, panCtrl, rateCtrl, ptr, ptrRand, totalDelay, maxGrainDur;

	env = EnvGen.ar(Env.asr(atk,1,rel,curve), gate, doneAction:2);
	densCtrl = Select.ar(sync, [Dust.ar(dens), Impulse.ar(dens)]);
	durCtrl = baseDur * LFNoise1.kr(100).exprange(1/durRand,durRand);
	rateCtrl = rate * LFNoise1.ar(100).exprange(1/rateRand, rateRand);
	panCtrl = pan + LFNoise1.kr(panHz).bipolar(panRand);

	ptrRand = LFNoise1.ar(100).bipolar(ptrRandSamples);
	totalDelay = max(ptrSampleDelay - ptrRand, minPtrDelay);

	ptr = In.ar(ptrBus, 1);
	ptr = ptr - totalDelay;
	ptr = ptr / BufFrames.kr(buf);

	maxGrainDur = (totalDelay / rateCtrl) / SampleRate.ir;
	durCtrl = min(durCtrl, maxGrainDur);

	sig = GrainBuf.ar (
		2,
		densCtrl,
		durCtrl,
		buf,
		rateCtrl,
		ptr,
		2,
		panCtrl,
		grainEnv
	);

	sig = sig * env *amp;

	Out.ar(out,sig);
}).add;

//---------------------------------EFFETS-----------------------------------------------//

//VSTPlugin.pluginList(s);

SynthDef(\vstDelay, {
	arg in, out, mix, ms, phase, fdback, lc;
	var sig;

	sig = In.ar(in, 2);
	Out.ar(out, VSTPlugin.ar(sig, 2, id: \vstDelay, params: [0, mix, 2, ms, 1, phase, 4, fdback, 5, lc]));
}).add;

SynthDef(\vstMassive, {
	arg in, out, amp=1, mix=0;
	var sig;

	sig = In.ar(in, 2);
	sig = sig * amp;
	Out.ar(out, VSTPlugin.ar(sig, 2, id: \vstMassive, params: [0, mix]));
}).add;


//Brick wall (sorte de lpf) de -1 à 0 le wipe
SynthDef(\brickWall,{
	//arg buf, wipe=0, amp=0.5, out; // il faut le réintégrer au module
	arg in, amp=0.5, wipe=0, mix=0.5, out=0;
	var dry, wet, sig, chain, size=2048;

	dry = In.ar(in, 1);

	chain = FFT(LocalBuf(size, 1).clear, dry);
	chain = PV_BrickWall(chain, wipe);
	wet = IFFT(chain);

	sig = XFade2.ar(dry, wet, mix*2-1, amp);

	Out.ar(out, sig);
}).add;

//Delay
//à styliser avec une enveloppe || spatialiser
SynthDef(\delay, {
	arg in, dTime=0.2, out=0, amp=1, mix=0.3, decay=3;
	var sig, dry, wet;

	dry = In.ar(in, 1);
	wet = CombL.ar(dry, 0.5, [LFNoise0.kr(0.5).exprange(0.15,0.45), SinOsc.kr(0.5).exprange(0.1,0.4), SinOsc.kr(0.3).exprange(0.2,0.7)], decay);
	wet = Pan2.ar(wet,  LFNoise1.kr(1));

	sig = XFade2.ar(dry, wet, mix*2-1, amp);
	sig = Pan2.ar(sig);

	Out.ar(out,sig);
}).add;

//Reverbération
SynthDef(\reverb, {
	arg in, predelay=0.1, revtime=1.8, lpf=4500, mix=0.15, amp=1, out=0;

	var dry, wet, temp, sig;

	dry = In.ar(in, 2);
	temp = In.ar(in, 2);
	wet = 0;
	temp = DelayN.ar(temp, 0.2, predelay);
	16.do{
		temp = AllpassN.ar(temp, 0.05, {Rand(0.001, 0.05)}!2, revtime);
		temp = LPF.ar(temp, lpf);
		wet = wet + temp;
	};
	sig = XFade2.ar(dry, wet, mix*2-1, amp);

	Out.ar(out,sig);
}).add;

//saturation
SynthDef(\satu, {
	arg in, amp=1, out=0, saturation=0.1, mix=0, freqLpf=7500, freqHpf=120;
	var dry, wet, sig;

	dry = In.ar(in, 2);
	wet = (In.ar(in, 2)*saturation).fold2(1)*0.2;

	sig = XFade2.ar(dry, wet, mix*2-1, amp);
	sig = LPF.ar(sig, freqLpf);
	sig = HPF.ar(sig, freqHpf);

	Out.ar(out,sig);
}).add;

//Freeze
SynthDef(\radio, {
	arg amp=0.5, t_trig=1, in=0, out=0, size=2048, freqHpf=120;
	var sig, chain, env;

    sig = SoundIn.ar(in, 1);

    chain = FFT(LocalBuf(size, 1), sig);
	chain = PV_MagFreeze(chain, Trig.kr(t_trig, 2));

	sig = IFFT(chain) * amp;
	sig = HPF.ar(sig, freqHpf);
	sig = Pan2.ar(sig);

	Out.ar(out, sig);
}).add;

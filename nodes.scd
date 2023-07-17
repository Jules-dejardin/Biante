(


~makeNodes = {


	s.bind({
		~mainGrp = Group.new;
		~radioGrp = Group.after(~mainGrp);
		~ptrGrp = Group.after(~radioGrp);
		~recGrp = Group.after(~ptrGrp);
		~granGrp = Group.after(~recGrp);
		~saturationGrp = Group.after(~granGrp);
		~brickWallGrp = Group.after(~saturationGrp);
		~delayGrp = Group.after(~brickWallGrp); // a bouger si je fait un chainage autre
		~reverbGrp = Group.after(~delayGrp);
		~delayValhGrp = Group.after(~reverbGrp);
		~massiveValhGrp = Group.after(~delayValhGrp);

		~vstDelaySynth = VSTPluginController(Synth(
			\vstDelay,
			[
				\in, ~bus[\delayValh],
				\out, ~bus[\massive]],
			~delayValhGrp
		), id: \vstDelay);

		//~vstDelaySynth.close;

		~vstMassiveSynth = VSTPluginController(Synth(
			\vstMassive,
			[
				\in, ~bus[\massive],
				\out, ~out],
			~massiveValhGrp
		), id: \vstMassive);

		//~vstMassiveSynth.close;

		~saturator = Synth.new(
			\satu,
			[
				\amp, 0.8,
				\saturation, 0.1,
				\freqLpf, 5000,
				\in, ~bus[\satura],
				\out, ~bus[\fftBrick],
			],
			~saturationGrp
		);

		~brickWallSynth = Synth.new(
			\brickWall,
			[
				\amp, 0.6,
				\wipe, -0.99,
				\in, ~bus[\fftBrick],
				\out, ~bus[\delay],
			],
			~brickWallGrp
		);

		~delaySynth = Synth.new(
			\delay,
			[
				\amp, 0.6,
				\dTime, 0.2,
				\decay, 3,
				\mix, 0.3,
				\panRate, 2,
				\in, ~bus[\delay],
				\out, ~bus[\reverb],
			],
			~delayGrp
		);


		~reverbSynth = Synth.new(
			\reverb,
			[
				\amp, 0.6,
				\predelay, 0.1,
				\revtime, 1.8,
				\lpf, 4500,
				\mix, 0.35,
				\in, ~bus[\reverb],
				\out, ~out,
			],
			~reverbGrp
		);
	});
};


)

(

~makeBusses = {

	~bus = Dictionary.new;
	~bus.add(\samples -> Bus.audio(s,2));
	~bus.add(\reverb -> Bus.audio(s, 2));
	~bus.add(\fftBrick -> Bus.audio(s, 2));
	~bus.add(\delay -> Bus.audio(s, 2));
	~bus.add(\delayValh -> Bus.audio(s, 2));
	~bus.add(\massive -> Bus.audio(s, 2));
	~bus.add(\satura -> Bus.audio(s, 2));
	~bus.add(\radioBus -> Bus.audio(s, 1));
	~bus.add(\ptrBus -> Bus.audio(s, 1));

};

)


(

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

s.options.numInputBusChannels_(2);
s.options.numOutputBusChannels_(2);
s.options.sampleRate_(48000);
s.options.memSize_(2.pow(20)); // ~1 GB of active memory
// s.newBusAllocators;

)



`ifndef NOTE_TABLE_VH
`define NOTE_TABLE_VH

// phase delta = (FREQ_HZ / SAMPLE_HZ) * 2^32;

`define NOTE_RST  32'd0         //     0.00000 Hz

`define NOTE_A2   32'd18898     //   110.00000 Hz

`define NOTE_C3   32'd22473     //   130.81280 Hz
`define NOTE_D3   32'd25226     //   146.83240 Hz
`define NOTE_E3   32'd28315     //   164.81380 Hz
`define NOTE_F3   32'd29998     //   174.61410 Hz
`define NOTE_G3   32'd33672     //   195.99770 Hz
`define NOTE_A3   32'd37796     //   220.00000 Hz
`define NOTE_B3   32'd42424     //   246.94170 Hz

`define NOTE_C4   32'd44947     //   261.62560 Hz
`define NOTE_D4   32'd50451     //   293.66480 Hz
`define NOTE_E4   32'd56630     //   329.62760 Hz
`define NOTE_F4   32'd59997     //   349.22820 Hz
`define NOTE_Fs4  32'd63565     //   369.99440 Hz
`define NOTE_A4   32'd75591     //   440.00000 Hz

`define NOTE_C5   32'd89894     //   523.25110 Hz
`define NOTE_Cs5  32'd95239     //   554.36530 Hz
`define NOTE_Fs5  32'd127129    //   739.98880 Hz
`define NOTE_Gs5  32'd142698    //   830.60940 Hz
`define NOTE_A5   32'd151183    //   880.00000 Hz
`define NOTE_As5  32'd160173    //   932.32750 Hz
`define NOTE_B5   32'd169697    //   987.76660 Hz

`endif

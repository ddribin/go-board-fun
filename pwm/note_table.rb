#!/usr/bin/env ruby

require 'pp'

notes = [
  ["RST", 0],
  [],
  ["A2",  110.0000],
  [],
  ["C3",  130.8128],
  ["D3",  146.8324],
  ["E3",  164.8138],
  ["F3",  174.6141],
  ["G3",  195.9977],
  ["A3",  220.0000],
  ["B3",  246.9417],
  [],
  ["C4",  261.6256],
  ["D4",  293.6648],
  ["E4",  329.6276],
  ["F4",  349.2282],
  ["Fs4", 369.9944],
  ["A4",  440.0000],
  [],
  ["C5",  523.2511],
  ["Cs5", 554.3653],
  ["Fs5", 739.9888],
  ["Gs5", 830.6094],
  ["A5",  880.0000],
  ["As5", 932.3275],
  ["B5",  987.7666],
]

SAMPLE_HZ = 25_000_000
notes.each_with_index do |note|
  if note.count == 0
    puts
    next
  end

  name = note[0]
  freq_hz = note[1]
  count = (freq_hz * 2**32 / SAMPLE_HZ).round
  printf "  `define NOTE_%-3s  32'd%-8d  // %f Hz\n", name, count, freq_hz
end

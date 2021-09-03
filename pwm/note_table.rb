#!/usr/bin/env ruby

require 'pp'
require 'optparse'

NOTES = [
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

COMMAND = File.basename($0)
USAGE = "Usage: #{$COMMAND} [defines | table]"

def print_note_defines
  NOTES.each_with_index do |note|
    if note.count == 0
      puts
      next
    end
  
    name = note[0]
    freq_hz = note[1]
    count = (freq_hz * 2**32 / SAMPLE_HZ).round
    printf "`define NOTE_%-3s  32'd%-8d  // %11.5f Hz\n", name, count, freq_hz
  end
end

if ARGV.length != 1
  $stderr.puts USAGE
  return 1
end

subcommand = ARGV[0]

case subcommand
when "defines"
  print_note_defines
when "table"
else
  $stderr.puts USAGE
  return 1
end

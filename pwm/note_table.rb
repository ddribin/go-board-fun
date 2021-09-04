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
  ["Cs4", 277.1826],
  ["D4",  293.6648],
  ["E4",  329.6276],
  ["F4",  349.2282],
  ["Fs4", 369.9944],
  ["Gs4", 415.3047],
  ["A4",  440.0000],
  ["As4", 466.1638],
  ["B4",  493.8833],
  [],
  ["C5",  523.2511],
  ["Cs5", 554.3653],
  ["Fs5", 739.9888],
  ["Gs5", 830.6094],
  ["A5",  880.0000],
  ["As5", 932.3275],
  ["B5",  987.7666],
  [],
  ["Cs6", 1108.731],
]
SAMPLE_HZ = 25_000_000
BPM = 180

COMMAND = File.basename($0)
USAGE = "Usage: #{$COMMAND} [defines | table]"

def print_note_defines
  puts '`ifndef NOTE_TABLE_VH'
  puts '`define NOTE_TABLE_VH'
  puts

  i = 0
  NOTES.each do |note|
    if note.count == 0
      puts
      next
    end
  
    name = note[0]
    freq_hz = note[1]
    printf "`define NOTE_%-3s  6'd%-3d  // %11.5f Hz\n", name, i, freq_hz
    i += 1
  end

  puts
  puts '`endif'
end

def print_note_table
  i = 0
  NOTES.each do |note|
    if note.count == 0
      puts
      next
    end

    freq_hz = note[1]
    count = (freq_hz * 2**32 / SAMPLE_HZ).round
    printf "%08X  // %11.5f Hz\n", count, freq_hz
    i += 1
  end

  separator = "\n"
  while i < 64
    puts "#{separator}00000000"
    separator = ""
    i += 1
  end
end

def print_duration_table
  tick_per_sec = 60
  ticks_per_min = 60*tick_per_sec
  notes_per_beat = 4

  beats_per_tick = BPM.to_f / ticks_per_min
  notes_per_tick = notes_per_beat * beats_per_tick
  ticks_per_note = 1/ notes_per_tick
  sec_per_note = ticks_per_note / tick_per_sec
  clocks_per_note = SAMPLE_HZ * sec_per_note

  (1..32).each_with_index do |note_len, index|
    duration = (note_len * clocks_per_note).round
    printf "      5'd%02d: r_duration = 32'd%d;\n", index, duration
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
  print_note_table
when "duration"
  print_duration_table
else
  $stderr.puts USAGE
  return 1
end

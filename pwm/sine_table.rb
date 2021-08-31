#!/usr/bin/env ruby

(0..255).each do |i|
  radians = i*2*Math::PI/256
  sin_0_to_2_float = Math.sin(radians) + 1.0
  sin_0_to_256_float = 128 * sin_0_to_2_float
  sin_0_to_256_int = sin_0_to_256_float.round
  printf "%03X\n", sin_0_to_256_int
end

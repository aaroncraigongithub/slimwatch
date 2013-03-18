#!/usr/bin/env ruby

require 'listen'

if ARGV.count < 1
  puts "Usage: [-scrtlpohv] [--trace] slimwatch SLIM_DIR\nFor option values, run slimrb --help"
  exit
end

def main(listen_to, options)
  # Initial run
  Dir.glob("#{ listen_to }/*.slim").each do |filepath|
    slim_it filepath, options
  end

  # Now listen
  Listen.to(listen_to, :filter => /\.slim$/) do |modified, added, removed|

    modified.each do |filepath|
      slim_it(filepath, options)
    end

    added.each do |filepath|
      slim_it(filepath, options)
    end

    removed.each do |filepath|
      # ignoring these for now
    end
  end

end

def slim_it(filename, options)
  infile = filename
  outfile = infile.sub(/\.slim$/, '')

  outfile<< '.html' unless outfile =~ /\.html?$/

  system("slimrb #{ options } #{ infile } > #{ outfile }")
end

main(ARGV.pop, ARGV.count > 0 ? ARGV.join(' ') : '')

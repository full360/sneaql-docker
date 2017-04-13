#!/bin/env ruby

require 'yaml'

secrets_file = ARGV[0] ? ARGV[0] : 'secrets.yml'
secrets = YAML.load(
  File.read(secrets_file)
)
source_file = File.open('secrets.sh', 'w')
secrets.keys.select {|k| !k.match(/^\_/) }.each do |s|
  source_file.puts "export #{s}=`/usr/sbin/biscuit get -f #{secrets_file} #{s}`"
end
source_file.close
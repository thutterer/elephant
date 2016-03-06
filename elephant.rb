#!/usr/bin/env ruby

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

case ARGV[0]
when 'install', 'in'
  Zypper.install ARGV[1]
else
  puts 'wrooong!'
end


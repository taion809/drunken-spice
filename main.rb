require 'json'
require './lib/rcd'

config = RCD::ConfigLoader.new.load('config')
if config.nil?
    exit
end

job = RCD::JobLoader.new.load(config['job_directory'])
puts "Job: #{job}"

RCD::JobRunner.new(job).run("my job")
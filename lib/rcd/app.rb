require 'sinatra/base'

class RCD::App < Sinatra::Base
    configure do
        set :rcd_config,  RCD::ConfigLoader.new.load('config')
        set :job_files,   RCD::JobLoader.new.load(settings.rcd_config['job_directory'])
        set :jobs,        RCD::JobRunner.new(settings.job_files)
    end

    get '/' do
        puts "Config #{settings.rcd_config['job_directory']} \n\n"
        puts "Jobs #{settings.job_files} \n\n"
    end
end
require 'sinatra/base'

class RCD::App < Sinatra::Base
    configure do
        #is this right?  should I do it another way?
        #basically just need to load the configuration
        #and load the jobs... perhaps this should be a DSL instead?
        set :rcd_config,  RCD::ConfigLoader.new.load('config')
        set :job_files,   RCD::JobLoader.new.load(settings.rcd_config['job_directory'])
        set :jobs,        RCD::JobRunner.new(settings.job_files)
    end

    get '/' do
        puts "Config #{settings.rcd_config['job_directory']} \n\n"
        puts "Jobs #{settings.job_files} \n\n"
    end

    post '/github/repo/:job' do |j|
        if !settings.jobs.exists? j
            redirect to('/')
        end

        settings.jobs.run(j)
        redirect to('/')
    end
end
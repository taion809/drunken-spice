require 'shellwords'

module RCD
    class JobRunner
        attr_accessor :job_directives

        def initialize(job_directives)
            if job_directives.nil?
                raise "Invalid Argument"
            end

            @job_directives = job_directives
        end

        def exists?(job)
            return @job_directives.has_key? job
        end

        def run(job)
            if !@job_directives.has_key? job
                return false
            elsif !@job_directives[job].has_key? 'build'
                return false
            end

            if @job_directives[job].has_key? 'before'
                run_list(@job_directives[job]['before'])
            end

            run_list(@job_directives[job]['build'])

            if @job_directives[job].has_key? 'after'
                run_list(@job_directives[job]['after'])
            end
        end

        private
        def run_list(exec_list)
            #this looks like an arrow, refactor.
            exec_list.each do |item|
                item.each do |key, value|
                    if key == 'exec'
                        run_exec(value)
                    end
                end
            end
        end

        def run_exec(command, escape = true)
            if escape
                command["arguments"] = Shellwords.escape(command["arguments"])
            end

            return system command["command"] + " " + command["arguments"]
        end
    end
end
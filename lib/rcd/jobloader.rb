module RCD
    class JobLoader
        attr_accessor :job_directives

        def initialize()
            @job_directives = Hash.new
        end

        def load(job_directory)
            if job_directory.nil?
                return nil
            end

            job_directory = File.absolute_path(job_directory)

            files = load_directory(job_directory)
            files.each do |file|
                parsed = load_files(job_directory, file)
                
                directive_title = begin parsed.fetch('job') rescue next end
                next if @job_directives.has_key? directive_title

                directive = Hash.new
                parsed.each do |key, value|
                    next if key == 'job'
                    next if directive.has_key? key
                                        
                    directive = directive.merge({key => value})
                end

                @job_directives = @job_directives.merge({directive_title => directive})
            end

            return @job_directives
        end

        private
        def load_directory(job_directory, ignore = '.')
            return Dir.entries(job_directory).select { |dir|
                !File.directory? File.join(job_directory, dir) and dir[0,1] != ignore
            }
        end

        private
        def load_files(file_directory, file_name)
            file_path = File.join(file_directory, file_name)

            if !File.exists? file_path
                return nil
            end

            file = File.open(file_path)

            data = file.read()
            file.close()

            return JSON.parse data
        end
    end
end
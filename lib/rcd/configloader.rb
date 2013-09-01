module RCD
    class ConfigLoader
        attr_accessor :config_directives

        def initialize()
            @config_directives = Hash.new
        end

        def load(config_directory)
            if config_directory.nil?
                return nil
            end

            config_directory = File.absolute_path(config_directory)

            files = load_directory(config_directory)
            files.each do |file|
                directive = load_files(config_directory, file)

                directive.each do |key, value|
                    if @config_directives.has_key? key
                        raise "Configuration directive exists"
                    end
                                        
                    @config_directives = @config_directives.merge({key => value})
                end
            end

            return @config_directives
        end

        private
        def load_directory(config_directory, ignore = '.')
            return Dir.entries(config_directory).select { |dir|
                !File.directory? File.join(config_directory, dir) and dir[0,1] != ignore
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
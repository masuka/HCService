require 'yaml'
require 'json'
require_relative 'log'

module HCService

	module Conf
		extend self

		CONF_PATH = File.absolute_path(File.join(File.dirname(__FILE__), '..', 'conf'))

		def load
			@files = []
			Dir["#{CONF_PATH}/*"].each do |f|
				log.info "Loading conf file #{f}"
				load_file(f)
				@files << File.basename(f)
			end
		end

		def load_file(file)

			ext = File.extname(file); ext[0] = ''
			name = File.basename(file).split('.')[0]
			if respond_to?(ext) then
				instance_eval "@#{name} = File.open(file, 'r') { |f| send(ext, f) }"
				instance_eval "def #{name}; @#{name}; end" unless respond_to? name
			else
				log.info "Can't process file #{file}, no processor for extension #{ext}"
			end

		end

		def yml(file)
			decorate_hash YAML.load(file)
		end

		def json(file)
			decorate_hash JSON.load(file)
		end

		private 

		def decorate_hash(target)
			class << target
					def [](item)
						if item.is_a? String and item.include? '.' then
							result = self
							item.split('.').each  { |i| result = result[i] }
							return result
						end
						super
					end
			end if target.respond_to? :[]
			target
		end

	end

	Conf.load

end

def conf
	::HCService::Conf
end

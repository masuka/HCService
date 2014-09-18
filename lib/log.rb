require 'logging'

include Logging.globally :log

Logging.appenders.stdout(:level => :debug, :layout => Logging.layouts.pattern(:pattern => '[%d] %-5l -%c-: %m\n', :backtrace => true))
Logging.appenders.rolling_file(
	'hc_service.log',
	:level	=> 'debug',
	:age    => 'daily',
	:rol_by	=> 'date',
	:keep 	=> 10,
	:layout => Logging.layouts.pattern(:pattern => '[%d] %-5l -%c-: %m\n', :backtrace => true),
	:filename => File.absolute_path(File.join(File.dirname(__FILE__), '..', 'log', 'hc_service.log'))
)
Logging.logger.root.add_appenders 'stdout', 'hc_service.log'

at_exit do
	log.error $! if $!
end

log.info 'Logger intiated!'






  

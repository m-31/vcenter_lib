require_relative '../../lib/vcenter_lib'

# no logging output during spec tests
VcenterLib::Logging.logger.level = Logger::FATAL

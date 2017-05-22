require_relative '../../lib/vcenter_lib'

# no logging output during spec tests
VcenterLib.logger.level = Logger::FATAL

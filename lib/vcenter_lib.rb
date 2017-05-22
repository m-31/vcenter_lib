require 'logger'

# library for easy acces to vcenter informations
module VcenterLib
  require_relative 'vcenter_lib/logging'
  require_relative 'vcenter_lib/version'
  require_relative 'vcenter_lib/vcenter'
  require_relative 'vcenter_lib/vm_converter'

  def logger
    unless @logger
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO
    end

    @logger
  end
end

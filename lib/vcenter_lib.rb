require 'logger'

module VcenterLib
  require '../lib/vcenter_lib/version'
  require '../lib/vcenter_lib/vcenter'
  require '../lib/vcenter_lib/vm_converter'

  def logger
    unless @logger
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO
    end

    @logger
  end
end

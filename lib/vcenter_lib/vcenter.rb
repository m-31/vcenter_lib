require 'rbvmomi'

module VcenterLib
  # central access point
  class Vcenter
    include Logging

    def initialize(options = {})
      @username    = options[:username]
      @password    = options[:password]
      @vcenter     = options[:vcenter]
      @insecure    = options[:insecure]
    end

    # get array of all datacenters
    def dcs
      vim.rootFolder.childEntity.grep(RbVmomi::VIM::Datacenter)
    end

    # get all vms in all datacenters
    def vms
      logger.debug "get all VMs in all datacenters: begin"
      result = dcs.inject([]) do |result, dc|
        result + serviceContent.viewManager.CreateContainerView(
          container: dc.vmFolder,
          type: ['VirtualMachine'],
          recursive: true
        ).view
      end
      logger.debug "get all VMs in all datacenters: end"
      result
    end

    # find vm
    def find_vm_by_name(vm_name)
      logger.debug("search for #{vm_name}")
      serviceContent.propertyCollector.collectMultiple(vms, 'name').find do |_k, v|
        v['name'] == vm_name
      end[0]
    end

    # rubocop:disable Style/MethodName
    def serviceContent
      vim.serviceContent
    end
    # rubocop:enable Style/MethodName

    def vim
      @vim || @vim = RbVmomi::VIM.connect(
        host:     @vcenter,
        user:     @username,
        password: @password,
        insecure: @insecure
      )
    end
  end
end

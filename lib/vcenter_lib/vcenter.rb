require 'rbvmomi'

class VcenterLib::Vcenter

  def initialize(options = {})
    @username    = options[:username]
    @password    = options[:password]
    @vcenter_url = options[:vcenter_url]
    @insecure    = options[:insecure]
  end

  # get array of all datacenters
  def dcs
    vim.rootFolder.childEntity.grep(RbVmomi::VIM::Datacenter)
  end

  # get all vms in all datacenters
  def vms
    dcs.inject([]) do |result, dc|
      result += serviceContent.viewManager.CreateContainerView({
          container: dc.vmFolder,
          type: ['VirtualMachine'],
          recursive: true
        }).view
    end
  end

  # fast find vm
  def find_vm(vm_name)
    serviceContent.propertyCollector.collectMultiple(vms, 'name').find { |k, v| v['name'] == vm_name }[0]
  rescue
    nil
  end

  def serviceContent
    vim.serviceContent
  end

  def vim
    @vim || (@vim = RbVmomi::VIM.connect host: @vcenter_url, user: @username, password: @password, insecure: @insecure)
  end
end


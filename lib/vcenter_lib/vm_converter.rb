require 'rbvmomi'

module VcenterLib
  class VmConverter

    # see http://vijava.sourceforge.net/vSphereAPIDoc/ver51/ReferenceGuide/vim.vm.ConfigInfo.html
    ATTRIBUTES = [
      'name',
      'config.annotation',
      'config.cpuHotAddEnabled',
      'config.instanceUuid',
      'config.firmware',
      'config.memoryHotAddEnabled',
      'config.template',
      'config.uuid',
      'config.hardware.numCoresPerSocket',
      'config.hardware.numCPU',
      'config.hardware.memoryMB',
      'config.guestFullName',
      'config.guestId',
      'config.version',
      'guest.guestState',
      'guest.ipAddress',
      'guest.toolsStatus',
      'guest.toolsVersionStatus',
      'overallStatus',
      'runtime.bootTime',
      'runtime.connectionState',
      'runtime.maxCpuUsage',
      'runtime.maxMemoryUsage',
      'runtime.powerState',
      'summary.config.numEthernetCards',
      'summary.config.numVirtualDisks',
      'summary.guest.guestFullName',
      'summary.guest.hostName',

      'runtime.host',
      # 'resourcePool',
      # 'parent',
      # 'summary.quickStats',

      # summary:          'summary',
      # storage:          'storage',
      # devices:          'config.hardware.device',
    ]

    def initialize(vcenter)
      @vcenter = vcenter
    end

    # convert a VMware managed object into a simple hash.
    def convert_vm_mor_to_h(vm_mob)
      return nil unless vm_mob
      props2h(vm_mob.collect!(*ATTRIBUTES))
    end

    def props2h(props)
      additions = {}
      props.delete_if do |k, v|
        if v.is_a? RbVmomi::VIM::HostSystem
          additions['datacenter'] = host_attribute(v.path, RbVmomi::VIM::Datacenter) rescue nil
          additions['cluster']    = host_attribute(v.path, RbVmomi::VIM::ClusterComputeResource) rescue nil
          additions['hypervisor'] = v.name rescue nil
        end
      end
      props.merge!(additions)
    end

    # return parent object based on class provides name of RbVmomi object.
    def host_attribute path, type
      path.select { |x| x[0].is_a? type }[0][1]
    end

    def convert_vm_mobs_to_attr_hash(vm_mobs)
      vms = @vcenter.serviceContent.propertyCollector.collectMultiple(vm_mobs, *ATTRIBUTES)
      hosts = {} # cache already known hosts here
      vms.map do |vm, props|
        additions = {}
        props.delete_if do |k, v|
          if v.is_a? RbVmomi::VIM::HostSystem
            additions = hosts[v] || {}
            if additions.empty?
              additions['datacenter'] = host_attribute(v.path, RbVmomi::VIM::Datacenter) rescue nil
              additions['cluster']    = host_attribute(v.path, RbVmomi::VIM::ClusterComputeResource) rescue nil
              additions['hypervisor'] = v.name rescue nil
              hosts[v] = additions
            end
          end
        end
        props.merge!(additions)
      end
    end
  end
end

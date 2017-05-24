require 'rbvmomi'

module VcenterLib
  # convert VMware managed object into a simple hash
  class VmConverter
    include Logging

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
    ].freeze

    def initialize(vcenter)
      @vcenter = vcenter
    end

    # get all vms and their facts as hash with vm.name as key
    def facts
      logger.debug "get complete data of all VMs in all datacenters: begin"
      result = Hash[vm_mos_to_h(@vcenter.vms).map do |h|
        [h['name'], Hash[h.map { |k, v| [k.tr('.', '_'), v] }]]
      end]
      logger.debug "get complete data of all VMs in all datacenters: end"
      result
    end

    # convert a VMware RbVmomi::VIM::ManagedObject into a simple hash.
    def vm_mo_to_h(vm_mo, attributes = ATTRIBUTES)
      return nil unless vm_mo
      props2h(vm_mo.collect!(*attributes))
    end

    def vm_mos_to_h(vm_mobs, attributes = ATTRIBUTES)
      vms = @vcenter.serviceContent.propertyCollector.collectMultiple(vm_mobs, *attributes)
      hosts = {} # cache already known hosts here
      vms.map do |_vm, props|
        extra = {}
        props.delete_if do |_k, v|
          if v.is_a? RbVmomi::VIM::HostSystem
            extra = hosts[v] || {}
            if extra.empty?
              # rubocop:disable Style/RescueModifier
              extra['datacenter'] = attribute(v.path, RbVmomi::VIM::Datacenter) rescue nil
              extra['cluster'] = attribute(v.path, RbVmomi::VIM::ClusterComputeResource) rescue nil
              extra['hypervisor'] = v.name rescue nil
              # rubocop:enable Style/RescueModifier
              hosts[v] = extra
            end
            true
          end
        end
        props.merge!(extra)
      end
    end

    private

    def props2h(props)
      extra = {}
      props.delete_if do |_k, v|
        if v.is_a? RbVmomi::VIM::HostSystem
          # rubocop:disable Style/RescueModifier
          extra['datacenter'] = attribute(v.path, RbVmomi::VIM::Datacenter) rescue nil
          extra['cluster'] = attribute(v.path, RbVmomi::VIM::ClusterComputeResource) rescue nil
          extra['hypervisor'] = v.name rescue nil
          # rubocop:enable Style/RescueModifier
        end
      end
      props.merge!(extra)
    end

    # return parent object based on class provides name of RbVmomi object.
    def attribute(path, type)
      path.select { |x| x[0].is_a? type }[0][1]
    end
  end
end

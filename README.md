# vcenter library

Use your vCenter credentials to ask for properties of any VM.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vcenter_lib'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vcenter_lib


## Usage

    require 'pp'
    require 'benchmark'
    require_relative 'lib/vcenter_lib'
    
    options = {}
    options[:username]    = 'my_user@vcenter'
    options[:password]    = 'my_secret_password'
    options[:vcenter_url] = 'vcenter01.ds.my_vcenter.com'
    options[:insecure]    = true                      # you might need this
    
    @vcenter = VcenterLib::Vcenter.new(options)
    @vm_converter = VcenterLib::VmConverter.new(@vcenter)
    
    puts 'get properties for certain VM'
    vm = nil
    time = Benchmark.realtime do
      pp vm = @vcenter.find_vm('my_server.my_company.com')
      pp @vm_converter.convert_vm_mor_to_h(vm)
    end
    
    puts "run for #{time} seconds"
    
    puts 'get properties for all VMs'    
    vms = nil
    time = Benchmark.realtime do
      pp (vms = @vm_converter.convert_vm_mobs_to_attr_hash(@vcenter.vms)).size
    end
    
    pp vms
    puts "run for #{time} seconds"


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/m-31/vcenter_lib.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

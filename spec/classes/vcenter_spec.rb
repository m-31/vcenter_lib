require_relative 'spec_helper'

describe VcenterLib::Vcenter do
  subject do
    options = {
      username: 'my_user@vcenter',
      password: 'my_secret_password',
      vcenter:  'vcenter01.ds.my_vcenter.com'
    }
    described_class.new(options)
  end

  context '#initialize' do
    it 'should create a RbVmomi::VIM' do
      expect(RbVmomi::VIM).to
      receive(:connect)
        .with(host:     'vcenter01.ds.my_vcenter.com',
              user:     'my_user@vcenter',
              password: 'my_secret_password',
              insecure: nil) do
        Class.new do
          def vim
            self
          end
        end.new
      end
      subject.send(:vim)
    end
  end
end

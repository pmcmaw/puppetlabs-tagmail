require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper
install_ca_certs unless ENV['PUPPET_INSTALL_TYPE'] =~ /pe/i
install_module_on(hosts)
install_module_dependencies_on(hosts)

UNSUPPORTED_PLATFORMS = ['windows','Solaris','Darwin']

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install test dependencies
    hosts.each do |host|
      on host, puppet('module install puppetlabs-inifile'), { :acceptable_exit_codes => [0,1] }
    end
  end
end

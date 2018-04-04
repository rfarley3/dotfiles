# -*- mode: ruby -*-
Vagrant.configure("2") do |config|

  # The `vagrant plugin` and `vagrant box` commands don't try to load plugins,
  # so `has_plugin?` will return false regardless of whether the plugins are
  # installed.
  if !['plugin', 'box'].include? ARGV[0]
    unless Vagrant.has_plugin?("vagrant-ca-certificates")
      raise "Missing required plugin 'vagrant-ca-certificates', run `vagrant plugin install vagrant-ca-certificates`\n"
    end

    unless Vagrant.has_plugin?("vagrant-proxyconf")
      raise "Missing required plugin 'vagrant-proxyconf', run `vagrant plugin install vagrant-proxyconf`\n"
    end
  end

  # Set Proxy settings (requires vagrant-proxyconf plugin)
  config.proxy.http     = "#{ENV['http_proxy']}" || "http://gatekeeper-w.mitre.org:80"
  config.proxy.https    = "#{ENV['https_proxy']}" || "http://gatekeeper-w.mitre.org:80"
  config.proxy.no_proxy = "localhost,127.0.0.1,.mitre.org"
  # Add MITRE CA Certificate (requires vagrant-ca-certificates plugin)
  config.ca_certificates.enabled = true
  config.ca_certificates.certs = [
    "http://pki.mitre.org/MITRE%20BA%20ROOT.crt",
    "http://pki.mitre.org/MITRE%20BA%20NPE%20CA-1.crt",
    "http://pki.mitre.org/MITRE%20BA%20NPE%20CA-3.crt",
  ]

  # Run a custom bootstrap script
  # thisdir = File.expand_path File.dirname(__FILE__)
  # config.vm.provision :shell, :path => File.join(thisdir, "bootstrap.sh")

end

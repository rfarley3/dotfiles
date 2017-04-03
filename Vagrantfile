# -*- mode: ruby -*-
# Attempt to get ENV value for proxy, else fall back to hard-coded
VAGRANT_MITRE_PROXY = "http://gatekeeper-w.mitre.org:80"
VAGRANT_HTTP_PROXY = "#{ENV['http_proxy']}" || VAGRANT_MITRE_PROXY
VAGRANT_HTTPS_PROXY = "#{ENV['https_proxy']}" || VAGRANT_MITRE_PROXY

Vagrant.configure("2") do |config|

  # Set Proxy settings (requires vagrant-proxyconf plugin)
  if Vagrant.plugins_enabled? and Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = VAGRANT_HTTP_PROXY
    config.proxy.https    = VAGRANT_HTTPS_PROXY
    config.proxy.no_proxy = "localhost,127.0.0.1,.mitre.org"
  # else
  #   raise "Missing required plugin 'vagrant-proxyconf'"
  end

  # Add MITRE CA Certificate (requires vagrant-ca-certificates plugin)
  if Vagrant.plugins_enabled? and Vagrant.has_plugin?("vagrant-ca-certificates")
    config.ca_certificates.enabled = true
    config.ca_certificates.certs = [ "http://pki.mitre.org/MITRE%20BA%20ROOT.crt" ]
  # else
  #   raise "Missing required plugin 'vagrant-ca-certificates'"
  end

  # Apt and pip can use a box specific cache to speed up future provisions
  # if Vagrant.has_plugin?("vagrant-cachier")
  #   config.cache.scope = :box
  # end

  # This keeps vbox guest tools up to date (seamless mousing, copy/paste, networking, etc)
  # if Vagrant.has_plugin?("vagrant-vbguest")
  #   # if you get errors about missing make, from inside guest:
  #   # sudo apt-get update; sudo apt-get install build-essential
  #   # on host:
  #   # vagrant vbguest --do rebuild; vagrant reload
  #   config.vbguest.auto_update = true
  # end

  # Run a custom bootstrap script
  # thisdir = File.expand_path File.dirname(__FILE__)
  # config.vm.provision :shell, :path => File.join(thisdir, "bootstrap.sh")

end

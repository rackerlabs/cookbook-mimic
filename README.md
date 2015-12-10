mimic
===========
Simple cookbook for [mimic](1)

development
===========
When setting `node["mimic"]["dev"]` to true, you are
expected to provide your own checkout of mimic mounted
at `node["mimic"]["path"]`

[Vagrant](2) example:
```
Vagrant.configure("2") do |config|
  config.vm.synced_folder "/home/src/path", "`node["mimic"]["path"]`"
end
```

[1]: https://github.com/rackerlabs/mimic
[2]: https://www.vagrantup.com/

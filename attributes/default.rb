default['mimic']['owner'] = 'daemon'
default['mimic']['group'] = 'daemon'

default['mimic']['path'] = '/opt/mimic'
default['mimic']['virtualenv'] = '/srv/mimic'

default['mimic']['version'] = nil
default['mimic']['runit_actions'] = %w(enable start)

default['mimic']['dev'] = false

default['mimic']['disabled'] = false

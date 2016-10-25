default['mimic']['owner'] = 'daemon'
default['mimic']['group'] = 'daemon'

default['mimic']['path'] = '/opt/mimic'
default['mimic']['virtualenv'] = '/srv/mimic'

default['mimic']['version'] = nil
default['mimic']['runit_actions'] = ['enable', 'start']

default['mimic']['dev'] = false

defafult['mimic']['disabled'] = false
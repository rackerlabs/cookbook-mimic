name             'mimic'
maintainer       'Rackspace'
maintainer_email 'chef@lists.rackspace.com'
license          'Apache 2.0'
description      'Installs/Configures mimic'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.5'

supports 'ubuntu'

depends 'runit'

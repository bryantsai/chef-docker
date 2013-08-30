# docker cookbook

This cookbook installs and configure [Docker](http://www.docker.io/) on a Centos/RHEL machine.
It can also, install a local Docker Registry.

# WARNING

This cookbook will install a third-party kernel RPM. Not too sure what would happen if you
called RedHat for support on a machine running that kernel.

# Requirements

To run this cookbook in Vagrant, you need to install the vagrant-vbguest plugin.

`vagrant plugin install vagrant-vbguest`

# License and Author

Author:: Jean-Francois Theroux (<failshell@gmail.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


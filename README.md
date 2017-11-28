# Rancher::Api

[![Gem Version](https://badge.fury.io/rb/rancher-api.svg)](http://badge.fury.io/rb/rancher-api)
![Downloads](http://ruby-gem-downloads-badge.herokuapp.com/rancher-api)


[![Circle CI](https://circleci.com/gh/akurkin/rancher-api/tree/master.svg?style=svg)](https://circleci.com/gh/akurkin/rancher-api/tree/master)
[![Code Climate](https://codeclimate.com/github/akurkin/rancher-api/badges/gpa.svg)](https://codeclimate.com/github/akurkin/rancher-api)
[![Test Coverage](https://codeclimate.com/github/akurkin/rancher-api/badges/coverage.svg)](https://codeclimate.com/github/akurkin/rancher-api/coverage)


Rancher::Api is a Ruby wrapper around [Rancher](http://rancher.com/) API built with [Her](http://www.her-rb.org/)

Connect to Rancher and execute requests from your ruby scripts.
It allows you to use some of the super nice features from Rancher:

- provision VMs from different cloud providers (behind the scenes Rancher uses docker-machine, so that means you can create VMs in DigitalOcean, AWS, Rackspace and many more, check [list of supported drivers by Docker Machine](https://docs.docker.com/machine/drivers/))
- deploy your containers
- watch your containers
- scale your containers as you wish

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rancher-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rancher-api

## Rancher Version

Tested with:
gem < 0.6.0 -> Rancher v1.1.0
gem >= 0.6.0 -> Rancher v1.2.0

## Usage

Configure Rancher::Api first by providing url, access and secret keys:

### Classes

- **Machinedriver**
(http://rancher.com/docs/rancher/v1.6/en/api/v2-beta/api-resources/machineDriver/)
- **Projecttemplate** (http://rancher.com/docs/rancher/v1.6/en/api/v2-beta/api-resources/project/)
- **Registrationtoken** (http://rancher.com/docs/rancher/v1.6/en/api/v2-beta/api-resources/registrationToken/)
- **Project**
Top level object that represents "Environment" in Rancher UI
http://rancher.com/docs/rancher/v1.6/en/api/v2-beta/api-resources/project/
- **Service**
Service (combines containers from the same image)
http://rancher.com/docs/rancher/v1.6/en/api/v2-beta/api-resources/service/
- **Machine**
Physical docker hosts
http://rancher.com/docs/rancher/v1.6/en/api/v2-beta/api-resources/machine/
- **Instance**
represents containers that were ever installed via Rancher. Better to query containers as nested resource, cuz there can be thousands of containers that were running before and still available to query via API. Removed containers are marked as 'removed' respectively.

- **Environment**
In Rancher UI these are known as **Stack**, though in API they are **environments**. We're sticking to API resource name.
http://rancher.com/docs/rancher/v1.6/en/api/v2-beta/api-resources/stack/
- **Host**
These are hosts, with detailed information about docker installation and resources.
http://rancher.com/docs/rancher/v1.6/en/api/v2-beta/api-resources/host/

### Setup

#### Using initializer

```ruby
require 'rancher/api'

Rancher::Api.configure do |config|
  config.url = 'http://127.0.0.1:8080/v1/'
  config.access_key = '8604A1FC8C108BAFB1E3'
  config.secret_key = '4BhuyyyAaaaaBbbbi7yaZzzAaa3y13pC6D7e569'
end
```

#### Using environment variables

IMPORTANT NOTE: Use environment's API keys. This is done for compatibility with rancher-compose to utilize same keys

    By default, the API keys under the API section are account API keys and you need to create an environment API key, which is in the Advanced Options.

You can configure `rancher-api` gem using `rancher-compose`-compatible environment variables:

- RANCHER_URL
- RANCHER_ACCESS_KEY
- RANCHER_SECRET_KEY

```ruby
Rancher::Api.setup!
```

### Querying

Now, you're able to query entities like this:

```ruby
project = Rancher::Api::Project.all.to_a
machine = Rancher::Api::Machine.find('1ph1', _project_id: project.id)
```

`rancher/api` gem uses ORM Her which hence inherently supports all of the features that Her has to offer. To get more details, review this page https://github.com/remiprev/her#fetching-data

Some of the example queries include:
## List all ProjectTemplate
```ruby
project_templates = ::Rancher::Api::Projecttemplate.all
ap project_templates.map do |project_template|
  {
           name:project_template.name,
    description:project_template.description,
             id:project_template.id,
          state:project_template.state
  }
end
#=>
[
    [0] {
               :name => "Mesos",
        :description => "Default Mesos template",
                 :id => "1pt1",
              :state => "active"
    },
    [1] {
               :name => "Kubernetes",
        :description => "Default Kubernetes template",
                 :id => "1pt2",
              :state => "active"
    },
    [2] {
               :name => "Windows",
        :description => "Experimental Windows template",
                 :id => "1pt3",
              :state => "active"
    },
    [3] {
               :name => "Swarm",
        :description => "Default Swarm template",
                 :id => "1pt4",
              :state => "active"
    },
    [4] {
               :name => "Cattle",
        :description => "Default Cattle template",
                 :id => "1pt5",
              :state => "active"
    }
]
```
## Find the ProjectTemplate named Kubernetes
```ruby
kubernetes_template = ::Rancher::Api::Projecttemplate.where(name:'Kubernetes').first
ap kubernetes_template
#=>
#<Rancher::Api::Projecttemplate(projecttemplates/1pt2)
  type="projectTemplate"
  links={
    "self"=>"http://xxx.yyy.zzz.ttt:8080/v2-beta/projecttemplates/1pt2",
    "accounts"=>"http://xxx.yyy.zzz.ttt:8080/v2-beta/projecttemplates/1pt2/accounts"
  }
  actions={
    "remove"=>"http://xxx.yyy.zzz.ttt:8080/v2-beta/projecttemplates/1pt2/?action=remove"
  }
  baseType="projectTemplate"
  name="Kubernetes"
  state="active"
  accountId=nil
  created="2017-11-20T21:39:09Z"
  createdTS=1511213949000
  data={
    "fields"=>{
      "stacks"=>[
        {
          "name"=>"kubernetes",
          "templateId"=>"library:infra*k8s"
        },{
          "name"=>"network-services",
          "templateId"=>"library:infra*network-services"
        },{
          "name"=>"ipsec",
          "templateId"=>"library:infra*ipsec"
        },{
          "name"=>"healthcheck",
          "templateId"=>"library:infra*healthcheck"
        }
      ]
    }
  }
  description="Default Kubernetes template"
  externalId="catalog://library:project*kubernetes:0"
  isPublic=true
  kind="projectTemplate"
  removeTime=nil
  removed=nil
  stacks=[
    {
      "type"=>"catalogTemplate",
      "name"=>"kubernetes",
      "templateId"=>"library:infra*k8s"
    },{
      "type"=>"catalogTemplate",
      "name"=>"network-services",
      "templateId"=>"library:infra*network-services"
    },{
      "type"=>"catalogTemplate",
      "name"=>"ipsec",
      "templateId"=>"library:infra*ipsec"
    },{
      "type"=>"catalogTemplate",
      "name"=>"healthcheck",
      "templateId"=>"library:infra*healthcheck"
    }
  ]
  transitioning="no"
  transitioningMessage=nil
  transitioningProgress=nil
  uuid="e0919a00-0349-4775-8382-08a64d6e268c"
  id="1pt2"
>
```
## Create a new project from the Kubernetes ProjectTemplate
```ruby
jupytercloud_project = ::Rancher::Api::Project.create({
  name:'JupyterCloud',
  projectTemplateId:kubernetes_template.id
})
ap jupytercloud_project
#=>
```
## List all machine drivers
```ruby
machine_drivers = ::Rancher::Api::Machinedriver.all
ap machine_drivers:machine_drivers.map do |machine_driver|
  {
       id:machine_driver.id,
     name:machine_driver.name,
    state:machine_driver.state
  }
end

[
    [ 0] {
           :id => "1md1",
         :name => "packet",
        :state => "active"
    },
    [ 1] {
           :id => "1md2",
         :name => "amazonec2",
        :state => "inactive"
    },
    [ 2] {
           :id => "1md3",
         :name => "azure",
        :state => "inactive"
    },
    [ 3] {
           :id => "1md4",
         :name => "digitalocean",
        :state => "inactive"
    },
    [ 4] {
           :id => "1md5",
         :name => "ubiquity",
        :state => "inactive"
    },
    [ 5] {
           :id => "1md6",
         :name => "exoscale",
        :state => "inactive"
    },
    [ 6] {
           :id => "1md7",
         :name => "generic",
        :state => "inactive"
    },
    [ 7] {
           :id => "1md8",
         :name => "google",
        :state => "inactive"
    },
    [ 8] {
           :id => "1md9",
         :name => "openstack",
        :state => "active"
    },
    [ 9] {
           :id => "1md10",
         :name => "rackspace",
        :state => "inactive"
    },
    [10] {
           :id => "1md11",
         :name => "softlayer",
        :state => "inactive"
    },
    [11] {
           :id => "1md12",
         :name => "vmwarevcloudair",
        :state => "inactive"
    },
    [12] {
           :id => "1md13",
         :name => "vmwarevsphere",
        :state => "inactive"
    },
    [13] {
           :id => "1md14",
         :name => "opennebula",
        :state => "inactive"
    }
]

```
## Find the MachineDriver named **openstack**
```ruby
driver_openstack = ::Rancher::Api::Machinedriver.where(name:'openstack').first
ap driver_openstack
#=>
#<Rancher::Api::Machinedriver(machinedrivers/1md9)
  type="machineDriver"
  links={
    "self"=>"http://xxx.yyy.zzz.ttt:8080/v2-beta/machinedrivers/1md9"
  }
  actions={
    "activate"=>"http://xxx.yyy.zzz.ttt:8080/v2-beta/machinedrivers/1md9/?action=activate", "update"=>"http://xxx.yyy.zzz.ttt:8080/v2-beta/machinedrivers/1md9/?action=update",
    "remove"=>"http://xxx.yyy.zzz.ttt:8080/v2-beta/machinedrivers/1md9/?action=remove",
  }
  baseType="machineDriver"
  name="openstack"
  state="inactive"
  activateOnCreate=false
  builtin=true
  checksum=nil
  created="2017-11-20T21:38:55Z"
  createdTS=1511213935000
  data={
    "fields"=>{
      "schemaVersion"=>"https://github.com/rancher/machine-package/releases/download/v0.10.0-pre1/docker-machine.tar.gz",
      "url"=>"local://",
      "builtin"=>true,
      "defaultActive"=>false
    }
  }
  defaultActive=false
  description=nil
  externalId=nil
  kind="machineDriver"
  removeTime=nil
  removed=nil
  transitioning="no"
  transitioningMessage=nil
  transitioningProgress=nil
  uiUrl=nil
  url="local://"
  uuid="129f7769-13ba-42d5-9ca1-98a2dd712340"
  id="1md9"
>
```
## Activate the OpenStack machine driver
```ruby
driver_openstack = ::Rancher::Api::Machinedriver.where(name:'openstack').first
ap ::Rancher::Api::Action.for_resource(:machinedriver)
                         .with_id(driver_openstack.id)
                         .action(:activate)
                         .create
#=>
#<Rancher::Api::Action(machinedriver/1md9/?action=activate/1md9)
  resource_name=:machinedriver
  resource_id="1md9"
  action=:activate
  data={
    "fields"=>{
      "schemaVersion"=>"https://github.com/rancher/machine-package/releases/download/v0.10.0-pre1/docker-machine.tar.gz",
      "url"=>"local://",
      "builtin"=>true,
      "defaultActive"=>false
    }
  }
  id="1md9"
  type="machineDriver"
  links={
    "self"=>"http://xxx.yyy.zzz.ttt:8080/v2-beta/machinedrivers/1md9"
  }
  actions={
    "error"=>"http://xxx.yyy.zzz.ttt:8080/v2-beta/machinedrivers/1md9/?action=error", "remove"=>"http://xxx.yyy.zzz.ttt:8080/v2-beta/machinedrivers/1md9/?action=remove", "deactivate"=>"http://xxx.yyy.zzz.ttt:8080/v2-beta/machinedrivers/1md9/?action=deactivate"
  }
  baseType="machineDriver"
  name="openstack"
  state="activating"
  activateOnCreate=false
  builtin=true
  checksum=nil
  created="2017-11-20T21:38:55Z"
  createdTS=1511213935000
  defaultActive=false
  description=nil
  externalId=nil
  kind="machineDriver"
  removeTime=nil
  removed=nil
  transitioning="yes"
  transitioningMessage="In Progress"
  transitioningProgress=nil
  uiUrl=nil
  url="local://"
  uuid="129f7769-13ba-42d5-9ca1-98a2dd712340"
>
```

```ruby
project = Rancher::Api::Project.all.to_a.first

project.machines

# exact machine name
project.machines.where(name: 'ciqa01')

# machine's name not equal to
project.machines.where(name_ne: 'qa')

# machine's name starts with
project.machines.where(name_prefix: 'qa')

# other attributes

# state not active
project.machines.where(state_ne: 'active')

# state activating
project.machines.where(state: 'activating')
```

### Creating new machines
Creating new machine using **Digital Ocean** driver:

**NOTICE**: First specify driver, so that driver_config= accessor can correctly map config on the right attribute. I.e. for 'digitalocean' config attribute is 'digitaloceanConfig'.

#### Digital Ocean

```ruby
project = Rancher::Api::Project.all.to_a.first

new_machine = project.machines.build
new_machine.driver = Rancher::Api::Machine::DIGITAL_OCEAN
new_machine.driver_config = Rancher::Api::Machine::DriverConfig.new(
    accessToken: 'xyz',
    size: '1gb',
    region: 'ams3',
    image: 'ubuntu-14-04-x64'
)

new_machine.save
```

#### Vmware Vsphere

```ruby
project = Rancher::Api::Project.all.to_a.first

new_machine = project.machines.build
new_machine.name = 'api-test'
new_machine.driver = Rancher::Api::Machine::VMWARE_VSPHERE
new_machine.driver_config = Rancher::Api::Machine::DriverConfig.new(
    boot2dockerUrl: nil,
    cpuCount: '1',
    datacenter: 'ha-dc',
    datastore: 'prod',
    diskSize: '10000',
    memorySize: '1024',
    network: 'prod',
    password: 'holamundo',
    pool: nil,
    username: 'myuser',
    vcenter: 'vcenter.happyops.com',
    vcenterPort: nil
)

new_machine.save
```


### Executing shell commands in containers

```ruby
container = Rancher::Api::Instance.find('1i382')
puts container.execute('whoami').response
puts container.execute(['bundle', 'exec', 'rake', 'db:create', 'db:migrate']).response
```

## Development

### Console
To load environment with pry run `pry -I lib -r rancher/api`

Then execute `Rancher::Api.setup!` to configure rancher credentials from environment variables and load models.

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/akurkin/rancher-api.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

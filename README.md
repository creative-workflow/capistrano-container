# Capistrano::Container [![Gem Version](https://badge.fury.io/rb/capistrano-container.svg)](https://badge.fury.io/rb/capistrano-container)

Helps managing [docker](https://www.docker.com/) container and files inside docker container for Capistrano 3.x.

This project is in an early stage but helps me alot dealing with my container deployments and keeps my code clean. It is not only ment for docker, but at the moment it only supports docker, feel free to contribute =)

This gem does not handle Dockerfiles (build, push, etc.) but handles docker container on your dev or staging system.

The container implememnation auto detects if it should run on local or remote docker-engine (see below).

## Installation

Add this lines to your application's `Gemfile`:

```ruby
gem 'capistrano', '>= 3.0.0'
gem 'capistrano-container'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-container

Dont forget to require the module in your `Capfile`:

```ruby
require 'capistrano/container'
```  

## Usage
### definition
Define and register a container by doing the following in your `deploy.rb` (or `[stage].rb`):

```ruby
...

server 'www.example.com', user: 'root', roles: %w{web}

container 'db',  roles: %w{db},
                 container_id: 'website_company_beta_db',
                 server: ['www.example.com']

container 'php', roles: %w{php},
                 container_id: 'website_company_beta_php',
                 server: ['www.example.com']

...
```

This registers two container (db, php) for the server www.example.com. You can use the container roles later to filter container like the way you filter server in capistrano (`on([:role]) do ...` expresion).

The container id is optional. If its not set, the container id equals to the name you gave the container as first argument. The container id will be used later to run commands like `container.upload` or `container.execute` (with `docker exec [container_id] [command]`).

If you define a container, the role `:container_host` will be added to the given hosts, so you can filter hosts that are running that specific container. Also a container specific role will be added. For a container like `container 'php', roles: %w{php}, ...` the host get a role named `:container_php`.


### commandline tasks
There are generic container tasks you can run on local or remote host (you will be asked for `container_id` sometimes).

```ruby
cap container:all                  # show all docker containers
cap container:delete               # delete a docker container
cap container:diff                 # show FS diffs of docker container
cap container:events               # show events of docker container
cap container:inspect              # show info of docker container
cap container:logs                 # show logs of docker container
cap container:pause                # pause a docker container
cap container:ports                # show shows public facing port of docker container
cap container:ressources           # show resource usage statistics of docker container
cap container:restart              # restart a docker container
cap container:running              # show running docker containers
cap container:stop                 # stop a docker container
cap container:top                  # show running processes of docker container
cap container:unpause              # unpause a docker container
cap container:update_docker        # update docker
```

Also individual tasks will be created for every container you define in your `deploy.rb`:

```ruby
cap container:php:delete           # delete a docker container
cap container:php:diff             # show FS diffs of docker container
cap container:php:events           # show events of docker container
cap container:php:inspect          # show info of docker container
cap container:php:logs             # show logs of docker container
cap container:php:pause            # pause a docker container
cap container:php:ports            # show shows public facing port of docker container
cap container:php:ressources       # show resource usage statistics of docker container
cap container:php:restart          # restart a docker container
cap container:php:stop             # stop a docker container
cap container:php:top              # show running processes of docker container
cap container:php:unpause          # unpause a docker container
```

### ruby tasks
You can run the pre defined tasks on your container like these:

```ruby
after :deploy, :updated do
  on roles :web do |host|
    # do your plain old host application restarts
  end

  on_container_roles :php do |container, host|
    container.invoke 'restart'
  end
end
```
This snipped filters container by the role `:php` and invokes the task `container:#{container.name}:restart`.

Available container accessors:
```ruby
  container = container_by_name :db
  container = container_by_roles :php
  container = container_by_id 'website_company_beta_db'
```

Note that you have to use these commands inside a SSHKit context, means inside a `on roles :containers_host do` block for example.

A container provides the following methods:
```ruby
  # tests if the container has a specific role
  def has_role?(role)

  # the docker container id if configured, the container name instead
  def container_id

  # the container specific role, for a container named php `:container_php`
  def container_role

  # uploads a local file to local or remote running container (with docker cp)
  def upload!(src, target)

  # downloads a local or remote container file to your local host
  def download!(src, target)

  # executes a command on the local or remote docker container(with docker exec)
  def execute(command)

  # invokes a container specific task
  def invoke(task_name)
```

### local stage detection
Local stage per default is named `:local`. If you which to change do `set :local_stage_name, :local` in your stage config.

## TODO
  * integration tests(travis).
  * Implement adapter pattern for other container manager.

## Changes
### Version 0.0.5
  * container now auto detect if they should execute, download and upload on local or remote host.

### Version 0.0.4
  * description

### Version 0.0.3
  * add local stage detection
  * container autodetect if they should execute on local or remote host

### Version 0.0.3
  * use sh instead of bash for docker exec
  * use correct github url

### Version 0.0.2
  * Initial release

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

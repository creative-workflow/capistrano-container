# Capistrano::Container [![Gem Version](https://badge.fury.io/rb/capistrano-container.svg)](https://badge.fury.io/rb/capistrano-container)

Helps managing [docker]() container and files inside docker container for Capistrano 3.x.

This project is in an early stage but helps me alot dealing with my container deployments and keeps my code clean. It is not only ment for docker, but at the moment it only supports docker, feel free to distribute =)

This gem does not handle Dockerfiles or such things, for that there are enough capistrano modules available.

## Installation

Add this lines to your application's Gemfile:

```ruby
gem 'capistrano', '>= 3.0.0'
gem 'capistrano-container'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-container

Dont forget to require the module in your Capfile:

```ruby
require 'capistrano/container'
```  

## Usage
### definition
To define and register a container do the following in your stage config or deploy.rb:

```ruby
...

server('www.example.com', user: 'root', roles: %w{web})

container 'db',  roles: %w{db},
                 container_id: 'website_company_beta_db',
                 server: ['www.example.com']

container 'php', roles: %w{php},
                 container_id: 'website_company_beta_php',
                 server: ['www.example.com']

...
```

This registers two container (db, php) for the server www.example.com. The roles can later be used to filter container like the way you filter server in capistrano.

The container id is optional. If not set, the container id is equal to the name you give the container as first argument. The container id will later be used to run docker commands.

If you define a container, the role `:container_host` will be added to the given hosts, so you can filter hosts that are running container. Also a container specific role will be added, for a container named php `:container_php`.


### commandline tasks
There are general tasks you can run, if needed you will be asked on which container_id the command should run.

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

For every registered container, individual tasks will be creazed. For a container named php the following tasks will be available. (With `cap -T` you can see the container specific tasks, but only if you register your container in the deploy.rb and not in the stage file)

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
You can access the defined container like this:

```ruby
after :deploy, :updated do
  on roles :web do
    # do your application restarts
  end

  on_container_roles :php do |container, host|
    container.invoke 'restart'
  end
end
```
This filters container with the role `:php` and invokes the task `container:#{container.name}:restart`.

Or inside other tasks
```ruby
  container = container_by_name :db
  container = container_by_roles :php
  container = container_by_id 'website_company_beta_db'
```

Note that you have to use this commands inside a SSHKit context, means inside a `on roles :containers_host do` block for example.

A container has the following methods:
```ruby
  # tests if the container has a specific role
  def has_role?(role)

  # the docker container id if configured, the container name instead
  def container_id

  # the container specific role, for a container named php `:container_php`
  def container_role

  # uploads a local file to a temp file on host /tmp, then copies the file into the container with docker cp
  def upload!(src, target)

  # doenloads a container file to host /tmp and then to a local file
  def download!(src, target)

  # executes a command on the docker container with docker exec
  def execute(command)

  # invokes a container specific task
  def invoke(task_name)
```

## TODO
  * Write tests.
  * Implement provider pattern for other container manager.

## Changes
### Version 0.0.2
  * Initial release

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

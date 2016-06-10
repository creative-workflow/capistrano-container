require_relative '../container/mixins.rb'

namespace :container do
  desc "update docker"
  task :update_docker do
    run_container_command("wget -qO- https://get.docker.com/ | sh")
  end

  desc "show all docker containers"
  task :all do
    run_container_command('ps -a')
  end

  desc "show running docker containers"
  task :running do
    run_container_command('ps')
  end

  Mixins.define_tasks
end

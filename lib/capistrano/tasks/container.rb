require_relative '../container/mixins.rb'

namespace :container do
  desc "show docker version"
  task :version do
    run_container_command("-v")
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

namespace :load do
  task :defaults do
    set :local_stage_name, :local
  end
end

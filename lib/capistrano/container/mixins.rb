require 'rake/dsl_definition'

module Mixins
  extend Rake::DSL

  def self.define_tasks(container = nil)
    desc "pause a docker container"
    task :pause do
      run_container_command("pause {container_id}", container)
    end

    desc "unpause a docker container"
    task :unpause do
      run_container_command("unpause {container_id}", container)
    end

    desc "restart a docker container"
    task :restart do
      run_container_command("restart {container_id}", container)
    end

    desc "delete a docker container"
    task :delete do
      run_container_command("rm {container_id}", container)
    end

    desc "stop a docker container"
    task :stop do
      run_container_command("stop {container_id}", container)
    end

    desc "show info of docker container"
    task :inspect do
      run_container_command("inspect {container_id}", container)
    end

    desc "show logs of docker container"
    task :logs do
      run_container_command("logs {container_id}", container)
    end

    desc "show FS diffs of docker container"
    task :diff do
      run_container_command("diff {container_id}", container)
    end

    desc "show resource usage statistics of docker container"
    task :ressources do
      run_container_command("statt {container_id}", container)
    end

    desc "show running processes of docker container"
    task :top do
      run_container_command("top {container_id}", container)
    end

    desc "show events of docker container"
    task :events do
      run_container_command("events {container_id}", container)
    end

    desc "show shows public facing port of docker container"
    task :ports do
      run_container_command("port {container_id}", container)
    end
  end
end

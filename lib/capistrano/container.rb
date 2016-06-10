require_relative 'tasks/container.rb'

module Capistrano
  module Container
    require_relative 'container/instance.rb'
    require_relative 'container/manager.rb'
    require_relative 'container/mixins.rb'
  end
end

$container_manager = Manager.new

module Capistrano
  module DSL
    def container(name, config = {})
      # self gives access to capistrano dsl inside a container instance
      $container_manager.add(name, config)
    end

    def on_container_roles(container_roles, &block)
      container_by_roles(container_roles).each do |container|
        on roles(container.container_role) do |host|
          container.dsl = self
          block.call container, host
        end
      end
    end

    def on_container(container, &block)
      on roles(container.container_role) do |host|
        container.dsl = self
        block.call container, host
      end
    end

    def container_by_roles(roles)
      $container_manager.by_roles(roles).map do |container|
        container.dsl = self
        container
      end
    end

    def container_by_name(name)
      tmp = $container_manager.by_name(name)
      tmp.dsl = self
      tmp
    end

    def container_by_id(id)
      tmp = $container_manager.by_id(id)
      tmp.dsl = self
      tmp
    end

    def run_container_command(command, container = nil)
      if command.include?('{container_id}')
        if container.nil?
          container_id = ask_for_container_id
          container    = container_by_id container_id
        end

        command.gsub!('{container_id}', container.container_id)

        on roles(container.container_role) do |host|
          container.dsl = self

          puts capture("docker #{command}")
        end

      else
        on roles(:container_host) do
            puts capture("docker #{command}")
        end
      end
    end

    def ask_for_container_id()
      invoke 'container:all'

      ask(:container_id, "container id?")

      fetch(:container_id)
    end
  end
end

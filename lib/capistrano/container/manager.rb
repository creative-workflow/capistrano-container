require 'rake/dsl_definition'

module Capistrano
  module Container
    class Manager
      include Rake::DSL

      def initialize()
        @container = {}
      end

      def add(name, config)
        @container[name.to_sym] = container = Instance.new(name, config)

        config[:server].map!{ |ip| server(ip) }

        config[:server].each do |server|
          server.add_roles [:container_host, container.container_role]
        end

        self.create_container_tasks(container)

        container
      end

      def by_name(name)
        @container[name.to_sym]
      end

      def by_id(id)
        @container.each do |name, instance|
          return instance if instance.container_id == id
        end
      end

      def by_roles(roles)
        roles = Array(roles)

        return @container.values if roles.include? :all

        tmp = {}
        roles.each do |role|
          @container.each do |name, instance|
            tmp[name] = instance if instance.has_role? role
          end
        end
        tmp.values
      end

      def create_container_tasks(container)
        namespace :container do
          namespace container.name do
            Mixins.define_tasks(container)
          end
        end
      end
    end

  end
end

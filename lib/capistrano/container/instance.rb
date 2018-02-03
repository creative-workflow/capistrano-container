require 'securerandom'

module Capistrano
  module Container
    class Instance
      attr_reader :name
      attr_reader :config
      attr_writer :dsl

      def initialize(name, config)
        @dsl    = nil
        @name   = name
        @config = {shared_on_host: '/tmp'}.merge(config)
      end

      def has_role?(role)
        return false unless @config.key? :roles

        role = role.to_s if role.is_a? Symbol

        @config[:roles].include? role
      end

      def container_id
        return @name unless @config.key? :container_id

        @config[:container_id]
      end

      def container_role
        "container_#{@name}".to_sym
      end

      def upload!(src, target)
        if @dsl.local_stage?
          self.cp(src, "#{container_id}:#{target}")
          return
        end

        tmp = "#{@config[:shared_on_host]}/capistrano-docker.#{SecureRandom.uuid}.tmp"

        @dsl.upload!(src, tmp)

        self.cp(tmp, "#{container_id}:#{target}")

        @dsl.execute("rm -rf #{tmp}")
      end

      def download!(src, target)
        if @dsl.local_stage?
          self.cp("#{container_id}:#{src}", target)
          return
        end

        tmp = "#{@config[:shared_on_host]}/capistrano-docker.#{SecureRandom.uuid}.tmp"

        self.cp("#{container_id}:#{src}", tmp)

        @dsl.download!(tmp, target)

        @dsl.execute("rm -rf #{tmp}")
      end

      def execute(command)
        command = "docker exec -i #{container_id} sh -c '#{command.gsub("'", "\'")}'"

        @dsl.execute_local_or_remote(command)
      end

      def cp(src, target)
        command = "docker cp #{src} #{target}"

        @dsl.execute_local_or_remote(command)
      end

      def invoke(task_name)
        @dsl.invoke "container:#{@name}:#{task_name}"
      end
    end

  end
end

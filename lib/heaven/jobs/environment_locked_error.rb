module Heaven
  module Jobs
    class EnvironmentLockedError
      @queue = :locks

      def self.perform(lock_params)
        locker = EnvironmentLocker.new(lock_params)

        status = ::Deployment::Status.new(lock_params[:name_with_owner], lock_params[:deployment_id])
        status.description = "#{locker.name_with_owner} is locked on #{locker.environment} by #{locker.locked_by}"

        status.error!

        Rails.logger.info 'Deployment errored out, environment was locked.'
      end
    end
  end
end

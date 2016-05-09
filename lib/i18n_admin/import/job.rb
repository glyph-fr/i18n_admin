module I18nAdmin
  module Import
    class Job
      include SuckerPunch::Job

      def perform(locale, file_path, job_id)
        ActiveRecord::Base.connection_pool.with_connection do
          import = Import::XLS.new(locale, file_path)
          job = I18nAdmin::ImportJob.find(job_id)

          state = import.run ? 'success' : 'error'
          job.update(state: state)
        end
      end
    end
  end
end

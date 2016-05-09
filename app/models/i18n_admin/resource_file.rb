module I18nAdmin
  class ResourceFile < ActiveRecord::Base
    has_attached_file :file
    do_not_validate_attachment_file_type :file

    validates :job_id, presence: true
  end
end

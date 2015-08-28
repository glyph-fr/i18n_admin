module I18nAdmin
  class WhitelistedResource < ActiveRecord::Base
    belongs_to :resource, polymorphic: true

    def self.for(resource)
      where(resource_id: resource.id, resource_type: resource.class.name).first_or_initialize
    end
  end
end

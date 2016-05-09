module Para
  module Admin
    class TranslationsController < ::Para::Admin::CrudResourcesController
      def edit
      end

      def update
      end

      private

      def load_and_authorize_crud_resource
        loader = self.class.cancan_resource_class.new(
          self, :resource, class: resource_model
        )

        loader.load_and_authorize_resource
      end
    end
  end
end

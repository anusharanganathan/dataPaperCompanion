module Hyrax
  module My
    class WorksController < MyController
      class_attribute :create_work_presenter_class
      self.create_work_presenter_class = Hyrax::SelectTypeListPresenter

      def self.configure_facets
        # clear facet's copied from the CatalogController
        blacklight_config.facet_fields = {}
        configure_blacklight do |config|
          config.add_facet_field solr_name("status", :facetable), limit: 5
          config.add_facet_field solr_name("resource_type", :facetable), limit: 5
        end
      end
      configure_facets
      # Search builder for a list of works that belong to me
      # Override of Blacklight::RequestBuilders
      def search_builder_class
        Hyrax::ListWorksSearchBuilder
      end

      def index
        # The user's collections for the "add to collection" form
        @user_collections = collections_service.search_results(:edit)

        add_breadcrumb t(:'hyrax.controls.home'), root_path
        add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
        add_breadcrumb t(:'hyrax.admin.sidebar.works'), hyrax.my_works_path
        @create_work_presenter = create_work_presenter_class.new(current_user)
        super
      end

      private

        def collections_service
          Hyrax::CollectionsService.new(self)
        end

        def search_action_url(*args)
          hyrax.my_works_url(*args)
        end

        # The url of the "more" link for additional facet values
        def search_facet_path(args = {})
          hyrax.my_dashboard_works_facet_path(args[:id])
        end
    end
  end
end

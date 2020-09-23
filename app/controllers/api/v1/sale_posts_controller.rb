module Api
  module V1
    class SalePostsController < ApiController
      def index
        company = Company.find(params[:company_id])
        render json: company.sale_posts.enabled.to_json
      end
    end
  end
end

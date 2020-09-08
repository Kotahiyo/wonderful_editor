module Api::V1
  class ArticlesController < BaseApiController # base_api_controller を継承
    def index
      articles = Article.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      article = Article.find(params[:id])
      render json: article
    end

    def create
      article = current_user.articles.create!(article_params)

      render json: article
    end

    private

      def article_params
        params.require(:article).permit(:title, :body)
      end
  end
end

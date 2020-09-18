module Api::V1
  class ArticlesController < BaseApiController # base_api_controller を継承
    before_action :authenticate_user!, only: [:create, :update, :destroy]

    def index
      articles = Article.published.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    # 公開されている記事だけ取得できるようにする
    # 記事を作成する場合は、記事の公開/非公開を選択できるようにする

    def show
      article = Article.published.find(params[:id])
      render json: article
    end

    def create
      article = current_user.articles.create!(article_params)

      render json: article
    end

    def update
      article = current_user.articles.find(params[:id])
      article.update!(article_params)
      render json: article
    end

    def destroy
      article = current_user.articles.find(params[:id])
      article.destroy!
    end

    private

      def article_params
        params.require(:article).permit(:title, :body, :status)
      end
  end
end

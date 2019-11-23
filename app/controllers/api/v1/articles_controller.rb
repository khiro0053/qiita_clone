class Api::V1::ArticlesController < Api::V1::ApiController
  before_action :set_article, only: [:show, :update, :destroy]

  def index
    articles = Article.all
    render json: articles
  end

  def show
    render json: @article
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

    def set_article
      @article = Article.find(params[:id])
    end
end
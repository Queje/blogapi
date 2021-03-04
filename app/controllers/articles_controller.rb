class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :is_current?, only: [ :update, :destroy ]
  before_action :is_private?, only: [ :show ]

  # GET /articles
  def index
    @articles = Article.where(private: false)

    render json: @articles
  end

  # GET /articles/1
  def show
    render json: @article
  end

  # POST /articles
  def create
    @article = Article.new(article_params)

    if @article.save
      render json: @article, status: :created
    else
      puts(article_params)
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end


  # DELETE /articles/1
  def destroy
    if @article.destroy
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content, :user_id, :private, :picture)
    end

    def is_current?
      @article = Article.find(params[:id])
      unless current_user == @article.user
        render json: @article.errors, status: :unauthorized
      end
    end

    def is_private?
      @article = Article.find(params[:id])
      if current_user != @article.user && @article.private == true
        render json: @article.errors, status: :unauthorized
      end
    end
end

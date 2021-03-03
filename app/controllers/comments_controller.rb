class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :update ]
  before_action :find_article, only: [:index, :create, :update, :destroy]
  before_action :is_current?, only: [ :update, :destroy ]

  def index
    @comments = @article.comments.order(created_at: :desc)

    render json: @comments
  end

  def create
    @comment = @article.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end

  end

  def update
    @comment = @article.comments.find(params[:id])
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = @article.comments.find(params[:id])

    if @comment.destroy
      render json: @comment
    else
      render json: { errors: { comment: ['not owned by user'] } }, status: :forbidden
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def find_article
      @article = Article.find(params[:article_id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content)
    end

    def is_current?
      @comment = @article.comments.find(params[:id])
      unless current_user == @comment.user
        render json: @comment.errors, status: :unauthorized
      end
    end
end

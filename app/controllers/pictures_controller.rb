class PicturesController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :update , :destroy]
  before_action :set_picture, only: [:show, :update, :destroy]
  before_action :find_article, only: [:index, :create, :update, :destroy]
  before_action :is_current?, only: [ :update, :destroy ]

  # GET /pictures
  def index
    @pictures = @article.picture.all

    render json: @pictures
  end

  # GET /pictures/1
  def show
    render json: @picture
  end

  # POST /pictures
  def create
    @picture = @article.picture.new(picture_params)
    @picture.picture.attach(params[:picture])

    if @picture.save
      render json: @picture, status: :created, location: @picture
    else
      render json: @picture.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pictures/1
  def update
    if @picture.update(picture_params)
      render json: @picture
    else
      render json: @picture.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pictures/1
  def destroy
    @picture.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def find_article
      @article = Article.find(params[:article_id])
    end

    def set_picture
      @picture = Picture.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def picture_params
      params.fetch(:picture).permit(:private)
    end

    def is_current?
      @picture = Picture.find(params[:id])
      unless current_user == @picture.user
        render json: @picture.errors, status: :unauthorized
      end
    end

    def is_private?
      @picture = Picture.find(params[:id])
      if current_user != @picture.user && @picture.private == true
        render json: @picture.errors, status: :unauthorized
      end
    end
end

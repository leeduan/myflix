class CategoriesController < ApplicationController
  before_action :require_user
  before_action :set_category, only: [:show]

  def index
    @categories = Category.all
  end

  def show; end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
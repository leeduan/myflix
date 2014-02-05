class VideosController < ApplicationController
  before_action :set_video, only: [:show]

  def show; end

  def search
    @videos = Video.search_by_title(params[:search_terms])
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end
end
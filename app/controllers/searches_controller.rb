class SearchesController < ApplicationController
  def index
    @searches = Search.all
  end

  def show
  end

  def new
  end

  def create
    user_info = get_current_user
    @search = Search.new(search_params)
    @search.country = user_info[:country]
    respond_to do |format|
      format.html {redirect_to searches_url}
      format.json {render json: {search: @search}, status: :ok}
    end
  end

  private

  def search_params
    params.require(:search).permit(:lat, :lng)
  end
end

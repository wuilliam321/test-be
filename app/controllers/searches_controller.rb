class SearchesController < ApplicationController
  before_action :set_search, only: [:show]

  def index
    @searches = Search.all
  end

  def show
  end

  def new
    @search = Search.new
  end

  def create
    current_session = get_current_session
    @search = Search.new(search_params.merge(country: current_session.pretty_user_info[:country],
                                             session: current_session))
    if @search.save
      respond_to do |format|
        format.html {redirect_to searches_url}
        format.json {render json: {search: @search}, status: :ok}
      end
    else
      respond_to do |format|
        flash[:error] = @search.errors.full_messages unless @search.errors.full_messages.empty?
        flash[:error] = "Error while searching" if @search.errors.full_messages.empty?
        format.html {redirect_to searches_path}
        format.json {render json: @search.errors, status: :bad_request}
      end
    end
  end

  # private

  def set_search
    id = params[:id]
    begin
      @search = Search.find id
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html {render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false}
        format.json {render json: {error: "Not found"}, :status => :not_found}
      end
      return false
    end
  end

  def search_params
    params.require(:search).permit(:lat, :lng)
  end
end

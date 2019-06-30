class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :restaurants]

  def index
    @searches = Search.all
  end

  def show
  end

  def new
    @search = Search.new
  end

  def restaurants
    if run_restaurant_search(@search)
      respond_to do |format|
        flash[:success] = "Search restaurant called"
        format.html {redirect_to searches_path(id: @search.id)}
        format.json {render json: {"message": 'Run search called'}, status: :ok}
      end
    end
  end

  def create
    current_session = get_current_session
    country = current_session.pretty_user_info[:country]

    @search = Search.where(search_params).last
    setting = Setting.find_by(key: 'same_request_exp_seconds')
    exp_time = setting ? setting.value.to_i : 60
    if @search && (Time.now - @search.created_at).to_i < exp_time
      flash[:success] = "Search already exists, same response will be returned for Time X"
      respond_to do |format|
        format.html {redirect_to searches_url}
        format.json {render :show, status: :ok}
      end
    else
      @search = Search.new(search_params.merge(country: country,
                                               session: current_session))
      if @search.save && run_restaurant_search(@search)
        respond_to do |format|
          format.html {redirect_to searches_url}
          format.json {render :show, status: :ok}
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
  end

  def set_search
    id = params[:id] || params[:search_id]
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

  def run_restaurant_search(search)
    params = {
        :country => search.country,
        :point => search.gps_point,
        :offset => search_params[:offset],
        :fields => "name,topCategories,ratingScore,logo,deliveryTimeMaxMinutes,link,coordinates",
        :max => search_params[:max]
    }
    res = pedidos_ya_client.restaurant(params: params, token: get_current_session.remote_token)
    search.cached_response = res.to_json
    search.save
  end

  def search_params
    params.fetch(:search, {}).permit(:lat, :lng, :max, :offset)
  end
end

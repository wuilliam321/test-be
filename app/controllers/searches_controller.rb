class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :restaurants]

  def index
    @searches = Search.all.reverse
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
      Rails.logger.info('SEARCHES') {"Reusing cached search query"}
      flash[:success] = "Search already exists, same response will be returned for Time X"
      respond_to do |format|
        format.html {redirect_to searches_url}
        format.json {render :show, status: :ok}
      end
    else
      @search = Search.new(search_params.merge(country: country,
                                               session: current_session))
      condition = @search.save
      if condition
        begin
          run_restaurant_search(@search)
          respond_to do |format|
            format.html {redirect_to searches_url}
            format.json {render :show, status: :ok}
          end
        rescue => e
          respond_to do |format|
            format.html {redirect_to searches_path}
            format.json {render json: e.message, status: :bad_request}
          end
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
        :fields => "id,name,topCategories,ratingScore,logo,deliveryTimeMaxMinutes,link,coordinates,opened",
        :max => search_params[:max]
    }
    begin
      res = pedidos_ya_client.restaurant(params: params, token: get_current_session.remote_token)
    rescue => e
      respond_to do |format|
        flash[:error] = "Error while running search: Remote Server Error: #{e.message}"
        format.html {redirect_to searches_path}
        format.json {render json: e.message, status: :bad_request}
      end
      return false
    end
    new_data = res["data"]
                   .select {|d| d["opened"] == 1}
                   .sort {|d| -d["ratingScore"].to_f}
    min = search_params[:offset] || 0
    max = search_params[:max] || 20
    res["data"] = new_data[min..(max - 1)]
    search.cached_response = res.to_json
    search.save
  end

  def search_params
    params.fetch(:search, {}).permit(:lat, :lng, :max, :offset)
  end
end

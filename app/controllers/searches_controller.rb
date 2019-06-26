class SearchesController < ApplicationController
  def index
    @searches = Search.all
  end

  def show
  end
end

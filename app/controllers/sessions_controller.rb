class SessionsController < ApplicationController

  skip_before_action :must_be_authenticated, :only => :new

  def index
  end

  def new
  end

  def create
  end

  def destroy
  end
end

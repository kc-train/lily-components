class HomeController < ApplicationController
  def index
    @page_name = 'sample_index'
    @component_data = {
    }
  end

  def info
    @page_name = 'sample_info'
    @component_data = {
      component: params[:component]
    }
  end
end
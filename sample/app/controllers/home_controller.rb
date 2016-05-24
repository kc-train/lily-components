class HomeController < ApplicationController
  before_filter :init_sample_data
  def init_sample_data
    @SAMPLE_DATA = {
      'KcTest.Dispatcher' => {
        test_status_url: get_sample_path,
        test_wares_url: get_sample_path,
        test_control_url: post_sample_path,
        test_save_url: post_sample_path,

        sample: true
      }
    }
  end

  def index
    @page_name = 'sample_index'
    @component_data = {
    }
  end

  def info
    @page_name = 'sample_info'
    @component_data = {
      component: params[:component],
      sample_data: @SAMPLE_DATA[params[:component]] || {}
    }
  end

  def get_sample
    render json: {sample: true}
  end

  def post_sample
    render json: {sample: true}
  end
end
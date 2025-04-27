class StaticPagesController < ApplicationController
  def show
    @page = StaticPage.find_by(slug: params[:slug])

    unless @page
      render plain: "Page not found", status: 404
    end
  end
end

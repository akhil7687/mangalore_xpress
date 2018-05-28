class MarketPricesController < ApplicationController

  def scrape
    MarketPricesWorker.perform_at(Time.now)
    render json: { status: "ok" }
    respond_to do |format|
      format.json
    end
  end
end

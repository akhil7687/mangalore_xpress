class NewsScrapeWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 10

  def perform
  	begin
  		Feed.load_news
	  rescue
	  end
	  begin
    	Feed.load_from_daiji
    rescue
    end
  end

end

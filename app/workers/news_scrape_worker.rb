class NewsScrapeWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 10

  def perform
    Feed.load_news
    Feed.load_from_daiji
  end

end

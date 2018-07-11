class Feed < ApplicationRecord
  has_attached_file :pic, styles: { medium: "174x152", thumb: "64x64", large: "320x240>" }, default_url: lambda { |image| ActionController::Base.helpers.asset_path('hcat3.png')}
  validates_attachment_content_type :pic, content_type: /\Aimage\/.*\z/

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  #ALTER TABLE feeds CHARACTER SET = utf8 , COLLATE = utf8_general_ci;
  #ALTER TABLE feeds CHANGE COLUMN description description TEXT CHARACTER SET 'utf8' NOT NULL;
  #ALTER TABLE feeds CHANGE COLUMN title title VARCHAR(255) CHARACTER SET 'utf8' NOT NULL;

  scope :news, -> { where(is_article: [false,nil]) }
  scope :articles, -> { where(is_article: true) }

  def self.load_news
    # kannada prabha karnataka
    urls = ["http://www.kannadaprabha.com/rss/kannada-karnataka-10.xml","http://www.kannadaprabha.com/rss/kannada-nation-4.xml"]
    urls.each do |u|
      Feed.load_from_rss(u,"Kannada Prabha",true)
    end
    urls = ["https://kannada.oneindia.com/rss/kannada-fb.xml"]
    urls.each do |u|
      Feed.load_from_rss(u,"One India",false)
    end
  end

  def self.load_from_rss(url,source,to_offset)
    require 'rss'
    require 'open-uri'
    rss_results = []
    rss = RSS::Parser.parse(open(url).read, false).items
    rss.each do |result|
      f = Feed.where("title=?",result.title).take
      next if f.present?
      f = Feed.new
      f.title = result.title
      f.description = "#{result.description}<br><br><a href='#{result.link}'>Read More @ #{source}</a>"
      f.status = true
      if to_offset
        f.published_date = result.pubDate + (rand(6*60...6*60+120).minutes)
      else
        f.published_date = result.pubDate
      end
      f.news_source = source
      f.save
    end
  end

end

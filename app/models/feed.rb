class Feed < ApplicationRecord
  has_attached_file :pic, styles: { medium: "174x152", thumb: "64x64", large: "320x240>" }, default_url: lambda { |image| ActionController::Base.helpers.asset_path('hcat3.png')}
  validates_attachment_content_type :pic, content_type: /\Aimage\/.*\z/

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  #ALTER TABLE feeds CHARACTER SET = utf8 , COLLATE = utf8_general_ci;
  #ALTER TABLE feeds CHANGE COLUMN description description TEXT CHARACTER SET 'utf8' NOT NULL;
  #ALTER TABLE feeds CHANGE COLUMN title title VARCHAR(255) CHARACTER SET 'utf8' NOT NULL;

  scope :enabled, -> { where(status: [true,nil]) }
  scope :news, -> { where(is_article: [false,nil]) }
  scope :articles, -> { where(is_article: true) }


  before_save :add_lang


  def add_lang
    return if news_source.blank?
    if news_source == "One India" || news_source == "Vijaya Karnataka"
      self.language = "Kannada"
    end
  end

  def self.with_lang(lang)
    if lang == "Kannada"
      return self.where("language=?","Kannada")
    elsif lang == "English"
      return self.where("language=?","English")
    end
    return self
  end

  def self.load_news
    # kannada prabha karnataka
    # urls = ["http://www.kannadaprabha.com/rss/kannada-karnataka-10.xml","http://www.kannadaprabha.com/rss/kannada-nation-4.xml"]
    # urls.each do |u|
    #   Feed.load_from_rss(u,"Kannada Prabha",true)
    # end
    urls = ["https://kannada.oneindia.com/rss/kannada-fb.xml"]
    urls.each do |u|
      Feed.load_from_rss(u,"One India",false)
    end
    urls = ["https://timesofindia.indiatimes.com/rssfeeds/3942690.cms","https://timesofindia.indiatimes.com/rssfeeds/-2128936835.cms","https://timesofindia.indiatimes.com/rssfeeds/1898272.cms"]
    urls.each do |u|
      Feed.load_from_rss(u,"TOI",false)
    end
    urls = ["https://www.thehindu.com/news/cities/Mangalore/?service=rss"]
    urls.each do |u|
      Feed.load_from_rss(u,"HINDU",false)
    end
    urls = ["http://www.newindianexpress.com/States/Karnataka/rssfeed/?id=175&getXmlFeed=true"]
    urls.each do |u|
      Feed.load_from_rss(u,"Indian Express",false,true)
    end
    urls = ["https://vijaykarnataka.indiatimes.com/rssfeeds/11182260.cms"]
    urls.each do |u|
      Feed.load_from_rss(u,"Vijaya Karnataka",false,false)
    end

    urls = ["https://www.drivespark.com/rss/four-wheelers-fb.xml","https://www.drivespark.com/rss/two-wheelers-fb.xml"]
    urls.each do |u|
      Feed.load_from_rss(u,"Drive Spark",false,false,false,"Auto")
    end

    urls = ["https://www.gizbot.com/rss/computer-fb.xml","https://www.gizbot.com/rss/mobile-fb.xml","https://www.gizbot.com/rss/tablet-pc-laptop-fb.xml","https://www.gizbot.com/rss/camera-fb.xml","https://www.gizbot.com/rss/accessories-fb.xml"]
    urls.each do |u|
      Feed.load_from_rss(u,"GizBot",false,false,false,"Gadgets")
    end

    urls = ["https://www.filmibeat.com/rss/filmibeat-bollywood-fb.xml"]
    urls.each do |u|
      Feed.load_from_rss(u,"FilmiBeat",false,false,false,"Bollywood")
    end

    urls = ["https://www.mykhel.com/rss/sports-cricket-fb.xml","https://www.mykhel.com/rss/sports-fb.xml","https://www.mykhel.com/rss/sports-football-fb.xml","https://www.mykhel.com/rss/sports-hockey-fb.xml","https://www.mykhel.com/rss/sports-kabaddi-fb.xml"]
    urls.each do |u|
      Feed.load_from_rss(u,"MyKhel",false,false,false,"Sports")
    end

    urls = ["https://www.boldsky.com/rss/boldsky-beauty-fb.xml","https://www.boldsky.com/rss/boldsky-health-fb.xml","https://www.boldsky.com/rss/boldsky-recipes-fb.xml","https://www.boldsky.com/rss/boldsky-home-garden-fb.xml"]
    urls.each do |u|
      Feed.load_from_rss(u,"BoldSky",false,false,false,"Beauty")
    end

  end

  def self.load_from_rss(url,source,to_offset,selective=false,tim_correct=false,category=nil)
    require 'rss'
    require 'open-uri'
    rss_results = []
    rss = RSS::Parser.parse(open(url).read, false).items
    rss.each do |result|
      if selective
        if ((result.title !~ /mangalore/i) && (result.title !~ /mangaluru/i) && (result.title !~ /ಮಂಗಳೂರು/i))
          next
        end
      end
      f = Feed.where("title=?",result.title).take
      next if f.present?
      f = Feed.new
      f.title = result.title
      next if result.description.blank?
      f.description = "#{result.description}<br><br><a href='#{result.link}'>Read More @ #{source}</a>"
      f.status = true
      if to_offset
        f.published_date = result.pubDate + (rand(6*60...6*60+120).minutes)
      else
        f.published_date = result.pubDate
      end
      if tim_correct
        puts "Time corect"
        f.published_date = Time.now
      end
      f.news_source = source
      f.category = category
      f.save
    end
  end

end

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

  def sort_desc
    doc = Nokogiri::HTML(self.description)
    im = doc.css('img')
    if im.present?
      self.image_url = im.attr('src').to_s
    end
    im.remove
    sr = doc.css('a')
    if sr.present?
      self.src_url = sr.attr('href').to_s
    end
    sr.remove

    des = doc.search("body").inner_html.to_s
    des = des.gsub("<br><br>","")
    self.description = des
    puts des
    puts self.image_url
    puts self.src_url
  end

  def as_json
    super(:only=>[:title,:published_date,:news_source,:image_url,:src_url,:description])
  end


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


  def self.load_from_daiji
    url = "http://www.daijiworld.com/news/default.aspx?nSection=topstories"
    agent = Mechanize.new
    page = agent.get(url)
    last_found = Feed.where("news_source=?","DaijiWorld").take
    row = page.at(".list-posts").search('.post-content')
    if row.size > 0
      if last_found.present?
        first_post_title = row[0].search('h2').search("a").text().strip
        if first_post_title == last_found.title
          return
        end
      end
      row.each_with_index do |r,index|
        link = r.search('h2').at("a")
        
        title = link.text().strip

        puts title

        is_valid = false

        if title =~ /mangaluru/i || title =~ /mangalore/i || title =~ /puttur/i || title =~ /bantwal/i || title =~ /sullia/i || title =~ /udupi/i || title =~ /kundapur/i || title =~ /Belthangad/i || title =~ /kasargod/i || title =~ /Moodbidri/i 
          is_valid = true
        end

        next if !is_valid

        date  = r.search(".post-tags").search("li").text().strip
       
        agent2 = Mechanize.new
        page2 = agent2.get("http://www.daijiworld.com/news/#{link['href']}")
        desc = ""
        paragraphs = page2.at(".post-content").search('p')
        if paragraphs.size > 4
          if paragraphs[1].to_s !~ /<img/
            desc = "#{desc} #{paragraphs[1]}"
          end

          if paragraphs[2].to_s !~ /<img/
            desc = "#{desc} #{paragraphs[2]}"
          end

          if paragraphs[3].to_s !~ /<img/
            desc = "#{desc} #{paragraphs[3]}"
          end

        end
        imgs = page2.at("#ContentPlaceHolder1_col7Content_lblDesc").search("img")

        if imgs.size > 0
          desc = desc.gsub(imgs[0],"")
          desc = "#{imgs[0]} #{desc}"
        end

        desc = "#{desc}<br><a href='http://www.daijiworld.com/news/#{link['href']}'>Read More @ DaijiWorld</a>"

        puts "desc"
        
        f = Feed.where("title=?",title).take
        if f.present?
          next
        end
        f = Feed.new
        f.title = title
        f.description = desc
        f.news_source = "DaijiWorld"
        f.language = "English"
        f.category = "Mangalore"
        f.published_date = date[2..-1]
        f.save
      end
    end
  end

  def self.load_news
    # kannada prabha karnataka
    urls = ["http://www.kannadaprabha.com/rss/kannada-karnataka-10.xml","http://www.kannadaprabha.com/rss/kannada-nation-4.xml"]
    urls.each do |u|
      Feed.load_from_rss(u,"Kannada Prabha",true,false,false,"Karnataka")
    end
    urls = ["https://kannada.oneindia.com/rss/kannada-fb.xml"]
    urls.each do |u|
      Feed.load_from_rss(u,"One India",false,false,false,"Karnataka")
    end
    urls = ["https://timesofindia.indiatimes.com/rssfeeds/3942690.cms"]
    urls.each do |u|
      Feed.load_from_rss(u,"TOI",false,false,false,"Mangalore")
    end

    Feed.load_from_rss("https://timesofindia.indiatimes.com/rssfeeds/-2128936835.cms","TOI",false,false,false,"India")
    Feed.load_from_rss("https://timesofindia.indiatimes.com/rssfeeds/1898272.cms","TOI",false,false,false,"International")

    urls = ["https://www.thehindu.com/news/cities/Mangalore/?service=rss"]
    urls.each do |u|
      Feed.load_from_rss(u,"HINDU",false,false,false,"Mangalore")
    end

    urls = ["http://www.newindianexpress.com/States/Karnataka/rssfeed/?id=175&getXmlFeed=true"]
    urls.each do |u|
      Feed.load_from_rss(u,"Indian Express",false,true,false,"Karnataka")
    end
    urls = ["https://vijaykarnataka.indiatimes.com/rssfeeds/11182260.cms"]
    urls.each do |u|
      Feed.load_from_rss(u,"Vijaya Karnataka",false,false,false,"Mangalore")
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
    urls = ["https://www.oneindia.com/rss/news-india-fb.xml","https://www.oneindia.com/rss/news-fb.xml"]
    urls.each do |u|
      Feed.load_from_rss(u,"OneIndia",false,false,false,"India")
    end
    urls = ["https://www.oneindia.com/rss/news-international-fb.xml"]
    urls.each do |u|
      Feed.load_from_rss(u,"OneIndia",false,false,false,"International")
    end

  end

  def self.load_from_rss(url,source,to_offset,selective=false,tim_correct=false,category=nil)
    require 'rss'
    require 'open-uri'
    rss_results = []
    rss = RSS::Parser.parse(open(url).read, false).items
    rss.each do |result|
      if ((result.title =~ /mangalore/i) && (result.title =~ /mangaluru/i) && (result.title =~ /ಮಂಗಳೂರು/i))
        category = "Mangalore"
      end
      if ((result.description =~ /mangalore/i) && (result.description =~ /mangaluru/i) && (result.description =~ /ಮಂಗಳೂರು/i))
        category = "Mangalore"
      end
      f = Feed.where("title=?",result.title).take
      next if f.present?
      f = Feed.new
      f.title = result.title
      next if result.description.blank?
      f.description = "#{result.description}<br><br><a href='#{result.link}'>Read More @ #{source}</a>"
      
      if result.enclosure.present?
        if result.enclosure.url.present?
          if result.enclosure.type =~ /image/
            f.description = "<img src='#{result.enclosure.url}'> <br> #{f.description}"
          end
        end
      end

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

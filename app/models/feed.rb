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

  def desc
    Base64.encode64(self.description)
  end

  def detl
    Base64.encode64(self.details)
  end

  def pic_url
    "#{URI.join(ActionController::Base.asset_host,self.pic.url(:original))}"
  end


  def as_json(options = { })
    if options[:is_article]
      super(:only=>[:title,:published_date,:news_source,:src_url,:id,:is_article],:methods=>[:detl,:desc,:pic_url])
    else
      super(:only=>[:title,:published_date,:news_source,:image_url,:src_url,:id,:is_article],:methods=>[:desc])
    end
  end


  def add_lang
    sort_desc
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
        img_url = nil
        if imgs.size > 0
          im = imgs[0]
          desc = desc.gsub(imgs[0],"")
          img_url = im.attr('src')
        end

        s_url = "http://www.daijiworld.com/news/#{link['href']}"

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
        f.src_url = s_url
        f.image_url = img_url
        f.published_date = date[2..-1]
        f.save
      end
    end
  end

  def self.load_news
    # kannada prabha karnataka
    urls = ["https://www.kannadaprabha.com/rss/kannada-karnataka-10.xml","https://www.kannadaprabha.com/rss/kannada-nation-4.xml"]
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

    # urls = ["http://www.newindianexpress.com/States/Karnataka/rssfeed/?id=175&getXmlFeed=true"]
    # urls.each do |u|
    #   Feed.load_from_rss(u,"Indian Express",false,true,false,"Karnataka")
    # end
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
    urls = ["http://feeds.bbci.co.uk/news/world/rss.xml"]
    urls.each do |u|
      Feed.load_from_rss(u,"BBC",false,false,false,"International")
    end

  end

  def self.load_from_rss(url,source,to_offset,selective=false,tim_correct=false,category=nil)
    require 'simple-rss'
    require 'open-uri'
    rss_results = []
    SimpleRSS.item_tags << :"enclosure#url"
    SimpleRSS.item_tags << :"media:thumbnail#url"
    rss = (SimpleRSS.parse open(url)).items
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
      f.description = "#{result.description}"
      src_url = "#{result.link}"
      img_url = nil

      if source== "TOI" || source == "Vijaya Karnataka"
        fragment = Nokogiri::HTML.fragment(CGI.unescapeHTML(f.description))
        lnk = fragment.search('a')
        img = fragment.search('img')
        if img.present?
          img_url = img.attr('src')
        end
        lnk.remove
        img.remove
        f.description = fragment.to_s
      end

      if result.media_thumbnail_url.present?
        img_url = result.media_thumbnail_url
      end

      if result.enclosure_url.present?
        img_url = result.enclosure_url
      end

      f.status = true
      if to_offset
        f.published_date = result.pubDate + (rand(6*60...6*60+120).minutes)
      else
        f.published_date = result.pubDate
      end
      f.image_url = img_url
      f.src_url = src_url
      if tim_correct
        puts "Time corect"
        f.published_date = Time.now
      end
      f.news_source = source
      f.category = category
      begin
        f.save
      rescue

      end
    end
  end

end

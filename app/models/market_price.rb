class MarketPrice < ApplicationRecord


  def self.scrape
    MarketPrice.arecanut(140,"Arecanut")
    MarketPrice.arecanut(37,"Coconut")
    MarketPrice.arecanut(36,"Cashew")
    MarketPrice.rubber()
    MarketPrice.coffee()
  end


  def self.coffee
    agent = Mechanize.new
    page = agent.get('http://kpa.org.in/')
    row = page.at("#latestRates").search('.item')
    row.each_with_index do |r,index|
      a1 = row[index].search('h1').text().strip
      a1_p = row[index].search('h5').text().strip.gsub(' ','')
      m = MarketPrice.where("item_id=?",a1).take
      if m.blank?
        m = MarketPrice.new
      end
      m.name = "#{a1}-#{a1_p}"
      m.item_id = a1
      if a1 =~ /pepper/i
        m.item_group = "Pepper"
      else
        m.item_group = "Coffee"
      end
      m.save
    end
  end

  def self.rubber
    agent = Mechanize.new
    page = agent.get('http://rubberboard.org.in/earlyrubberprice.asp')
    row = page.at(".contenttable").search('tr')

    arr = []

    p1 = row[4].search('td')[0].search('font').text().strip()
    p1_p = row[4].search('td')[2].search('font').text().strip()
    p1_c = row[4].search('td')[3].search('font').text().strip()

    hs = Hash.new
    hs[:name] = p1
    hs[:price] = p1_p
    hs[:change] = p1_c
    arr << hs

    p2 = row[5].search('td')[0].search('font').text().strip()
    p2_p = row[5].search('td')[2].search('font').text().strip()
    p2_c = row[5].search('td')[3].search('font').text().strip()

    hs = Hash.new
    hs[:name] = p2
    hs[:price] = p2_p
    hs[:change] = p2_c
    arr << hs

    p3 = row[6].search('td')[0].search('font').text().strip()
    p3_p = row[6].search('td')[2].search('font').text().strip()
    p3_c = row[6].search('td')[3].search('font').text().strip()

    hs = Hash.new
    hs[:name] = p3
    hs[:price] = p3_p
    hs[:change] = p3_c
    arr << hs

    p4 = row[7].search('td')[0].search('font').text().strip()
    p4_p = row[7].search('td')[2].search('font').text().strip()
    p4_c = row[7].search('td')[3].search('font').text().strip()

    hs = Hash.new
    hs[:name] = p4
    hs[:price] = p4_p
    hs[:change] = p4_c
    arr << hs

    arr.each do |a|
      m = MarketPrice.where("item_id=?",a[:name]).take
      if m.blank?
        m = MarketPrice.new
      end
      m.item_id = a[:name]
      m.item_group = "Rubber"
      m.name = "#{a[:name]} Rs.#{a[:price]}(#{a[:change]})"
      m.save
    end
  end

  def self.arecanut(item_id,name)
    #item - 140 areca
    #item - 36 cashew
    #item - 37 coconut
    agent = Mechanize.new
    page = agent.get("http://krishimaratavahini.kar.nic.in/MainPage/DailyMrktPriceRep2.aspx?Rep=Com&CommCode=#{item_id}&VarCode=1&CommName=Arecanut%20/%20%E0%B2%85%E0%B2%A1%E0%B2%BF%E0%B2%95%E0%B3%86&VarName=Red%20/%20%E0%B2%95%E0%B3%86%E0%B2%82%E0%B2%AA%E0%B3%81")
    table = page.at("#_ctl0_content5_Table1")
    rows = table.search("tr")
    rows.each do |row|
      nm = (row.search('td')[0]).text().strip
      if (nm =~ /sulya/i) || (nm=~/puttur/i) || (nm=~/MANGALURU/i)
        bd = (row.search('td')[2]).text().strip
        pr = ((row.search('td')[6]).text().strip)
        m = MarketPrice.where("item_id=?","#{nm}_#{bd}").take
        if m.blank?
          m = MarketPrice.new
        end
        m.name = "#{bd} - Rs.#{pr}"
        m.item_id = "#{nm}_#{bd}"
        m.item_group= "#{name} #{nm.capitalize}"
        m.save
      end
    end
  end

  def self.market_strip
    txt = "<span style='color:#00ff00; margin-right:10px; margin-left:10px;'>Market Updates: #{Date.today}</span>"
    MarketPrice.order("created_at asc").each do |mk|
      txt = txt+"<span style='margin-left:10px; margin-right:10px;'><strong>#{mk.item_group} : #{mk.name}</strong></span>"
    end
    return txt
  end


end

require 'nokogiri'
require 'watir'

BRANDS = [
    "iwc",
    "rolex",
    "audemarspiguet",
    "breitling",
    "jaegerlecoultre",
    "omega",
    "panerai",
    "patekphilippe",
    "cartier",
    "sekio",
    "movado",
    "zenith"
]

browser = Watir::Browser.new(:chrome)

#loop through 5 pages of watch {brand}
BRANDS.each do |brand|

    urls = [
        "https://www.chrono24.com/#{brand}/index.htm",
        "https://www.chrono24.com/#{brand}/index-2.htm",
        "https://www.chrono24.com/#{brand}/index-3.htm",
        "https://www.chrono24.com/#{brand}/index-4.htm",
        "https://www.chrono24.com/#{brand}/index-5.htm"
    ]

    urls.each do |url|
        browser.goto(url)
        sleep 2
        15.times do |i|
            browser.execute_script("window.scrollBy(0, 500)")
            sleep 1
        end
        doc = Nokogiri::HTML.parse(browser.html)

        article_divs = doc.css(".article-item-container")
        article_divs.each do |article_div|
            image_div = article_div.at_css(".article-image-container .content img")
            price_text = nil
            if article_div.at_css(".article-price-container strong") != nil
                price_text = article_div.at_css(".article-price-container strong").text
            end

            next if !image_div || !price_text
            p "w"
            image_url = image_div['src']
            price = price_text.gsub(/[^0-9]/, "")

            puts image_url
    
            next if image_url.empty? || price.empty?
            
            p "y"
            File.open("data/#{brand}.txt", "a+") do |f|
                f.puts("#{image_url},#{price}")

            end
            p "x"
        end
    end  
end
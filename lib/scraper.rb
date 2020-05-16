require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    html = open(index_url)
    doc = Nokogiri::HTML.parse(html)
    students_listing = doc.css("div.roster-cards-container")
    students_listing.each do |student| 
      student_name = student.css('.student-name').text
      student_location = student.css('.student-location').text
      student_profile_link = student.css('.student.attr("href")').text
      students << {name: student_name, location: student_location, profile_url: student_profile_link}
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    students = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    links = profile_page.css(".social-icon-container").children.css("a").map { |x| x.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        students[:linkedin] = link
      elsif link.include?("github")
        students[:github] = link
      elsif link.include?("twitter")
        students[:twitter] = link
      else
        students[:blog] = link
      end
    end
    students[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    students[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

    students
  end

end

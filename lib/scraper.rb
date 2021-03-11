require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    page = Nokogiri::HTML(html)

    students = []

    page.css('div.student-card').each do |student|
      profile = {
        :name => student.css('h4.student-name').text,
        :location => student.css('p.student-location').text,
        :profile_url => student.css('a').attr('href').value
      }
      students.push(profile)
    end
    students
  end

  def self.scrape_profile_page(profile_url)

    page = Nokogiri::HTML(open(profile_url))

    student = {}

    social = page.css('div.social-icon-container')

    social.css('a').each do |network|
      link = network.attr('href')


      if link.include?("twitter")
        key = :twitter
      elsif link.include?("linkedin")
        key = :linkedin
      elsif link.include?("github")
        key = :github
      else
        key = :blog
      end

      student[key] = link



      # Code for more general scraping - used with commented out code in student.rb
      # if link[/.com\/.+/] && !link.include?("blog")
      #   if link["://www."]
      #     key = link.split(/www\./)[1].split(".com").first
      #   else
      #
      #     key = link.split(/\/{1,2}/)[1].split(".com").first.split(".").last #this b/c link in test page w/ 1 backslash instead of 2
      #   end
      #   student[key.to_sym] = link if valid_keys.include?(key)
      # else
      #   student[:blog] = link

    end

    # binding.pry
    student[:profile_quote] = page.css('div.profile-quote').text
    student[:bio] = page.css('div.description-holder p').text

    student
  end
end

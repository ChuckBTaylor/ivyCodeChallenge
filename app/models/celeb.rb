require 'rest-client'
require 'nokogiri'
require 'open-uri'

URL_BASE = "https://www.imdb.com"

class Celeb < ApplicationRecord

  def self.get_birthdays(birthday)
    return_obj = {people: []}
    url_string = "#{URL_BASE}/search/name?birth_monthday=#{birthday[:month]}-#{birthday[:date]}"

    doc = Nokogiri::HTML(open(url_string))

    actors = actors_from_doc(doc)

    next_page = has_next_page?(doc)

    if(birthday[:get_all])
      while(next_page) do

        actors.each do |actor|
          actor_object = actor_info(actor)
          return_obj[:people].push(actor_object)
        end

        next_page = has_next_page?(doc)

        if(next_page)
          next_page_url = "#{URL_BASE}#{doc.css('.lister-page-next.next-page').attr('href').text}"
          doc = Nokogiri::HTML(open(next_page_url))
          actors = actors_from_doc(doc)
        else
          next_page_url = nil
        end
      end

    else
      length = actors.length >= 10 ? 10 : actors.length

      counter = 0
      length.times do
        actor_object = actor_info(actors[counter])
        return_obj[:people].push(actor_object)
        counter += 1
      end

    end
    return_obj
  end

  def self.has_next_page?(doc)
    doc.css('.lister-page-next.next-page').length == 2 ? true : false
  end

  def self.actors_from_doc(doc)
    doc.css('.lister-item.mode-detail')
  end

  def self.actor_info(actor)
    {
      name: celeb_name(actor),
      photoUrl: photo_url(actor),
      profileUrl: profile_url(actor),
      mostKnownWork: most_known_work_info(actor)
    }
  end

  def self.photo_url(actor)
    actor.css('.lister-item-image').children.css('img').attr('src').text
  end

  def self.profile_url(actor)
    "#{URL_BASE}#{actor_anchor(actor).attr('href').text}"
  end

  def self.celeb_name(actor)
    actor_anchor(actor).text.strip
  end

  def self.actor_anchor(actor)
    actor.css('.lister-item-header').children.css('a')
  end

  def self.most_known_work_info(actor)
    work = actor.css('.text-muted.text-small').children.css('a')
    if work.length != 0
      work_url = most_known_work_url(work)
      work_info = get_work_info(work)
      {
        title: most_known_work_title(work),
        url: work_url,
        rating: work_rating(work_info),
        director: work_director(work_info)
      }
    else
      nil
    end
  end

  def self.most_known_work_title(work)
    work.text.strip
  end

  def self.most_known_work_url(work)
    "#{URL_BASE}#{work.attr('href').text}"
  end

  def self.get_work_info(work)
    Nokogiri::HTML(open(most_known_work_url(work)))
  end

  def self.work_rating(work)
    work.css('.ratingValue').text.strip.split('/')[0].to_f
  end

  def self.work_director(work)
    work.css('.credit_summary_item')[0].css('a').text.strip
  end

end

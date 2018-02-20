require 'rest-client'
require 'nokogiri'
require 'open-uri'

class Celeb < ApplicationRecord

  def self.get_birthdays(birthday)
    return_obj = {people: []}
    url_string = "https://www.imdb.com/search/name?birth_monthday=#{birthday[:month]}-#{birthday[:date]}"

    doc = Nokogiri::HTML(open(url_string))

    actors = doc.css('.lister-item.mode-detail')

    length = actors.length >= 10 ? 10 : actors.length

    counter = 0
    length.times do
      actor_object = actor_info(actors[counter])
      return_obj[:people].push(actor_object)
      counter += 1
    end
    return_obj
  end

  def self.actor_info(actor)
    {
      name: Celeb.celeb_name(actor),
      photoUrl: photo_url(actor),
      profileUrl: profile_url(actor),
      mostKnownWork: most_known_work_info(actor)
    }
  end

  def self.photo_url(actor)
    actor.css('.lister-item-image').children.css('img').attr('src').text
  end

  def self.profile_url(actor)
    "https://www.imdb.com#{actor_anchor(actor).attr('href').text}"
  end

  def self.celeb_name(actor)
    actor_anchor(actor).text.strip
  end

  def self.actor_anchor(actor)
    actor.css('.lister-item-header').children.css('a')
  end

  def self.most_known_work_info(actor)
    work = actor.css('.text-muted.text-small').children.css('a')
    work_info = get_work_info(work)
    {
      title: most_known_work_title(work),
      url: most_known_work_url(work),
      rating: work_rating(work_info),
      director: work_director(work_info)
    }
  end

  def self.most_known_work_title(work)
    work.text.strip
  end

  def self.most_known_work_url(work)
    "https://www.imdb.com#{work.attr('href').text}"
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

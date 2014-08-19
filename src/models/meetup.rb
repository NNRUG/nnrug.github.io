require 'ostruct'
require 'yaml'

class Talk < OpenStruct; end

class Meetup
  attr_reader :title, :date, :link, :talks

  def self.load
    @meetups ||= YAML.load_file('./src/config/meetups.yml').map { |m| new m }

  end

  def initialize(params)
    @title = params['title']
    @date = Date.parse(params['date'])
    @link = URI.parse(params['link'])
    @talks = params['talks'].map { |t| Talk.new t }
  end
end

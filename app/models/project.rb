# coding: utf-8
require "open-uri"
class Project < ActiveRecord::Base
  attr_accessible :description, :forks, :full_name, :homepage, :language, :name, :url, :watchers

  include Redis::Search

  redis_search_index(:title_field => :full_name,
                     :alias_field => :alias,
                     :prefix_index_enable => true,
                     :score_field => :rank,
                     :ext_fields => [:language,:url,:description, :watchers,:forks])


  def alias
    [self.name]
  end

  def rank
    self.forks + self.watchers
  end

  def self.fetch_from_github(full_name)
    full_name = full_name.gsub(/\s+/,"")
    repos_url = "https://api.github.com/repos/#{full_name}"
    begin
      doc = open(repos_url).read
    rescue => e
      logger.error("Github Repositiory fetch Error: #{e}")
      return false
    end

    json = JSON.parse(doc)
    project = Project.new
    project.name = json["name"]
    project.full_name = json["full_name"]
    project.description = json["description"]
    project.homepage = json["homepage"]
    project.language = json["language"]
    project.url = json["html_url"]
    project.forks = json["forks"]
    project.watchers = json["watchers"]
    project.save
    project
  end
end

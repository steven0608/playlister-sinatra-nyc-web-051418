class Artist < ActiveRecord::Base
  has_many :songs
  has_many :genres, through: :songs

  def slug
    self.name.gsub(" ","-")
    # binding.pry
  end

  def self.find_by_slug(slug)
    name = slug.split("-").map{|word| word.capitalize}.join(" ")
    Artist.find_by(name: name)
    # binding.pry
  end
  
  
  
end
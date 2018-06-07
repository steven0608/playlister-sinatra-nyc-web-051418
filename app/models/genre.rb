class Genre < ActiveRecord::Base
  has_many :artists, through: :songs
  has_many :song_genres
  has_many :songs, through: :song_genres

  def slug
    self.name.gsub(" ","-")
  end

  def self.find_by_slug(slug)
    name = slug.split("-").map{|word| word.capitalize}.join(" ")
    Genre.find_by(name: name)
    # binding.pry
  end

end
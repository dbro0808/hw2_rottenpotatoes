class Movie < ActiveRecord::Base
  @@ratings = ["G", "PG", "PG-13", "R"]
  def self.ratings_list
    return @@ratings
  end
end

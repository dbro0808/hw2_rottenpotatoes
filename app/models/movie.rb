class Movie < ActiveRecord::Base
  @@ratings = {"G" => "1", "PG" => "1", "PG-13" => "1", "R" => "1"}
  def self.ratings_list
    return @@ratings.keys
  end
  def self.ratings_hash
    return @@ratings
  end
end

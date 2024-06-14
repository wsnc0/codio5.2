# class Movie < ActiveRecord::Base
# end

# app/models/movie.rb

class Movie < ActiveRecord::Base
  # Define class methods here

  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  # Other methods of the Movie model
end

class Movie < ActiveRecord::Base
    def self.all_ratings
        return Movie.select(:rating).map(&:rating).uniq
    end
    
    def self.with_ratings(ratings)
        return Movie.where(rating: ratings)
    end
end

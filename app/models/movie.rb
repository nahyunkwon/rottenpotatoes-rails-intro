class Movie < ActiveRecord::Base
    def self.all_ratings
        select(:rating).map(&:rating).uniq
    end
    
    def self.with_ratings (ratings)
        Movie.where(rating: ratings)
        
        if ratings.length() == 0
            Movie.all
        end
    end
end

class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    flash.keep
    @all_ratings = Movie.all_ratings
    
    logger.info params[:ratings]
    
    # have only selected ratings
    if params[:ratings].nil?
      if session[:ratings].nil?
        @selected_ratings = @all_ratings
      else
        @selected_ratings = session[:ratings].keys
      end
    else # ratings
      @selected_ratings = params[:ratings].keys
    end
    
    # sort by title / release date
    if params[:sort_key] == 'title'
      @movies = Movie.order('title').with_ratings(@selected_ratings)
      #@title_header = "hilite"
    elsif params[:sort_key] == 'release_date'
      @movies = Movie.order('release_date').with_ratings(@selected_ratings)
      #@release_date_header = "hilite"
    else # nil
      if session[:sort_key].nil?
        @movies = Movie.with_ratings(@selected_ratings)
        #@title_header = ""
        #@release_date_header = ""
      else
        @movies = Movie.order(session[:sort_key]).with_ratings(@selected_ratings)
      end
      
    end
    
    
    if !params[:sort_key].nil?
      session[:sort_key] = params[:sort_key]
    end
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    end
    
    if params[:sort_key] == 'title' || session[:sort_key] == 'title'
      @title_header = "hilite"
    elsif params[:sort_key] == 'release_date' || session[:sort_key] == 'release_date'
      @release_date_header = "hilite"
    end
        
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort_key, :selected_ratings)
    @sort_key = ''
  end

    
end

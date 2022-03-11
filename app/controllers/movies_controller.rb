class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    flash.keep
    
    @all_ratings = Movie.all_ratings
    
    session[:ratings] = params[:ratings]
    session[:sort_key] = params[:sort_key]
    logger.info session[:ratings]
    logger.info session[:sort_key]
    
    #redirect_to 
    
    # sort by title / release date
    if params[:sort_key] == 'title' or session[:sort_key] == 'title'
      @movies = Movie.order('title').all
      @title_header = "hilite"
      flash[:sort_key] = 'title'
      flash[:title_header] = "hilite"
      redirect_to movies_path(@movies)
    elsif params[:sort_key] == 'release_date'
      @movies = Movie.order('release_date').all
      @release_date_header = "hilite"
    else
      @movies = Movie.all
      @title_header = ""
      @release_date_header = ""
    end
    
    #logger.info params[:ratings]
    
    # have only selected ratings
    if params[:ratings].nil?
      @movies = Movie.all
    else
      #logger.info params[:ratings].keys
      @movies = Movie.with_ratings(params[:ratings].keys)
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
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort_key)
    @sort_key = ''
  end

    
end

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
      @selected_ratings = @all_ratings
    else # ratings
      #logger.info params[:ratings].keys
      @selected_ratings = params[:ratings].keys
    end
    
    # sort by title / release date
    if params[:sort_key] == 'title'
      @movies = Movie.order('title').with_ratings(@selected_ratings)
      @title_header = "hilite"
    elsif params[:sort_key] == 'release_date'
      @movies = Movie.order('release_date').with_ratings(@selected_ratings)
      @release_date_header = "hilite"
    else
      @movies = Movie.with_ratings(@selected_ratings)
      @title_header = ""
      @release_date_header = ""
    end
    
    if session[:sort_key].present? || session[:ratings].present?
      redirect_to movies_path(:ratings => session[:ratings], :sort_key => session[:sort_key])
    
    
    session[:sort_key] = params[:sort_key]
    session[:ratings] = params[:ratings]
        
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

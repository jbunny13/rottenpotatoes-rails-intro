class MoviesController < ApplicationController

  def show
    id                  = params[:id] # retrieve movie ID from URI route
    @movie              = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort_by            = params[:sort_by]
    @selected_ratings   = params[:ratings] ? params[:ratings].keys : []
    query_ratings       = @selected_ratings.present? ? @selected_ratings : Movie::RATINGS
    @movies             = Movie.where(rating: query_ratings).order(params[:sort_by])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie              = Movie.create!(movie_params)
    flash[:notice]      = "#{@movie.title} was successfully created."
    
    redirect_to movies_path

    # @movie = Movie.new(movie_params)
    # if @movie.save
    #   flash[:notice] "success!"
    # else
    #   flash[:error] = @movie.errors
    # end
  end

  def edit
    @movie              = Movie.find params[:id]
  end

  def update
    @movie              = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice]      = "#{@movie.title} was successfully updated."
    
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie              = Movie.find(params[:id])
    @movie.destroy
    flash[:notice]      = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

class MoviesController < ApplicationController

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def index
    session[:sort_by] = params[:sort_by] if params[:sort_by].present?
    # session[:ratings] = params[:ratings] if params[:commit] == 'Refresh'
    session[:ratings] = params[:ratings] if params[:ratings].present?
    @selected_ratings = session[:ratings] ? session[:ratings].keys : Movie::RATINGS
    query_ratings = @selected_ratings.present? ? @selected_ratings : Movie::RATINGS
    @movies = Movie.where(rating: query_ratings).order(session[:sort_by])
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    
    redirect_to movies_path

    # @movie = Movie.new(movie_params)
    # if @movie.save
    #   flash[:notice] "success!"
    # else
    #   flash[:error] = @movie.errors
    # end
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

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

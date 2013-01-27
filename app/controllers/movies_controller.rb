class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @selected_ratings = (params[:ratings].present? ? params[:ratings] : Movie.ratings_hash)
    #@ratings = @selected_ratings.keys
    @all_ratings = Movie.ratings_list

    if not(params[:ratings].present?)
      if not(session[:ratings].present?)
        flash.keep
        redirect_to movies_path(params.merge(:ratings => Movie.ratings_hash)) and return
      end
      if not(session[:sorted].present?)
        flash.keep
        redirect_to movies_path(:ratings => session[:ratings]) and return
      else
        flash.keep
        redirect_to movies_path(:ratings => session[:ratings], :sorted => session[:sorted]) and return
      end
    else
      if not(params[:sorted].present?)
        if session[:sorted].present?
          flash.keep
          redirect_to movies_path(params.merge(:sorted => session[:sorted])) and return
        end
      end
    end
    #@selected_ratings = params[:ratings]
    @ratings = @selected_ratings.keys
    session[:ratings] = params[:ratings]

    if not(params[:sorted].present?)
      @movies = Movie.where(:rating => @ratings)
      @title_sort = ""
      @date_sort = ""
    elsif params[:sorted] == "title"
      session[:sorted] = "title"
      @movies = Movie.where(:rating => @ratings).order("title ASC")
      @title_sort = "hilite"
      @date_sort = ""
    elsif params[:sorted] == "date"
      session[:sorted] = "date"
      @movies = Movie.where(:rating => @ratings).order("release_date ASC")
      @title_sort = ""
      @date_sort = "hilite"
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

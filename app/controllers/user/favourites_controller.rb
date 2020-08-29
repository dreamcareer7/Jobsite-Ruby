class User::FavouritesController < User::BaseController

  def index
    @listings = []
    @businesses = Kaminari.paginate_array(Business.where(id: current_user.favourites.pluck(:business_id))).page(params[:page]).per(6)
  end

  def create
    @favourite = current_user.favourites.create(favourite_params)

    if @favourite.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @favourite = Favourite.find(params[:id])

    @favourite.destroy
    redirect_back(fallback_location: user_favourites_path)
    flash[:notice] = "Business removed from favourites."
  end

  def toggle
    favourite = Favourite.where(user_id: current_user.id, business_id: params[:business_id]).first

    if favourite.present?
      favourite.destroy
    else
      Favourite.create(user_id: current_user.id, business_id: params[:business_id])
    end
  end

  private

  def favourite_params
    params.require(:favourite).permit(:business_id, :user_id)
  end

end

class User::FollowsController < User::BaseController

  def index
    @listings = []
    @categories = Kaminari.paginate_array(current_user.followed_categories).page(params[:page]).per(6)
    @sub_categories = Kaminari.paginate_array(current_user.followed_sub_categories).page(params[:page]).per(6)
    @services = Kaminari.paginate_array(current_user.followed_services).page(params[:page]).per(6)
    @businesses = Kaminari.paginate_array(current_user.followed_businesses).page(params[:page]).per(6)
  end

  def destroy
    @follow = Follow.find(params[:id])

    @follow.destroy

    redirect_back(fallback_location: user_follows_path)
    flash[:notice] = "Following list updated."
  end

  def toggle
    @follow = current_user.follows.where(follow_target_type: params[:target_class], follow_target_id: params[:target_id]).first

    if @follow.present?
      @follow.destroy

      if request.path.starts_with?("/user")
        redirect_back(fallback_location: user_follows_path)
        flash[:notice] = "Following list updated."
      end

    else
      @follow = current_user.follows.create(follow_target_type: params[:target_class], follow_target_id: params[:target_id])

    end
  end

  private

  def follow_params
    params.require(:follow).permit(:user_id, :follow_target)
  end

end

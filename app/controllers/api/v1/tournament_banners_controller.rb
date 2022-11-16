class Api::V1::TournamentBannersController < Api::V1::ApiController
  before_action :authorize_request
  before_action :find_tournament
  before_action :check_user_is_in_tournament, only: [:enroll_in_tournament]

  def index
    render json: { tournament: @tournament,
                   tournament_banner_image: @tournament.tournament_banner_photo.attached? ? @tournament.tournament_banner_photo.blob.url : '',
                   tournament_users_count: @tournament.tournament_users.count,
                   tournament_posts_count: @tournament.posts.count
    }, status: :ok
  end

  def tournament_posts
    if @tournament.present?
    else
      render json: { message: "No posts for this tournament yet" }, status: :not_found
    end
  end

  def enroll_in_tournament
    @tournament_user = @tournament.tournament_users.new(tournament_entry_params)
    if @tournament_user.save
      render json: { message: "#{@current_user.username} has enrolled in #{@tournament.title}" }
    else
      render_error_messages(@tournament_user)
    end
  end

  def create
    @tournament_post = Post.new(post_params)
    if @tournament.tournament_users.find_by(user_id: @current_user.id).present?
      if @tournament_post.save
        render json: { tournament: @tournament_post,
                       tournament_banner_image: @tournament_post.post_image.attached? ? @tournament_post.post_image.blob.url : '',
        }, status: :ok
      else
        render_error_messages(@tournament_post)
      end
    else
      render json: { message: "User is not enrolled in tournament" }, status: :not_found
    end
  end

  def like_dislike_a_tournament_post
    if @tournament.posts.find_by(id: params[:post_id]).present?
      if @tournament.tournament_users.find_by(user_id: @current_user.id).present?
        response = TournamentLikeService.new(params[:post_id], @current_user.id).create_for_tournament
        render json: { like: response[0], message: response[1] }, status: :ok
      else
        render json: { message: "User is not enrolled in this tournament" }, status: :not_found
      end
    else
      render json: { message: "Post is not in this tournament" }, status: :not_found
    end
  end

  private

  def find_tournament
    unless (@tournament = TournamentBanner.find_by(enable: true))
      return render json: { message: 'No Tournament is played at the moment' }, status: :not_found
    end
  end

  #
  def post_params
    params.permit(:id, :description, :post_image, :tags, :created_at, :updated_at).merge(user_id: @current_user.id, tournament_meme: true, tournament_banner_id: @tournament.id)
  end

  def tournament_entry_params
    params.permit(:id).merge(user_id: @current_user.id, tournament_banner_id: @tournament.id)
  end

  def check_user_is_in_tournament
    if (@tournament.tournament_users.find_by(user_id: @current_user.id).present?)
      return render json: { message: 'Already enrolled' }, status: :not_found
    end
  end
end

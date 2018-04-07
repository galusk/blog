class ArticlesController < ApplicationController
  #http_basic_authenticate_with name: 'admin', password: 'secret', except: [:index, :show]
  before_action  :provide_article, only: [:show, :destroy, :edit, :update, :add_like]

  def index
    @articles = Article.all
                      .paginate(:page => params[:page], :per_page => 20)
                      .includes(:user)
    if params[:q].present?
      @articles = @articles.where("? = any(tags)", params[:q])

    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to articles_path(@article), notice: 'Pomyslnie utworzono artykul'
    else
      render 'new'
    end
  end

  def show
    @comment = Comment.new(commenter: session[:commenter])
    @user_like = @article.likes.find_by(user: current_user)
  end

  def destroy
    @article.destroy
    ArticleMailer.article_destroy_info(@article).deliver
    redirect_to articles_path
  end

  def edit
    if @article.user =! current_user
      redirect_to.articles_path
    end
  end

  def update
    if @article.update(article_params)
      redirect_to articles_path, notice: 'No acces'
    else
      render 'edit'
    end
  end

  def add_like
    @article.likes.create(user: current_user)
    redirect_to article_path(@article)
  end

  private

  def article_params
    params.require(:article).permit(:title, :text, :tags, :image)
          .merge(user: current_user)
  end

  def provide_article
    @article = Article.find(params[:id])
  end
end

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update]
  before_action :find_project

  def show
  end

  def new
    @comment = @project.comments.new
  end

  def edit
  end

  def create
    @comment = @project.comments.new(
      comment_params.merge(user: current_user)
    )

    respond_to do |format|
      if @comment.valid? && @comment.save!
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.valid? && @comment.update!(comment_params)
        format.html { redirect_to @project, notice: "Comment was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body)
    end

    def find_project
      @project = Project.find_by(id: params[:project_id].to_i)
    end
end

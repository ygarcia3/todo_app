class TodosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_todo, only: %i[ show edit update destroy ]

  # GET /todos
  def index
    @categories = current_user.categories
    @todos = current_user.todos
  
    @todos = @todos.where("title ILIKE ?", "%#{params[:q]}%") if params[:q].present?
    @todos = @todos.where(category_id: params[:category_id]) if params[:category_id].present?
  
    if params[:status].present?
      case params[:status]
      when "completed"
        @todos = @todos.where(completed: true)
      when "pending"
        @todos = @todos.where(completed: false)
      end
    end
  end
  
  


  # GET /todos/completed
  def completed
    @todos = current_user.todos.where(completed: true)
  end

  def show
  end

  def new
    @todo = Todo.new
  end

  def edit
  end

  def create
    @todo = current_user.todos.build(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to @todo, notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to @todo, notice: "Todo was successfully updated." }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @todo.destroy!
    respond_to do |format|
      format.html { redirect_to todos_path, status: :see_other, notice: "Todo was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def toggle_complete
    @todo = current_user.todos.find(params[:id])
    @todo.update(completed: !@todo.completed)
  
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to todos_path, notice: "Todo marked as #{@todo.completed ? 'complete' : 'pending'}." }
    end
  end
  
  private

    def set_todo
      @todo = current_user.todos.find(params[:id])
    end

    def todo_params
      params.require(:todo).permit(:title, :description, :completed, :priority, :category_id, :due_date)
    end
    
end

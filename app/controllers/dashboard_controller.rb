class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @todos = current_user.todos
    @total_todos = @todos.count
    @completed_todos = @todos.where(completed: true).count
    @incomplete_todos = @todos.where(completed: false).count
    @overdue_todos = @todos.where("due_date < ?", Date.today).where(completed: false).count

    @upcoming_todos = @todos.where(completed: false).where("due_date <= ?", 3.days.from_now)

    @categories = current_user.categories.includes(:todos)

    @completion_rate = @total_todos.zero? ? 0 : ((@completed_todos.to_f / @total_todos) * 100).round
  end
end

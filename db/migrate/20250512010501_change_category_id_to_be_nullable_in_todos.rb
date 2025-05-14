class ChangeCategoryIdToBeNullableInTodos < ActiveRecord::Migration[7.1]
  def change
    change_column_null :todos, :category_id, true
  end
end


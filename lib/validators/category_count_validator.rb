class CategoryCountValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:base] << "No more than 3 categories allowed" unless record.category_ids.count <= 3
    record.errors[:base] << "At least one category required" if record.category_ids.count == 0
  end
end
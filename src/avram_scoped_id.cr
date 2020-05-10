require "avram"

# Set an scoped id based on the query.
module AvramScopedId
  VERSION = "0.1.0"

  extend self

  def set(column : Avram::Attribute(Int64 | Nil),
          query : Avram::Queryable) : Nil
    set(column, query)
  end

  def set(column : Avram::Attribute(Int64 | Nil),
          query : Avram::Queryable) : Nil
    return unless column.value.nil?
    id = get_next_scoped_id(query, column)
    column.value = id.to_i64
  end

  private def get_next_scoped_id(query, column)
    scope = query.scoped_id.select_max
    current_max_scoped_id = scope || 0
    current_max_scoped_id + 1
  end
end

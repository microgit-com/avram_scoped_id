require "./database"

class User < Avram::Model
  def self.database : AppDatabase.class
    AppDatabase
  end

  skip_default_columns
  skip_schema_enforcer

  table do
    primary_key id : Int64
    column scoped_id : Int64?
    column first_name : String?
    column last_name : String?
    column job_title : String?
    belongs_to team : Team
  end
end

class UserQuery < User::BaseQuery
end

class UserBox < Avram::Box
end

require "./database"

class Team < Avram::Model
  def self.database : AppDatabase.class
    AppDatabase
  end

  skip_default_columns

  table do
    primary_key id : Int64
    column name : String?
    has_many users : User
  end
end

class TeamQuery < Team::BaseQuery
end

class TeamBox < Avram::Box
end

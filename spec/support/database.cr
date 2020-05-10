class AppDatabase < Avram::Database
end

AppDatabase.configure do |settings|
  settings.url = ENV["DATABASE_URL"]? || Avram::PostgresURL.build(
    database: "avram_scoped_id",
    hostname: "localhost",
    username: "postgres",
    password: "postgres"
  )
end

Avram.configure do |settings|
  settings.database_to_migrate = AppDatabase
end

class CreateTeams::V0 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(Team) do
      primary_key id : Int64
      add name : String?
    end
  end

  def rollback
    drop table_for(Team)
  end
end

class CreateUsers::V1 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(User) do
      primary_key id : Int64
      add scoped_id : Int64?
      add job_title : String?
      add last_name : String?
      add first_name : String?
      add_belongs_to team : Team, on_delete: :cascade
    end
  end

  def rollback
    drop table_for(User)
  end
end

Db::Create.new(quiet: true).call
Db::Migrate.new(quiet: true).call

Spec.before_each do
  AppDatabase.truncate
end

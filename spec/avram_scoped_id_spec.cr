require "./spec_helper"

describe AvramScopedId do
  # TODO: Write tests
  describe ".set" do
    it "don't change scope if already set" do
      op = build_op(scoped_id: 2.to_i64)
      scoped(op.scoped_id)
      op.scoped_id.value.should eq(2)
    end

    it "set an scope" do
      op = build_op
      scoped(op.scoped_id)
      op.scoped_id.value.should eq(1)
    end

    it "set a real scope" do
      team = build_team(name: "test")
      op = create_user(team.id, 1.to_i64)
      op2 = build_op(team_id: team.id)

      team2 = build_team(name: "test2")
      op3 = create_user(team2.id, 1.to_i64)
      op4 = build_op(team_id: team2.id)

      scoped(op.scoped_id, query: UserQuery.new.team_id(team.id))
      scoped(op2.scoped_id, query: UserQuery.new.team_id(team.id))
      scoped(op3.scoped_id, query: UserQuery.new.team_id(team2.id))
      scoped(op4.scoped_id, query: UserQuery.new.team_id(team2.id))

      op.scoped_id.value.should eq(1)
      op2.scoped_id.value.should eq(2)
      op3.scoped_id.value.should eq(1)
      op4.scoped_id.value.should eq(2)
    end
  end
end

private def scoped(scoped_id : Avram::Attribute(Int64 | Nil), query = UserQuery.new)
  AvramScopedId.set(scoped_id, query)
end

private def build_op(**named_args)
  User::SaveOperation.new(**named_args)
end

private def create_user(team_id, scope_id)
  user = UserBox.create do |box|
    box.team_id(team_id)
    box.scoped_id(scope_id)
  end
  User::SaveOperation.new(user)
end

private def build_team(name)
  TeamBox.create do |box|
    box.name(name)
  end
end

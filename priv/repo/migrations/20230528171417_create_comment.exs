defmodule Discuss.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comment) do
      add :content, :string
      add :user_id, references(:user, on_delete: :nothing)
      add :topic_id, references(:topic, on_delete: :nothing)

      timestamps()
    end

    create index(:comment, [:user_id])
    create index(:comment, [:topic_id])
  end
end

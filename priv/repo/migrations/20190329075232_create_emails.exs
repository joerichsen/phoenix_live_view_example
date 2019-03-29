defmodule Demo.Repo.Migrations.CreateEmails do
  use Ecto.Migration

  def change do
    create table(:emails) do
      add(:from, :string)
      add(:subject, :string)
      timestamps()
    end
  end
end


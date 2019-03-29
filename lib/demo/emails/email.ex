defmodule Demo.Emails.Email do
  use Ecto.Schema

  schema "emails" do
    field :from, :string
    field :subject, :string

    timestamps()
  end
end

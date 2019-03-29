defmodule Demo.Emails do
  import Ecto.Query, warn: false
  alias Demo.Repo
  alias Demo.Emails.Email

  def inbox do
    Repo.all(from e in Email, order_by: [asc: e.id])
  end

  def delete(%Email{} = email) do
    email |> Repo.delete()
  end

end

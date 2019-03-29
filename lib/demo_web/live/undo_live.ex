defmodule DemoWeb.UndoLive do
  use Phoenix.LiveView
  alias Demo.Emails

  def render(assigns) do
    ~L"""
    <div class="actions">
      <h3>Inbox</h3>
      <%= if @seconds_to_undo > 0 do %>
      <a phx-click="undo" class="undo-button" href="#">Undo <%= @seconds_to_undo %>s</a>
      <% end %>
    </div>

    <table>
      <thead>
        <tr>
          <th>From</th>
          <th>Subject</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <%= for email <- @emails do %>
          <tr>
            <td><%= email.from %></td>
            <td><%= email.subject %></td>
            <td phx-click="delete" phx-value="<%= email.id %>">🗑</td>
          </tr>
        <% end %>
      </tbody>
    </table>
    <style>
      .undo-button { background-color: #fffbcc; padding: 10px; color: black; border-radius: 5px; border: 1px solid grey; display: block; margin-bottom: 5px; width: 85px; float: right; }
      .actions { height: 50px; }
      .actions h3 { float: left; }
    </style>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, emails: Emails.inbox(), emails_to_delete: [], seconds_to_undo: 0)}
  end

  def handle_event("delete", id, %{assigns: %{seconds_to_undo: 0}} = socket) do
    # No countdown is running. Start a new countdown
    Process.send_after(self(), :countdown, 1000)
    mark_email_for_deletion_and_reset_countdown(id, socket)
  end

  def handle_event("delete", id, socket) do
    # A countdown is already running
    mark_email_for_deletion_and_reset_countdown(id, socket)
  end

  def handle_event("undo", _, socket) do
    {:noreply, assign(socket, emails: Emails.inbox(), emails_to_delete: [], seconds_to_undo: 0)}
  end

  def handle_info(:countdown, %{assigns: %{seconds_to_undo: 0, emails_to_delete: emails_to_delete}} = socket) do
    # Countdown complete. Delete the emails
    emails_to_delete |> Enum.each(&Emails.delete/1)
    {:noreply, assign(socket, emails_to_delete: [])}
  end

  def handle_info(:countdown, %{assigns: %{seconds_to_undo: seconds_to_undo}} = socket) do
    # Just decrease the counter
    Process.send_after(self(), :countdown, 1000)
    {:noreply, assign(socket, seconds_to_undo: seconds_to_undo - 1)}
  end

  defp mark_email_for_deletion_and_reset_countdown(id, %{assigns: %{emails: emails, emails_to_delete: emails_to_delete}} = socket) do
    email_to_delete = emails |> Enum.find(&(&1.id == String.to_integer(id)))
    {:noreply, assign(socket, emails: emails |> List.delete(email_to_delete), emails_to_delete: [email_to_delete | emails_to_delete], seconds_to_undo: 3)}
  end
end

defmodule Katty.Users.UserNotifier do
  @moduledoc """
  This module contains notifications aimed towards the user.
  """
  use Phoenix.Swoosh, view: KattyWeb.EmailView, layout: {KattyWeb.LayoutView, :email}

  import Swoosh.Email
  import Katty.Mailer, only: [base_email: 0]

  alias Katty.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      base_email()
      |> to(recipient)
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm user.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """

    ==============================
      |\__/,|   (`\
      |_ _  |.--.) )
      ( T   )     /
     (((^_(((/(((_>
    Hello #{user.username},
    To confirm, just click below:

    #{url}

    If you didn't create an user with us, please ignore this.
    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """

    ==============================
      |\__/,|   (`\
      |_ _  |.--.) )
      ( T   )     /
     (((^_(((/(((_>

    Hi #{user.username},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================
      |\__/,|   (`\
      |_ _  |.--.) )
      ( T   )     /
     (((^_(((/(((_>

    Hi #{user.username},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end

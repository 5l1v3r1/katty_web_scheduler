defmodule KattyWeb.UserRegistrationController do
  use KattyWeb, :controller

  alias Katty.Users
  alias Katty.Users.User
  alias KattyWeb.UserAuth

  plug :validate_captcha, [] when action == :create


  def new(conn, _params) do
    changeset = Users.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def validate_captcha(conn, params ) do
    case Recaptcha.verify(conn.params["g-recaptcha-response"]) do
      {:ok, response} -> conn
      {:error, [:invalid_input_response]} ->
        conn
        |> put_flash(:error, "Error: Wrong Captcha")
        |> redirect(to: "/users/register")
        |> halt()
          end
  end


  def create(conn, %{"user" => user_params}) do
    case Users.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Users.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end

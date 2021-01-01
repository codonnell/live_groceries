defmodule LiveGroceries.Accounts.Email do
  import Bamboo.Email

  @doc """
  Email with instructions to confirm account.
  """
  def confirmation_instructions(user, url) do
    base_email()
    |> to(user.email)
    |> subject("Email confirmation")
    |> text_body("""

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
    |> html_body("""
    <p>Hi #{user.email},</p>
    <p>You can confirm your account by clicking <a href="#{url}">here</a> or visiting the URL below:</p>
    <p>#{url}</p>
    <p>If you didn't create an account with us, please ignore this.</p>
    """)
  end

  @doc """
  Email with instructions to reset a user password.
  """
  def reset_password_instructions(user, url) do
    base_email()
    |> to(user.email)
    |> subject("Reset password")
    |> text_body("""

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
    |> html_body("""
    <p>Hi #{user.email},</p>
    <p>You can reset your password by clicking <a href="#{url}">here</a> or visiting the URL below:</p>
    <p>#{url}</p>
    <p>If you didn't request this change, please ignore this.</p>
    """)
  end

  @doc """
  Email with instructions to update a user email.
  """
  def update_email_instructions(user, url) do
    base_email()
    |> to(user.email)
    |> subject("Update email")
    |> text_body("""

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
    |> html_body("""
    <p>Hi #{user.email}</p>
    <p>You can change your email by clicking <a href="#{url}">here</a> or visiting the URL below:</p>
    <p>#{url}</p>
    <p> If you didn't request this change, please ignore this.</p>
    """)
  end

  defp base_email() do
    new_email(from: "support@categorically.rocks")
  end
end

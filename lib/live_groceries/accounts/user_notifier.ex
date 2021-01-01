defmodule LiveGroceries.Accounts.UserNotifier do
  alias LiveGroceries.Accounts.Email
  alias LiveGroceries.Mailer

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    Mailer.deliver_later(Email.confirmation_instructions(user, url))
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    Mailer.deliver_later(Email.reset_password_instructions(user, url))
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    Mailer.deliver_later(Email.update_email_instructions(user, url))
  end
end

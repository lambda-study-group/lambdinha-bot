defmodule App.Commands do
  use App.Router
  use App.Commander
  use App.Tools

  alias App.Commands.Outside

  command "welcome" do
    Logger.log :info, "Command /welcome"
    send_message "Seja bem vindo ao Lambda Study Group! Leia as regras do grupo no pinado e visite nosso GitHub: https://github.com/lambda-study-group"
  end

  command "monads" do
    Logger.log :info, "Command /monads"
    send_message "Monads are just monoids in the category of endofunctors."
  end

  command ["desafios", "desafio", "challenges", "challenge"] do
    Logger.log :info, "Command /desafios | /desafio | /challenges | /challenge"
    App.Tools.get_args(update.message.text)
    |> App.Tools.get_challenges
    |> send_message
  end

  command "ranking" do
    Logger.log :info, "Command /ranking"
    App.Tools.get_args(update.message.text)
    |> App.Tools.get_ranking
    |> send_message
  end

  command "joke" do
    Logger.log :info, "Command /joke"
    App.Tools.get_args(update.message.text)
    |> App.Tools.get_joke
    |> send_message
  end

  command "help" do
    Logger.log :info, "Command /help"
    send_message "Lista de comandos: /welcome, /monads, /ranking, /desafios, /help, /joke"
  end

  command "xkcd" do
    Logger.log :info, "Command /xkcd"
    App.Tools.get_args(update.message.text)
    |> App.Tools.get_xkcd
    |> send_message
  end

  command "kick" do

    # Validate if Chat Type 'private', kick not available.
    if update.message.chat.type == "private" do
      Logger.log :error, "Command cannot be run in private chats"
      send_message "Cannot run /kick in private chats. Who you kinkin'?"
      :error
    else

      # Get user details to get Bot id
      {:ok, %Nadia.Model.User{id: my_id}} = get_me()
      # Get Chat Member details for this chat to get Bot permissions
      {:ok, %Nadia.Model.ChatMember{status: my_status}} = get_chat_member(my_id)

      # If insufficient permission, send error to Chat Group.
      # Else trigger kick user.
      if !(Enum.member? ["administrator", "creator"], my_status) do
        send_message "I do not have enough permission to /kick a user"
      else
        Enum.map(
          App.Tools.get_mentioned_users(update.message.entities),
          fn user_id ->
            case (kick_chat_member user_id) do
              {:error, error} ->
                Logger.log :error, error.reason
                send_message "An error occurred while kicking the user"
              _ ->
                Logger.log :info, "Kicked User"
            end
          end
        )
      end
    end
  end

  # just avoiding errors when no command is found
  message do
  end
end

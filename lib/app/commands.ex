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

  # just avoiding errors when no command is found
  message do
  end
end

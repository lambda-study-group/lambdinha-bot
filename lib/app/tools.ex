defmodule App.Tools do
  require Logger 

  defmacro __using__(_opts) do
    quote do

    end
  end
  
  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_response({:ok, %{status_code: _, body: _body}}) do
    {:ok, "Error"}
  end

  def extract_challenges(map) do
    {:ok, body} = map
    Enum.reduce body, [], fn (item, res) -> 
      res ++ ['#{item["name"]} - soluções: #{item["solutions"]} - #{item["link"]} \n']
    end
  end

  def extract_ranking(map) do
    {:ok, body} = map
    Enum.reduce body, [], fn (item, res) -> 
      res ++ ['#{item["ranking"]} - #{item["user"]} - #{item["pontuation"]} \n']
    end
  end

  def extract_joke(map) do
    {:ok, body} = map
    Enum.random body
  end

  def get_ranking do
    HTTPoison.get("https://raw.githubusercontent.com/lambda-study-group/desafios/master/ranking.json")
    |> handle_response
    |> extract_ranking
  end

  def get_challenges do
    HTTPoison.get("https://raw.githubusercontent.com/lambda-study-group/desafios/master/challenges.json")
    |> handle_response
    |> extract_challenges
  end

  def get_joke do
    HTTPoison.get("https://raw.githubusercontent.com/lambda-study-group/functional-jokes/master/jokes.json")
    |> handle_response
    |> extract_joke
  end
end

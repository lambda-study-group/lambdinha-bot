defmodule App.Tools do
  require Logger 

  defmacro __using__(_opts) do
    quote do

    end
  end
  
  # returns array of args as
  # "/command 1 2 3" -> "1 2 3"
  def get_args(text) do
    [_c | args] = String.split(text, " ")
    Enum.join(args, " ")
  end

  # returns only the first digit as an integer
  def digit_to_int(digit) do
    {number, _rest} = Integer.parse(digit)
    number
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_response({:ok, %{status_code: _, body: _body}}) do
    {:ok, "Error"}
  end


  # Challenge extraction

  def extract_challenges(map, _number = "") do
    {:ok, body} = map
    Enum.reduce body, [], fn (item, res) -> 
      res ++ ['#{item["name"]} - soluções: #{item["solutions"]} - #{item["link"]} \n']
    end
  end

  def extract_challenges(map, number) do
    {:ok, body} = map
    item = Enum.at body, digit_to_int number
    '#{item["name"]} - soluções: #{item["solutions"]} - #{item["link"]} \n'
  end

  # Ranking extraction 

  def extract_ranking(map, _top = "") do
    {:ok, body} = map
    Enum.reduce body, [], fn (item, res) -> 
      res ++ ['#{item["ranking"]} - #{item["user"]} - #{item["pontuation"]} \n']
    end
  end

  def extract_ranking(map, top) do
    {:ok, body} = map
      Enum.reduce Enum.slice(body, 0, digit_to_int top), [], fn (item, res) -> 
      res ++ ['#{item["ranking"]} - #{item["user"]} - #{item["pontuation"]} \n']
    end
  end

  # Joke extraction 

  def extract_joke(map, _number="") do
    {:ok, body} = map
    item = Enum.random body
    '#{item["joke"]}'
  end

  def extract_joke(map, number) do
    {:ok, body} = map
    item = Enum.at(body, digit_to_int number)
    '#{item["joke"]}'
  end
  

  # Command functions

  def get_ranking(top \\ "") do
    HTTPoison.get("https://raw.githubusercontent.com/lambda-study-group/desafios/master/ranking.json")
    |> handle_response
    |> extract_ranking(top)
  end

  def get_challenges(number \\ "") do
    HTTPoison.get("https://raw.githubusercontent.com/lambda-study-group/desafios/master/challenges.json")
    |> handle_response
    |> extract_challenges(number)
  end

  def get_joke(number \\ "") do
    HTTPoison.get("https://raw.githubusercontent.com/lambda-study-group/lambdinha-bot/master/jokes.json")
    |> handle_response
    |> extract_joke(number)
  end
end

defmodule App.Tools do
  require Logger

  defmacro __using__(_opts) do
    quote do

    end
  end

  @doc """
  returns array of args as
  "/command 1 2 3" -> "1 2 3"
  """
  def get_args(text) do
    [_c | args] = String.split(text, " ")
    Enum.join(args, " ")
  end

  @doc """
  ## Description
    Takes entities in message body as argument,
    and returns a list of user_id that have been mentioned in message
  ## Example
    /kick @User_1 @User_2 -> 184564595 284564595
  """
  def get_mentioned_users(entities) do
    Enum.filter(
      entities,
      fn (entity) ->
        entity.type == "text_mention"
      end
    )
    |> Enum.map(fn (entity) -> entity.user.id end)
  end

  # returns only the first digits as an integer
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


  # XKCD extraction

  def extract_xkcd(map) do
    {:ok, body} = map
    body["img"]
  end

  def random_xkcd_number(map) do
    {:ok, body} = map
    n = body["num"]
    Enum.random(1..n)
  end


  # Joke extraction

  def extract_joke(map, _number = "") do
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

  def get_xkcd(_number = "") do
    HTTPoison.get("https://xkcd.com/info.0.json")
    |> handle_response
    |> random_xkcd_number
    |> get_xkcd
  end

  def get_xkcd(number) do
    HTTPoison.get("https://xkcd.com/#{number}/info.0.json")
    |> handle_response
    |> extract_xkcd
  end

end

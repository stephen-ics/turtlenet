defmodule Server do
  use Application

  def start(_type, _args) do
    Supervisor.start_link([{Task, fn -> Server.listen() end}], strategy: :one_for_one)
  end

  def listen() do
    IO.puts("Logs from your program will appear here!")

    {:ok, socket} = :gen_tcp.listen(4221, [:binary, active: false, reuseaddr: true])
    {:ok, client} = :gen_tcp.accept(socket)

    {:ok, request} = :gen_tcp.recv(client, 0)
    IO.puts("RECEIVED REQUEST #{request}")

    request_str = to_string(request)
    request_list = String.split(request_str, ["\r\n"])

    [get_request, host, user_agent, accept | remainder] = request_list
    IO.puts(get_request)
    [request_type, request_route, http_version] = String.split(get_request, [" "])
    IO.puts("got here2")
    IO.puts(request_route)

    IO.puts("got here1")
    success_message = "HTTP/1.1 200 OK\r\n\r\n"
    fail_message = "HTTP/1.1 404 Not Found\r\n\r\n"
    IO.puts("got here")
    case request_route do
      "/" -> :gen_tcp.send(client, success_message)
      <<"/echo/", echo_message::binary>> ->
        IO.puts("got here")
        echo_size = byte_size(echo_message)
        echo_message = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{echo_size}\r\n\r\n#{echo_message}"
        IO.puts(echo_message)
        :gen_tcp.send(client, echo_message)
      "/user-agent" ->
          [_, agent_name] = String.split(user_agent, [" "])
          user_agent_size = byte_size(agent_name)
          user_agent_message = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: #{user_agent_size}\r\n\r\n#{agent_name}"

          :gen_tcp.send(client, user_agent_message)
      _ ->

        :gen_tcp.send(client, fail_message)
    end

    :gen_tcp.close(client)
  end
end

defmodule CLI do
  def main(_args) do
    # Start the Server application
    {:ok, _pid} = Application.ensure_all_started(:codecrafters_http_server)

    # Run forever
    Process.sleep(:infinity)
  end
end

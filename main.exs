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

    request_str = to_string(request)

    s = String.split(request_str, ["\r\n"])

    [get_request, host, user_agent, accept] = s
    [request_type, request_route, http_version] = String.split(get_request, [" "])
    IO.puts(host)
    IO.puts(user_agent)
    IO.puts(accept)


    success_message = "HTTP/1.1 200 OK\r\n\r\n"
    fail_message = "HTTP/1.1 404 Not Found\r\n\r\n"

    if request_route == "/" do
      :gen_tcp.send(client, success_message)
    else
      :gen_tcp.send(client, fail_message)
    end

    # responseOK = """
    # HTTP/1.1 200 OK\r\n\r\n
    # """

    # responseNotFound = """
    # HTTP/1.1 404 Not Found\r\n\r\n
    # """



    # :gen_tcp.send(client, response)
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

defmodule MessagerWeb.PageController do
  use MessagerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  # recieves requests from endpoints such as
  # curl http://localhost:4000/receive-message\?queue\=my_queue\&message\=hellothere
  def receive_message(conn, params) do
    %{"message" => message, "queue" => queue} = params

    rate_limit(message, queue, conn)
  end

  # Limit the messages that can be sent to just one per second
  defp rate_limit(message, queue, conn) do
    case Hammer.check_rate("send_message:#{queue}", 1000, 1) do
      {:allow, _count} ->
        # send the message
        send_message(queue, message, conn)

      {:deny, _limit} ->
        # deny the request
        conn
        |> Plug.Conn.send_resp(200, "Limit exceeded: One message per second allowed.")
    end
  end

  defp send_message(queue, message, conn) do
    case Honeydew.start_queue(queue) do
      :ok ->
        Honeydew.async({:run, message}, queue)
        IO.inspect(message, label: "Message")

        conn
        |> Plug.Conn.send_resp(200, message)

      {:error, {:already_started, _pid}} ->
        IO.inspect(message, label: "Message")

        conn
        |> Plug.Conn.send_resp(500, message)
    end
  end
end

defmodule MessagerWeb.PageControllerTest do
  use MessagerWeb.ConnCase

  alias MessagerWeb.PageController

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Message Center"
  end

  test "GET a message sent in the queue", %{conn: conn} do
    %{resp_body: resp_body} =
      PageController.receive_message(conn, %{"message" => "test", "queue" => "my_queue"})

    assert resp_body == "test"
  end

  # TODO: this test is flaky and needs to be given further attention.
  test "Multiple messages in one second", %{conn: conn} do
    message_list = ["test", "test"]

    Enum.map(message_list, fn item ->
      %{resp_body: resp_body} =
        PageController.receive_message(conn, %{
          "message" => item,
          "queue" => "my_queue"
        })

      assert resp_body == "Limit exceeded: One message per second allowed."
    end)
  end
end

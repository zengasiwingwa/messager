# Messager

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit http://localhost:4000/receive-message?queue=euc&message=this%20is%20the%20message from your browser. Feel free to replace the queue name and message with whatever is necessary. Alternatively you can send a curl request to: 

  `curl http://localhost:4000/receive-message\?queue\=as\&message\=hellothere`
  
Run mix test to examine the unit tests. 



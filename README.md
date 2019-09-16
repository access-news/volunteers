# Access News - Volunteers

## Project start instructions

### Using Nix or NixOS

0. Install Nix if not on NixOs:  
   `curl https://nixos.org/nix/install | sh`

1. Clone project and `cd` into it

2. `git clone https://github.com/NixOS/nixpkgs.git ~/clones/nixpkgs`

3. Issue `nix-shell` 

   > Read [`shell.nix`](./shell.nix) and/or the [`shell.nixes` README](https://github.com/toraritte/shell.nixes/tree/master/elixir-phoenix-postgres) to see what [`nix-shell`](https://nixos.org/nix/manual/#sec-nix-shell) will do.

4. Start  Phoenix endpoint with `mix  phx.server` or
   `iex -S mix phx.server`

### Otherwise

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

---

**NOTE**:  
Either  have a  `service_account.js`  file ready  in
the  project root,  or configure  (|disable) `Goth`,
otherwise it will raise on startup.

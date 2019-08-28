# Access News - Volunteers

## Project start instructions

### Using Nix or NixOS

0. Install Nix if not on NixOs:  
   `curl https://nixos.org/nix/install | sh`

1. Clone project and `cd` into it

2. `git clone https://github.com/NixOS/nixpkgs.git ~/clones/nixpkgs`

3. Issue `nix-shell` 

   > Read [`shell.nix`](./shell.nix) to see what `nix-shell` does.
   >
   > If it  hangs on installing `hex`  or `phoenix`, then
   > just  copy `_backup/.mix`  to  `.nix-shell` and  try
   > again:
   >
   > ```bash
   > # From project directory
   > $ rm -rf .nix-shell && mkdir .nix-shell && cp -r _backup/.mix .nix-shell
   > ```
   >
   > This workaround is needed for me on NixOS 19.03. See
   > note 2019-08-05_0553 for more info.

4. Start  Phoenix endpoint with `mix  phx.server` or
   `iex -S mix phx.server`

### Otherwise

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

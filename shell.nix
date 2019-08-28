####################################################################
# Importing a cloned Nixpkgs repo  (from my home directory), because
# the latest channels don't have Elixir 1.9.
# See https://nixos.org/nix/manual/#idm140737317975776 for the meaning
# of `<nixpkgs>` and `~` in Nix expressions (towards the end of that
# section).
####################################################################

{ pkgs ? import ~/clones/nixpkgs {} }:

pkgs.mkShell {

  buildInputs = with pkgs; [
    beam.packages.erlangR21.elixir_1_9
    postgresql_11
    nodejs-12_x
    git
    inotify-tools
    imagemagick7
  ];

  shellHook = ''

    ####################################################################
    # Create a diretory for the generated artifacts
    ####################################################################

    mkdir .nix-shell
    export NIX_SHELL_DIR=$PWD/.nix-shell

    ####################################################################
    # Put the PostgreSQL databases in the project diretory.
    ####################################################################

    export PGDATA=$NIX_SHELL_DIR/db

    ####################################################################
    # Put any Mix-related data in the project directory
    ####################################################################

    export MIX_HOME="$NIX_SHELL_DIR/.mix"
    export MIX_ARCHIVES="$MIX_HOME/archives"

    ####################################################################
    # Allow access to Google Cloud APIs
    # See https://github.com/GoogleCloudPlatform/elixir-samples/tree/master/storage
    ####################################################################

    export GOOGLE_APPLICATION_CREDENTIALS=`cat ./service_account.json`

    ####################################################################
    # Clean up after exiting the Nix shell using `trap`.
    # ------------------------------------------------------------------
    # Idea taken from
    # https://unix.stackexchange.com/questions/464106/killing-background-processes-started-in-nix-shell
    # and the answer provides a way more sophisticated solution.
    #
    # The main syntax is `trap ARG SIGNAL` where ARG are the commands to
    # be executed when SIGNAL crops up. See `trap --help` for more.
    ####################################################################

    trap \
      "
        ######################################################
        # Stop PostgreSQL
        ######################################################

        pg_ctl -D $PGDATA stop

        ######################################################
        # Delete `.nix-shell` directory
        # ----------------------------------
        # The first  step is going  back to the  project root,
        # otherwise `.nix-shell`  won't get deleted.  At least
        # it didn't for me when exiting in a subdirectory.
        ######################################################

        # Putting a pin on this for now because installing Hex
        # breaks the system, so instead of completely cleaning
        # up, MIX_HOME has been  committed to version control.
        # Setting up  PostgreSQL was  never a  problem anyway,
        # and it will only be stopped (see above) upon exiting
        # the shell.

        # cd $PWD
        # rm -rf $NIX_SHELL_DIR
      " \
      EXIT

    ####################################################################
    # If database is  not initialized (i.e., $PGDATA  directory does not
    # exist), then set  it up. Seems superfulous given  the cleanup step
    # above, but handy when one gets to force reboot the iron.
    ####################################################################

    if ! test -d $PGDATA
    then

      ######################################################
      # Init PostgreSQL
      ######################################################

      initdb $PGDATA

      ######################################################
      # PostgreSQL  will  attempt  to create  a  pidfile  in
      # `/run/postgresql` by default, but it will fail as it
      # doesn't exist. By  changing the configuration option
      # below, it will get created in $PGDATA.
      ######################################################

      OPT="unix_socket_directories"
      sed -i "s|^#$OPT.*$|$OPT = '$PGDATA'|" $PGDATA/postgresql.conf
    fi

    ####################################################################
    # Start PostgreSQL
    ####################################################################

    pg_ctl -D $PGDATA -l $PGDATA/postgres.log  start

    ####################################################################
    # Install Node.js dependencies if not done yet.
    ####################################################################

    if ! test -d "$PWD/assets/node_modules/"
    then
      (cd assets && npm install)
    fi

    # Skipping this part. See NOTE 2019-08-05_0553

      ####################################################################
      # If $MIX_HOME doesn't exist, set it up.
      ####################################################################

      # if ! test -d $MIX_HOME
      # then
      #   ######################################################
      #   # Install Hex and Phoenix
      #   ######################################################

      #   # yes | mix archive.install git https://github.com/hexpm/hex tag "v0.20.1"
      #   # yes | mix local.hex
      #   # yes | mix archive.install hex phx_new

      #   ######################################################
      #   # `ecto.setup` is defined in `mix.exs` by default when
      #   # Phoenix  project  is  generated via  `mix  phx.new`.
      #   # It  does  `ecto.create`,   `ecto.migrate`,  and  run
      #   # `priv/seeds`.
      #   ######################################################
      # fi

    # Moving  these  here  from  the  above  `if`  section
    # because  `.nix-shell/db`  and  `./deps` are  not  in
    # version control, and can be gone at time.

    mix deps.get
    mix ecto.setup
  '';

  ####################################################################
  # Without  this, almost  everything  fails with  locale issues  when
  # using `nix-shell --pure` (at least on NixOS).
  # See
  # + https://github.com/NixOS/nix/issues/318#issuecomment-52986702
  # + http://lists.linuxfromscratch.org/pipermail/lfs-support/2004-June/023900.html
  ####################################################################

  LOCALE_ARCHIVE = if pkgs.stdenv.isLinux then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
}

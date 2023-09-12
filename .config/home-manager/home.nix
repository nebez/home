{ config, ... }:

let
  pkgs = import <nixpkgs> { };

  nixLocateAuto = pkgs.fetchzip {
    url = "https://gist.github.com/nebez/47fa8522e5d52bddc36548b7ded27883/archive/6ca71e74dd974170f7d41b27d7d5bab4c118f17f.zip";
    sha256 = "0xnv2xlmwspwnvij690dikdlww61fvdhcl7rjd8gknc6fdsadqmw";
  };
in
{
  home.username = "nebez";
  home.homeDirectory = "/Users/nebez";
  home.stateVersion = "23.05";

  home.sessionVariables = {
    EDITOR = "nano";
  };

  home.packages = [
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.coreutils-prefixed
    pkgs.awscli2
    pkgs.niv
    pkgs.deno
    pkgs.jq
    pkgs.gh
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  imports = [ "${nixLocateAuto}/default.nix" ];

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      config = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
      ls = "gls --color=auto --group-directories-first -A";
      ll = "gls --color=auto --group-directories-first -al";
      nix-info = "nix-shell -p nix-info --run \"nix-info -m\"";
      nix-repair = "nix-store --verify --check-contents --repair";
      man-home-manager = "man home-configuration.nix";
      ssh-host-rm = "ssh-keygen -R";
      sm = "deno run --allow-all --no-check ~/code/github.com/nebez/sm/main.ts";
    };
    initExtra = ''
      # Nixify the current directory
      nixify() {
        if [ ! -e ./.envrc ]; then
          echo "use nix" > .envrc
          direnv allow
        fi
        if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
          # Make a default shell.nix and then pop open an editor
          niv init --latest
          cat > shell.nix <<'EOF'
let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};
in
pkgs.mkShell {
  buildInputs = [
    pkgs.nodejs-18_x
  ];
}
EOF
          nano shell.nix
        fi
      }
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ "colored-man-pages" ];
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "emodipt-extend";
  };

  programs.git = {
    enable = true;
    userName = "Nebez Briefkani";
    userEmail = "me@nebezb.com";
    aliases = {
      s = "status -sb";
      last = "log -1 HEAD";
      proon = "fetch origin --prune";
      aliases = "!git config -l | grep alias | cut -c 7-";
      l = "log --pretty=oneline --abbrev-commit";
      ll = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
    extraConfig = {
      # We do this because, otherwise, git attempts to use the openssh built
      # from nix which doesn't support UseKeychain. See below for more:
      # https://github.com/NixOS/nixpkgs/issues/15686
      core.sshCommand = "/usr/bin/ssh";
    };
    ignores = [
      ".direnv/"
    ];
    delta = {
      enable = true;
      options = {
        features = "line-numbers";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.ssh = {
    enable = true;
    hashKnownHosts = true;
    extraConfig = ''
      UseKeychain yes
    '';
    matchBlocks = {
      "github.com" = {
        user = "git";
      };
    };
  };
}

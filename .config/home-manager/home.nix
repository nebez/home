# Home manager `programs` can be found here
# https://github.com/nix-community/home-manager/blob/master/modules/programs
{ config, ... }:

let
  # This refers to channels in nix-channel --list
  # Outputs
  #    home-manager https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz
  #    nixpkgs https://channels.nixos.org/nixpkgs-22.05-darwin
  pkgs = import <nixpkgs> { };

  # Refer to 22.05 because deno is broken in unstable
  # Follow updates here: https://github.com/NixOS/nixpkgs/issues/181982
  #pkgs2205 = import
  #  (fetchTarball "http://nixos.org/channels/nixos-22.05/nixexprs.tar.xz") { };

  nixLocateAuto = pkgs.fetchzip {
    url = "https://gist.github.com/nebez/47fa8522e5d52bddc36548b7ded27883/archive/6ca71e74dd974170f7d41b27d7d5bab4c118f17f.zip";
    sha256 = "0xnv2xlmwspwnvij690dikdlww61fvdhcl7rjd8gknc6fdsadqmw";
  };
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nebez";
  home.homeDirectory = "/Users/nebez";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  home.sessionVariables = {
    EDITOR = "nano";
  };

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

  home.packages = [
    pkgs.coreutils-prefixed
    pkgs.awscli2
    pkgs.niv
    pkgs.deno
    pkgs.jq
    pkgs.gh
  ];

  imports = [ "${nixLocateAuto}/default.nix" ];
}

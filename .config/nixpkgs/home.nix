# Home manager `programs` can be found here
# https://github.com/nix-community/home-manager/blob/master/modules/programs
{ config, pkgs, ... }:

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
    };
    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
    initExtraBeforeCompInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    initExtra = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Nixify the current directory
      nixify() {
        if [ ! -e ./.envrc ]; then
          echo "use nix" > .envrc
          direnv allow
        fi
        if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
          # Make a default shell.nix and then pop open an editor
          cat > shell.nix <<'EOF'
with import <nixpkgs> {};
mkShell {
  buildInputs = [ nodejs-12_x ];
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
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
      };
      "*" = {
        extraOptions = {
          UseKeychain = "yes";
        };
      };
    };
  };

  home.packages = [
    pkgs.deno
    pkgs.coreutils-prefixed
  ];
}

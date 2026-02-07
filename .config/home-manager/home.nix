{ config, pkgs, ... }:

{
  home.username = "nebez";
  home.homeDirectory = "/Users/nebez";
  home.stateVersion = "23.05";

  home.sessionVariables = {
    EDITOR = "nano";
  };

  home.packages = [
    (pkgs.writeShellScriptBin "nixify" (builtins.readFile ./nixify.sh))

    pkgs.coreutils-prefixed
    pkgs.awscli2
    pkgs.niv
    pkgs.jq
    pkgs.nnn
    pkgs.deno
    pkgs.nixd
    pkgs.smartmontools
    pkgs.pnpm
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

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      config = "git --git-dir=$HOME/.cfg/ --work-tree=$HOME";
      ls = "gls --color=auto --group-directories-first -A";
      ll = "gls --color=auto --group-directories-first -al";
      man-home-manager = "man home-configuration.nix";
      ssh-host-rm = "ssh-keygen -R";
      sm = "deno run --allow-all --no-check ~/code/github.com/nebez/sm/main.ts";
      home-manager-flake-update = "nix flake update --flake ~/.config/home-manager/";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "colored-man-pages" ];
    };
  };

  # programs.oh-my-posh = {
  #   enable = true;
  #   enableZshIntegration = true;
  # };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Nebez Briefkani";
      user.email = "me@nebezb.com";
      # We do this because, otherwise, git attempts to use the openssh built
      # from nix which doesn't support UseKeychain. See below for more:
      # https://github.com/NixOS/nixpkgs/issues/15686
      core.sshCommand = "/usr/bin/ssh";
      alias = {
        s = "status -sb";
        last = "log -1 HEAD";
        proon = "fetch origin --prune";
        aliases = "!git config -l | grep alias | cut -c 7-";
        l = "log --pretty=oneline --abbrev-commit";
        ll = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };
    ignores = [
      ".direnv/"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "line-numbers";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
        hashKnownHosts = true;
        identityAgent = "\"~/Library/Group Containers/group.strongbox.mac.mcguill/agent.sock\"";
        # UseKeychain = true; # This config needs to move to extraConfig, but I'm not sure I need it.

      };
      "github.com" = {
        user = "git";
      };
    };
  };
}

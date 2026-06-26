{ pkgs, ... }:

{
  home.username = "nebez";
  home.homeDirectory = "/Users/nebez";
  home.stateVersion = "23.05";

  home.sessionVariables = {
    EDITOR = "nano";
    PNPM_HOME = "/Users/nebez/.pnpm";
  };

  home.sessionPath = [
    "/Users/nebez/.pnpm/bin"
  ];

  home.packages = [
    (pkgs.writeShellScriptBin "nixify" (builtins.readFile ./nixify.sh))
    (pkgs.writeShellScriptBin "c" (builtins.readFile ./c.sh))
    pkgs.coreutils-prefixed
    pkgs.awscli2
    pkgs.niv
    pkgs.jq
    pkgs.nnn
    pkgs.deno
    pkgs.nixd
    pkgs.smartmontools
    pkgs.pnpm
    pkgs.nodejs-slim
    pkgs.ripgrep
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
      cwdeploy = "deno run --allow-read --allow-run --allow-env jsr:@nebez/cwdeploy@0.2.0";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "colored-man-pages" ];
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Nebez Briefkani";
      user.email = "me@nebezb.com";
      # We do this because, otherwise, git attempts to use the openssh built
      # from nix which doesn't support UseKeychain. See below for more:
      # https://github.com/NixOS/nixpkgs/issues/15686
      core.sshCommand = "/usr/bin/ssh";
      init.defaultBranch = "main";
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
      ".DS_Store"
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

  programs.mise = {
      enable = true;
      enableZshIntegration = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
        HashKnownHosts = true;
        IdentityAgent = "\"~/Library/Group Containers/group.strongbox.mac.mcguill/agent.sock\"";
        # UseKeychain = true; # This config needs to move to extraConfig, but I'm not sure I need it.

      };
      "github.com" = {
        User = "git";
      };
    };
  };
}

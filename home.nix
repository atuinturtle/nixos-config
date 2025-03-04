{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "mmakay";
  home.homeDirectory = "/home/mmakay";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Packages to install
  home.packages = with pkgs; [
    spotify
    obsidian
    code-cursor
    jetbrains.idea-community-bin
    brave
    mpv
    docker
  ];

  # In your home.nix
  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos";
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Mátyás Makay";
    userEmail = "mmakay94@gmail.com";
    
    # Additional Git configurations
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      color.ui = true;
      
      # You can add more git configurations here
      # For example:
      # core.editor = "vim";
      # merge.tool = "vimdiff";
    };
    
    # Optional: Configure Git aliases
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
    };
    
    # Optional: Configure Git ignores globally
    ignores = [ 
      ".DS_Store" 
      "*.swp" 
      ".env" 
      "node_modules"
      ".vscode/"
      ".idea/"
    ];
  };
}

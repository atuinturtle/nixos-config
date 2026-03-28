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
    brave
    mpv
    docker
    docker-compose
    btrfs-progs
    qbittorrent
    wineWow64Packages.stable 
    yt-dlp
    calibre
    neovim
    jetbrains.idea
    github-copilot-intellij-agent
    protonup-qt
    gimp
    libreoffice
    unrar
    r2modman
    claude-code
  ];

  # In your home.nix
  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#nixos";
  };

  # Git configuration
  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      user.name = "Mátyás Makay";
      user.email = "mmakay94@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = false;
      color.ui = true;
      alias = {
        co = "checkout";
        ci = "commit";
        st = "status";
        br = "branch";
        hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      };
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

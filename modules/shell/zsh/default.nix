{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.modules.zsh;
  exaIconsOption = if cfg.enableFileIcons then "--icons" else "";
in {
  options.modules.zsh = {
    enable = mkEnableOption "Zsh shell";
    enableFlashyPrompt = mkEnableOption "Enable flashy shell prompt with neofetch, figlet et al";
    enableFileIcons = mkEnableOption "Enable icons when using ls (exa)";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.enableFlashyPrompt) {
      home.packages = with pkgs;
        [
          neofetch
          lolcat
          boxes
          fortune
        ];
      xdg.configFile."zsh/greeting.zsh".source = ./greeting.zsh;
    })

    ({
      xdg.configFile."zsh/fix-nix-path.zsh".source = ./fix-nix-path.zsh;
      xdg.configFile."zsh/source-config.zsh".source = ./source-config.zsh;

      programs = {
        zsh = {
          enable = true;
          dotDir = ".config/zsh";

          oh-my-zsh.enable = true;

          enableAutosuggestions = true;
          enableSyntaxHighlighting = true;

          history = {
            size = 100000000;
          };

          shellAliases = {
            ls = "exa ${exaIconsOption}";
            la = "exa -a ${exaIconsOption}";
            ll = "exa -l ${exaIconsOption}";
            i = "grep -i";
            x = "grep";
          };
        };

        starship = {
          enable = true;
          enableZshIntegration = true;
          settings = {
            add_newline = false;
            hostname = {
              ssh_only = false;
            };
            username = {
              show_always = true;
            };
          };
        };
        
        fzf = {
          enable = true;
          enableZshIntegration = true;
        };
      };

      home.packages = with pkgs; [ exa ];
    })
  ]);
}

{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    themeFile = "VSCode_Dark";
    font = {
      name = "JetBrains Mono";
      # A size of 10pt should equate to 13px, which is the size that JetBrains
      # recommends for the font.
      size = 10;
    };
    settings = {
      shell = "${pkgs.nushell}/bin/nu";
      confirm_os_window_close = "0";
      enable_audio_bell = false;
      allow_remote_control = "socket-only";
      disable_ligatures = "always";
      window_padding_width = "8";
      tab_bar_edge = "top";
      active_tab_font_style = "normal"; # Default is "italic"
    };
    keybindings = {
      "ctrl+t" = "new_tab";
      "ctrl+w" = "close_tab";
      "ctrl+page_up" = "previous_tab";
      "ctrl+page_down" = "next_tab";
      "ctrl+shift+page_up" = "move_tab_backward";
      "ctrl+shift+page_down" = "move_tab_forward";
    };
  };
}

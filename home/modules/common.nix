let
  username = "alex";
in {
  # Setup home manager
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05"; # Don't change once set
}

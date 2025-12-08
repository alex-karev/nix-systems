# Create webapps
{
  pkgs,
  config,
  ...
}: let
  mkWebApp = name: link: icon: {
    name = name;
    icon = "${config.home.homeDirectory}/.local/share/icons/webapps/${name}.png";
    exec = "${pkgs.chromium}/bin/chromium --app=${link} --disable-features=GlobalShortcutsPortal";
  };
in {
  # Create desktop entries
  xdg.desktopEntries = {
    quillbot = mkWebApp "QuillBot" "https://quillbot.com/";
    chatgpt = mkWebApp "ChatGPT" "https://chatgpt.com/";
    deepseek = mkWebApp "DeepSeek" "https://chat.deepseek.com/";
    overleaf = mkWebApp "Overleaf" "https://www.overleaf.com/";
    perplexity = mkWebApp "Perplexity" "https://www.perplexity.ai/";
    whatsapp = mkWebApp "WhatsApp" "https://web.whatsapp.com/";
    figma = mkWebApp "Figma" "https://www.figma.com/";
    youtube-music = mkWebApp "YTMusic" "https://music.youtube.com/";
    telegram = mkWebApp "Telegram" "https://web.telegram.org/";
    shulogin = mkWebApp "SHU Login" "http://10.10.9.9/";
    photopea = mkWebApp "Photopea" "https://www.photopea.com/";
  };

  # Link icons
  # home.file."${config.home.homeDirectory}/.local/share/icons/webapps" = {
  #   source = ../../assets/webapps;
  # };
}

# Web applications
# TODO: figure out a better way to get icons
# TODO: fix
{
  self,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    self',
    inputs',
    ...
  }: let
    mkWebApp = name: link: icon: {
      name = name;
      icon = "/home/alex/.local/share/icons/webapps/${name}.png";
      exec = "${lib.getExe pkgs.chromium} --app=${link} --disable-features=GlobalShortcutsPortal";
    };
    packages = {
      webapp-quillbot = mkWebApp "QuillBot" "https://quillbot.com/";
      webapp-chatgpt = mkWebApp "ChatGPT" "https://chatgpt.com/";
      webapp-deepseek = mkWebApp "DeepSeek" "https://chat.deepseek.com/";
      webapp-overleaf = mkWebApp "Overleaf" "https://www.overleaf.com/";
      webapp-perplexity = mkWebApp "Perplexity" "https://www.perplexity.ai/";
      webapp-whatsapp = mkWebApp "WhatsApp" "https://web.whatsapp.com/";
      webapp-figma = mkWebApp "Figma" "https://www.figma.com/";
      webapp-youtube-music = mkWebApp "YTMusic" "https://music.youtube.com/";
      webapp-telegram = mkWebApp "Telegram" "https://web.telegram.org/";
      webapp-shulogin = mkWebApp "SHU Login" "http://10.10.9.9/";
      webapp-photopea = mkWebApp "Photopea" "https://www.photopea.com/";
    };
  in {
    # packages = packages;
    _module.args.webapps = with packages; [
      webapp-quillbot
      webapp-chatgpt
      webapp-deepseek
      webapp-overleaf
      webapp-perplexity
      webapp-whatsapp
      webapp-figma
      webapp-youtube-music
      webapp-shulogin
      webapp-photopea
    ];
  };
}

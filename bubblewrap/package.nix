{pkgs}: let
  mkBwrap = import ./common.nix {inherit pkgs;};
in {
  wechat = {
    fakeHome ? "~/.var/wechat",
    extraBwrapArgs ? [],
    fcitx ? true,
  }:
    mkBwrap {
      name = "wechat";
      package = let
        version = "4.1.0.13";
        pname = "wechat";
        url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
        hash = "sha256-+r5Ebu40GVGG2m2lmCFQ/JkiDsN/u7XEtnLrB98602w=";
        contents = pkgs.appimageTools.extract {
          inherit pname version;
          src = pkgs.fetchurl {
            inherit url hash;
          };
          postExtract = ''
            patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/wechat/wechat
          '';
        };
      in
        pkgs.appimageTools.wrapAppImage {
          inherit pname version;
          meta = {
            mainProgram = "wechat";
            platforms = ["x86_64-linux"];
          };
          src = contents;
          extraInstallCommands = ''
            mkdir -p $out/share/applications
            cp ${contents}/wechat.desktop $out/share/applications/
            mkdir -p $out/share/pixmaps
            cp ${contents}/wechat.png $out/share/pixmaps/
            substituteInPlace $out/share/applications/wechat.desktop --replace-fail AppRun wechat
          '';
        };
      fakeHome = fakeHome;
      extraBwrapArgs =
        [
          "--ro-bind /run/opengl-driver/lib /run/opengl-driver/lib"
          "--ro-bind /sys /sys"
        ]
        ++ pkgs.lib.optionals fcitx [
          "--setenv QT_IM_MODULE fcitx"
          "--setenv GTK_IM_MODULE fcitx"
        ]
        ++ extraBwrapArgs;
    };
  wemeet = {
    fakeHome ? "~/.var/wemeet",
    extraBwrapArgs ? [],
  }:
    mkBwrap {
      name = "wemeet";
      package = pkgs.wemeet;
      fakeHome = fakeHome;
      extraBwrapArgs =
        [
          "--ro-bind / /"
          "--dev-bind / /"
          "--bind /tmp /tmp"
          "--bind /run/user/\$(id -u) /run/user/\$(id -u)"
          "--tmpfs /sys/devices/virtual"
          "--tmpfs /var"
        ]
        ++ extraBwrapArgs;
    };
}

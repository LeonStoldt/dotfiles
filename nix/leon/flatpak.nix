{ ... }:

# GUI applications, declaratively.
{
  services.flatpak = {
    enable = true;

    remotes = [{
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }];

    packages = [
      # --- browsers ---
      "com.brave.Browser"

      # --- security / secrets ---
      "com.bitwarden.desktop"
      "org.wireshark.Wireshark"
      #"net.portswigger.BurpSuite-Community"

      # --- office ---
      "org.libreoffice.LibreOffice"
      "com.tutanota.Tutanota"
      "com.nextcloud.desktopclient.nextcloud"
      #"org.mozilla.thunderbird"

      # --- audio ---
      "org.pulseaudio.pavucontrol"
      "org.audacityteam.Audacity"

      # --- media ---
      "com.obsproject.Studio"
      "org.kde.krita"
      "org.jellyfin.JellyfinDesktop"
      
      # --- tools ---
      "org.fedoraproject.MediaWriter"
      "org.flameshot.Flameshot"
      #"de.breitbandmessung.Breitbandmessung"

      # --- productivity / notes ---
      "md.obsidian.Obsidian"
      "com.jgraph.drawio.desktop"
      "org.localsend.localsend_app"

      # --- IDEs ---
      "com.jetbrains.IntelliJ-IDEA-Community"
      "dev.zed.Zed"

      # --- 3D Printing ---
      "org.freecad.FreeCAD"
      "com.prusa3d.PrusaSlicer"
      #"org.openscad.OpenSCAD"

      # --- Gaming ---
      "com.discordapp.Discord"

    ];
    update.onActivation = true;
    uninstallUnmanaged = true;
  };
}

_: {
  # Nemo's own desktop entry is called "Files" (localised to "Archivos"), and
  # its keywords are folders/filesystem/explorer -- the string "nemo" appears
  # nowhere a launcher would look. DankMaterialShell makes that worse: its app
  # index does match on the entry id, but the launcher re-scores the shortlist
  # over name/subtitle/keywords only and drops anything that scored purely on
  # id, so typing "nemo" returned nothing at all. This entry shadows the
  # system one from ~/.local/share/applications with the name spelled out and
  # both languages in the keywords, so it is findable either way.
  xdg.desktopEntries.nemo = {
    name = "Nemo";
    genericName = "Archivos";
    comment = "Access and organize files";
    exec = "nemo %U";
    icon = "system-file-manager";
    terminal = false;
    type = "Application";
    categories = [
      "GNOME"
      "GTK"
      "Utility"
      "Core"
      "FileManager"
    ];
    mimeType = [
      "inode/directory"
      "application/x-gnome-saved-search"
    ];
    settings = {
      Keywords = "nemo;archivos;ficheros;files;folders;carpetas;filesystem;explorer;explorador;gestor;manager;";
      StartupNotify = "false";
    };
  };
}

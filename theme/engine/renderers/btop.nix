{ name, colors }:
let
  c = colors;
in
''
  # Theme: ${name}
  # Generated from base16 colors

  theme[main_bg]="${c.base00}"
  theme[main_fg]="${c.base05}"

  theme[title]="${c.base0D}"

  theme[hi_fg]="${c.base0D}"
  theme[selected_bg]="${c.base02}"
  theme[selected_fg]="${c.base05}"

  theme[inactive_fg]="${c.base03}"
  theme[graph_text]="${c.base04}"
  theme[proc_misc]="${c.base0E}"

  theme[cpu_box]="${c.base0D}"
  theme[cpu_hi]="${c.base08}"
  theme[cpu_mid]="${c.base0A}"
  theme[cpu_normal]="${c.base0B}"

  theme[mem_box]="${c.base0B}"
  theme[mem_bytes]="${c.base0B}"
  theme[mem_graph]="${c.base0B}"
  theme[mem_swap]="${c.base09}"
  theme[disk_box]="${c.base0E}"

  theme[net_box]="${c.base0C}"
  theme[net_upload]="${c.base09}"
  theme[net_download]="${c.base0B}"

  theme[proc_box]="${c.base0D}"
  theme[proc_cpu]="${c.base08}"
  theme[proc_mem]="${c.base0B}"
  theme[proc_io]="${c.base0E}"
''

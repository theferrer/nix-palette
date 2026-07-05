c:
let
  hex = color: "0xff${builtins.substring 1 6 color}";
in
''
  $pink = ${hex c.base0E}
  $blue = ${hex c.base0D}
  $cyan = ${hex c.base0C}
  $green = ${hex c.base0B}
  $yellow = ${hex c.base0A}
  $orange = ${hex c.base09}
  $red = ${hex c.base08}
  $mauve = ${hex c.base0F}
  $text = ${hex c.base05}
  $surface0 = ${hex c.base02}
  $surface1 = ${hex c.base03}
  $surface2 = ${hex c.base04}
  $base = ${hex c.base00}
  $mantle = ${hex c.base01}
''

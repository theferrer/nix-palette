{ name, colors }:
let
  c = colors;
  rule = scopeName: scope: color: ''
    <dict>
      <key>name</key>
      <string>${scopeName}</string>
      <key>scope</key>
      <string>${scope}</string>
      <key>settings</key>
      <dict>
        <key>foreground</key>
        <string>${color}</string>
      </dict>
    </dict>
  '';
in
''
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
    <key>name</key>
    <string>${name}</string>
    <key>settings</key>
    <array>
      <dict>
        <key>settings</key>
        <dict>
          <key>background</key>
          <string>${c.base00}</string>
          <key>foreground</key>
          <string>${c.base05}</string>
          <key>caret</key>
          <string>${c.base05}</string>
          <key>lineHighlight</key>
          <string>${c.base01}</string>
          <key>selection</key>
          <string>${c.base02}</string>
        </dict>
      </dict>
      ${rule "Comment" "comment" c.base03}
      ${rule "String" "string" c.base0B}
      ${rule "Number" "constant.numeric" c.base09}
      ${rule "Constant" "constant" c.base09}
      ${rule "Keyword" "keyword" c.base0E}
      ${rule "Storage" "storage" c.base0E}
      ${rule "Entity" "entity" c.base0D}
      ${rule "Function" "entity.name.function" c.base0D}
      ${rule "Variable" "variable" c.base08}
      ${rule "Support" "support" c.base0C}
      ${rule "Tag" "entity.name.tag" c.base08}
      ${rule "Invalid" "invalid" c.base08}
    </array>
  </dict>
  </plist>
''

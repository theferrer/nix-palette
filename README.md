# nix-palette

An opinionated **palette** for [`nix-canvas`](https://github.com/theferrer/nix-canvas).
Where canvas is the grammar, a palette is the **vocabulary and the opinion**: the
universe of software, the composable wants, the looks, the reusable Home Manager
modules and the theme engine (synthppuccin).

Swapping the palette swaps the entire software/style/adjudications of a system
without touching canvas. Other palettes can be written against the same
grammar: a host's *capability* deviations (`use`) port unchanged, while want
and look names are palette-owned and map across on the swap.

## What a palette is

- A **catalog**: every piece of software defined exactly once
  (`package` + which capabilities it `provides` + an optional Home Manager module).
- **Wants**: composable named intents. A want lists `software`, requires
  `capabilities`, and composes other wants via `includes` (there are no separate
  "groups" - a group is just a want that only lists software).
- **Looks**: capability → app adjudications (`use`) plus a `style`. Nothing else -
  looks are opinion, wants are intent.
- **Themes**: color schemes + wallpapers, materialized as files and switchable at
  runtime with `theme-set` - no rebuild.

## Catalog shape

```nix
software.kitty   = { package = pkgs.kitty; provides = [ "terminal" ]; homeModule = ./home; };
software.hyprland = { package = pkgs.hyprland; provides = [ "desktop" ]; sessionProtocol = "wayland"; };
software.ripgrep = { package = pkgs.ripgrep; };   # package only -> installed directly

wants.cli-core    = { software = [ "git" "curl" "ripgrep" "fd" "jq" ]; };
wants.development = { capabilities = [ "editor" "shell" ]; includes = [ "cli-core" ]; };

looks.neon = {
  use = { desktop = "hyprland"; terminal = "kitty"; editor = "nvim"; browser = "firefox"; };
  style = "synthppuccin";
};
```

Capabilities (`desktop`, `terminal`, `editor`, ... - kebab-case) come from canvas's
base vocabulary (`canvas.lib.spec.capabilities`); this palette implements them and
does not extend the set.

## Consuming the palette

```nix
# flake inputs: canvas, palette (with palette.inputs.canvas.follows = "canvas")
modules = [
  canvas.nixosModules.default
  palette.nixosModules.default          # registers the catalog
  {
    canvas = {
      machine = { primaryUser = "me"; formFactor = "laptop"; };
      wants = [ "desktop" "development" ];
      look = "neon";
      integrations.home-manager.enable = true;   # injects active apps' home modules
    };
  }
];

# and, for the theme engine, in the user's Home Manager imports:
home-manager.users.me.imports = [ palette.homeModules.themes ];
```

Per-host deviations stay one-liners: `canvas.use.terminal = "ghostty";`,
`canvas.use.screen-locker = null;`, `canvas.extra = [ "obsidian" ];`.

## Home Manager modules need no gating

Canvas injects only *active* software's home modules into the primary user, so a
palette module is plain configuration:

```nix
# apps/kitty/home/default.nix
{ config, ... }:
{
  programs.kitty.enable = true;
  # ...
}
```

If the module is in the user's imports, its software is active. No `mkIf`, no flags.

## The theme engine

Themes are data under [`theme/themes/`](./theme/themes): a `colors.nix` (base16 + semantic
aliases) and a wallpaper. The engine (`homeModules.themes`):

1. materializes **every** registered theme under `~/.local/share/canvas-themes/<name>/`
   (per-app fragments rendered from the colors, plus the wallpaper);
2. points active apps at the `~/.config/theme/current` symlink (kitty
   `include`, hyprland `source`, ...);
3. installs **`theme-set <name>`**: flips the symlink, sets the wallpaper
   (awww/swww/feh, whatever the session has) and live-reloads apps.

`canvas.style.name` (usually set by the look) is only the *initial* theme:
activation creates the symlink when missing and never overrides a runtime choice.

**Adding a theme** = one directory (`theme/themes/<name>/colors.nix` + wallpaper)
and one line in `theme/themes/default.nix`. Rebuild once; from then on it participates in
`theme-set`.

## Layout

- `catalog/` - pure data: the software **dictionary** (plain facts by
  category), `wants.nix`, `looks.nix`, and the assembly.
- `apps/<category>/<name>/` - one directory per **opinionated** app:
  `entry.nix` (catalog fragment), `home/` (Home Manager config) and/or
  `nixos.nix` (system glue), auto-discovered.
- `theme/` - the theming subsystem: `engine/` (+ renderer registry) and
  `themes/` (data).
- `shared/` - cross-cutting, not app-owned: fonts, portals, xdg, audio.
- `pkgs/` - the palette's own derivations (things not in nixpkgs),
  embedded in the catalog and re-exposed via `overlays.default`.
- `modules/` - the flake-facing entrypoints (discovery + catalog
  registration).

## Adding an app

- Plain fact (installable, no opinion): one entry in its
  `catalog/dictionary/` category file.
- Opinionated: one directory under `apps/<category>/<name>/` with `entry.nix`
  and its `home/` config and/or `nixos.nix` glue - nothing else to wire,
  discovery does the rest.
- Reference it from a want, or let a look adjudicate it to a capability.

## Testing

```bash
nix flake check
```

Four suites: **catalog** (integrity + pure-resolver runs for every look),
**themes** (every theme renders with every renderer), **home** (a real standalone
Home Manager evaluation exercising the theme engine end to end) and **smoke**
(a real NixOS evaluation with canvas + this palette + a host), plus statix,
deadnix and formatting.

## Relationship with nix-canvas

The palette **provides** the catalog (`canvas.catalog.*`); canvas **resolves** it.
Consumers should set `palette.inputs.canvas.follows = "canvas"` so a single canvas
is shared.

## License

MIT. See [LICENSE](./LICENSE).

{
  dmsModule ? null,
  nixvimModule ? null,
  commaModule ? null,
}:
{ pkgs, lib, ... }:
{
  canvas.catalog = import ../catalog {
    inherit
      pkgs
      lib
      dmsModule
      nixvimModule
      commaModule
      ;
  };
}

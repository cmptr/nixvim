{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    vim-repeat # smarter . repeat for plugin actions
    vim-abolish # :S (coercion: camelCase ↔ snake_case), :Subvert
    vim-unimpaired # ]q/[q for quickfix, ]b/[b for buffers, etc.
  ];
}

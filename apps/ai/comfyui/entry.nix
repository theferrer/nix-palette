{
  # The Python environment is GPU-dependent, so the real package is built in
  # nixos.nix where the host's declared GPUs are visible. Same pattern as
  # apps/ai/ace-step.
  package = null;
  description = "ComfyUI: local diffusion (image, edit, 3D) with pinned models, plus comfyui-run to drive it from scripts and agents.";
  homeModule = ./home;
}

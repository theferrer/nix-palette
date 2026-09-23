{
  # The Python environment is GPU-dependent, so the real package is built in
  # nixos.nix where the host's declared GPUs are visible. Same pattern as
  # apps/ai/llama-cpp.
  package = null;
  description = "ACE-Step 1.5: local text-to-music generation, covers and audio2audio.";
}

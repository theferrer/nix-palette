{
  # The real package is GPU-dependent, so it is built in nixos.nix where the
  # host's declared GPUs are visible. See apps/ai/ollama for the same pattern.
  package = null;
  description = "llama.cpp server preconfigured for local Qwen3.8-27B coding.";
  homeModule = ./home;
}

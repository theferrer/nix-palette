# Values the NixOS glue and the Home Manager glue both need to agree on: the
# NixOS side bakes them into the server wrapper, the Home Manager side points
# opencode at the same endpoint.
{
  port = 8099;

  # llama-server's --alias, which is also the model id opencode asks for.
  alias = "qwen3.8-27b";

  # Context the server is started with. opencode is told the same number so it
  # compacts before the server has to truncate.
  contextSize = 32768;

  # Where the GGUFs live. They are ~15 GB, so they stay out of the Nix store and
  # out of git; fetch them once by hand (see the app's README note) and the
  # wrapper picks them up. Relative to the user's home.
  modelSubdir = "models/qwen3.8-27b";

  modelFile = "Qwen3.8-27B-UD-Q3_K_XL.gguf";
  mtpFile = "mtp-Qwen3.8-27B-Q4_0.gguf";
}

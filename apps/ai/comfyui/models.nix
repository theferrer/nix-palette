# The checkpoints `comfyui models` knows how to fetch, pinned to a repository
# revision and checked against the sha256 HuggingFace records for them. They
# are tens of GB, so they stay out of the store: this is only the manifest.
#
# Sized for a 16 GB card. Where a model has a smaller variant that still fits,
# the larger one is used; the edit model is the exception, at 20 B it only fits
# quantized.
let
  hf = repo: rev: file: {
    url = "https://huggingface.co/${repo}/resolve/${rev}/${file}";
    name = baseNameOf file;
  };

  zImage = hf "Comfy-Org/z_image_turbo" "6fc90a3b1b653e935a0d175e260736de25b84df5";
  klein = hf "Comfy-Org/vae-text-encorder-for-flux-klein-4b" "5f526678002e43af5551dadb73ce2e8c91b43afe";
  qwenImage = hf "Comfy-Org/Qwen-Image_ComfyUI" "1f12b17be14c89b026c51a91d67c32f84bb047bc";
in
{
  # Text-to-image and reference-guided generation. Z-Image Turbo and FLUX.2
  # klein share the same Qwen3-4B text encoder, byte for byte, so it is here
  # once.
  core = {
    description = "Z-Image Turbo + FLUX.2 klein 4B, with a pixel-art LoRA for each";
    files = [
      (
        zImage "split_files/diffusion_models/z_image_turbo_bf16.safetensors"
        // {
          dir = "diffusion_models";
          sha256 = "2407613050b809ffdff18a4ac99af83ea6b95443ecebdf80e064a79c825574a6";
          size = 12309866400;
        }
      )
      (
        zImage "split_files/text_encoders/qwen_3_4b.safetensors"
        // {
          dir = "text_encoders";
          sha256 = "6c671498573ac2f7a5501502ccce8d2b08ea6ca2f661c458e708f36b36edfc5a";
          size = 8044982048;
        }
      )
      (
        zImage "split_files/vae/ae.safetensors"
        // {
          dir = "vae";
          sha256 = "afc8e28272cd15db3919bacdb6918ce9c1ed22e96cb12c4d5ed0fba823529e38";
          size = 335304388;
        }
      )
      (
        klein "split_files/diffusion_models/flux-2-klein-4b.safetensors"
        // {
          dir = "diffusion_models";
          sha256 = "ec3d4e733a771f61c052fb4856c48b336c55eaf2c65487c2a1faeb9bbda7a343";
          size = 7751105712;
        }
      )
      (
        klein "split_files/vae/flux2-vae.safetensors"
        // {
          dir = "vae";
          sha256 = "868fe7b343cc8f3a19dbcfcafbc3d5f888802be3f89bd81b65b3621a066ce8f3";
          size = 336211292;
        }
      )
      # Trigger: "Pixel art style."
      (
        hf "tarn59/pixel_art_style_lora_z_image_turbo" "0a5092d1619664d94a5a36784f92db84b3ae62bd"
          "pixel_art_style_z_image_turbo.safetensors"
        // {
          dir = "loras";
          sha256 = "09b1b45ceed0202929bca528e51b50208d0160f4e9d2ba0f42cb7e739a43577f";
          size = 170128328;
        }
      )
      # Trigger: "PXART4". Upstream names it plain pixelart_lora, which says
      # nothing about which base model it is for once it sits in loras/.
      (
        hf "adirik/pixel-art-lora-flux.2-klein-4B" "cb04fb378e80efc7be0450457714a50292f011d1"
          "pixelart_lora.safetensors"
        // {
          name = "pixel_art_flux2_klein_4b.safetensors";
          dir = "loras";
          sha256 = "eec52255dd0611861def82a2a7c8b0439a4b0748a77ca55802a097013176564a";
          size = 369644416;
        }
      )
    ];
  };

  # Instruction editing: change a pose, turn a character, relight, fix one
  # region -- keeping identity, which plain img2img does not.
  edit = {
    description = "Qwen-Image-Edit-2511 (Q4_K_M GGUF), 4-step Lightning and multiple-angles LoRAs";
    files = [
      # 20 B parameters: fp8 is 20 GB and would spill, Q4_K_M is 13 GB and does
      # not. Loaded through the ComfyUI-GGUF node.
      (
        hf "unsloth/Qwen-Image-Edit-2511-GGUF" "0d33d9692b4b26212297240d87b0d4719aa4fd06"
          "qwen-image-edit-2511-Q4_K_M.gguf"
        // {
          dir = "diffusion_models";
          sha256 = "8677bac90627adbbc11efab87b1870e701c4eb3689ee865a3de8ab81b705a723";
          size = 13244758624;
        }
      )
      (
        qwenImage "split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors"
        // {
          dir = "text_encoders";
          sha256 = "cb5636d852a0ea6a9075ab1bef496c0db7aef13c02350571e388aea959c5c0b4";
          size = 9384670680;
        }
      )
      (
        qwenImage "split_files/vae/qwen_image_vae.safetensors"
        // {
          dir = "vae";
          sha256 = "a70580f0213e67967ee9c95f05bb400e8fb08307e017a924bf3441223e023d1f";
          size = 253806246;
        }
      )
      (
        hf "lightx2v/Qwen-Image-Edit-2511-Lightning" "d74eba145674fd7e31b949324e148e21e7118abd"
          "Qwen-Image-Edit-2511-Lightning-4steps-V1.0-bf16.safetensors"
        // {
          dir = "loras";
          sha256 = "22226e8d05d354bb356627d428809f5afd7819399b077238a2b70a82883a904f";
          size = 849608296;
        }
      )
      (
        hf "fal/Qwen-Image-Edit-2511-Multiple-Angles-LoRA" "e3066224ab74263f4a5b6179cd1a3b0a15577e44"
          "qwen-image-edit-2511-multiple-angles-lora.safetensors"
        // {
          dir = "loras";
          sha256 = "42426ded4e25fd22879d9e198b857556445ef4ca56e8da3246d0345155bb6765";
          size = 295140688;
        }
      )
    ];
  };

  # Image to untextured mesh, read by ComfyUI's built-in Hunyuan3D nodes.
  "3d" = {
    description = "Hunyuan3D 2.1 shape model (image -> mesh). Tencent's licence excludes the EU, UK and South Korea";
    files = [
      (
        hf "Comfy-Org/hunyuan3D_2.1_repackaged" "606def5076d38b387b005caf93b5336c56ca99f9"
          "hunyuan_3d_v2.1.safetensors"
        // {
          dir = "checkpoints";
          sha256 = "5f21e98a6cb99b13b5e224abaee33929570fff7af2b6a0060001559a04ba9d72";
          size = 7365943290;
        }
      )
    ];
  };
}

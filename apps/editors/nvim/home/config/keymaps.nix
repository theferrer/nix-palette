{
  programs.nixvim.keymaps = [

    {

      mode = "i";
      key = "jk";
      action = "<esc>";
      options = {
        silent = true;
        remap = false;
        desc = "Exit insert mode";
      };
    }
    {

      mode = "i";
      key = "kj";
      action = "<esc>";
      options = {
        silent = true;
        remap = false;
        desc = "Exit insert mode";
      };
    }

    {

      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
      options = {
        silent = true;
        desc = "Move line down";
      };
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
      options = {
        silent = true;
        desc = "Move line up";
      };
    }

    {

      mode = "x";
      key = "<leader>p";
      action = "\"_dP";
      options = {
        desc = "Paste without losing clipboard";
      };
    }
    {

      mode = [
        "n"
        "v"
      ];
      key = "<leader>y";
      action = "\"+y";
      options = {
        desc = "Yank to system clipboard";
      };
    }
    {

      mode = [
        "n"
        "v"
      ];
      key = "<leader>d";
      action = "\"_d";
      options = {
        desc = "Delete without yanking";
      };
    }

    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +2<CR>";
      options = {
        desc = "Increase window height";
      };
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -2<CR>";
      options = {
        desc = "Decrease window height";
      };
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<CR>";
      options = {
        desc = "Decrease window width";
      };
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<CR>";
      options = {
        desc = "Increase window width";
      };
    }

    {

      mode = "n";
      key = "<S-h>";
      action = "<cmd>BufferLineCyclePrev<CR>";
      options = {
        silent = true;
        desc = "Prev buffer";
      };
    }
    {

      mode = "n";
      key = "<S-l>";
      action = "<cmd>BufferLineCycleNext<CR>";
      options = {
        silent = true;
        desc = "Next buffer";
      };
    }
    {

      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLineTogglePin<CR>";
      options = {
        silent = true;
        desc = "Pin buffer";
      };
    }
    {

      mode = "n";
      key = "<leader>bP";
      action = "<cmd>BufferLineGroupClose ungrouped<CR>";
      options = {
        silent = true;
        desc = "Delete unpinned buffers";
      };
    }
    {

      mode = "n";
      key = "<leader>bd";
      action = "<cmd>bd<CR>";
      options = {
        silent = true;
        desc = "Delete buffer";
      };
    }
    {

      mode = "n";
      key = "<leader>bo";
      action = "<cmd>%bd|e#|bd#<CR>";
      options = {
        desc = "Close other buffers";
      };
    }

    {

      mode = "n";
      key = "<leader>n";
      action = "<cmd>Neotree toggle<CR>";
      options = {
        silent = true;
        desc = "Toggle file tree";
      };
    }
    {

      mode = "n";
      key = "<C-s>";
      action = "<cmd>w<CR>";
      options = {
        desc = "Save file";
      };
    }
    {

      mode = "n";
      key = "<leader>w";
      action = "<cmd>wa<CR>";
      options = {
        desc = "Save all files";
      };
    }

    {

      mode = "n";
      key = "<leader>nh";
      action = "<cmd>nohl<CR>";
      options = {
        desc = "Clear search highlights";
      };
    }
    {

      mode = "n";
      key = "<leader>rw";
      action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";
      options = {
        desc = "Replace word under cursor";
      };
    }

    {

      mode = "n";
      key = "<leader>;";
      action = "<cmd>Alpha<CR>";
      options = {
        silent = true;
        desc = "Toggle dashboard";
      };
    }
    {

      mode = "n";
      key = "<leader>qo";
      action = "<cmd>copen<CR>";
      options = {
        desc = "Open quickfix list";
      };
    }
    {
      mode = "n";
      key = "<leader>qc";
      action = "<cmd>cclose<CR>";
      options = {
        desc = "Close quickfix list";
      };
    }
    {
      mode = "n";
      key = "<leader>qn";
      action = "<cmd>cnext<CR>";
      options = {
        desc = "Next quickfix";
      };
    }
    {
      mode = "n";
      key = "<leader>qp";
      action = "<cmd>cprev<CR>";
      options = {
        desc = "Previous quickfix";
      };
    }

    {

      mode = "n";
      key = "<leader>th";
      action = "<cmd>split term://fish<CR>";
      options = {
        desc = "Horizontal terminal";
      };
    }
    {

      mode = "n";
      key = "<leader>tv";
      action = "<cmd>vsplit term://fish<CR>";
      options = {
        desc = "Vertical terminal";
      };
    }
    {

      mode = "t";
      key = "<C-\\>";
      action = "<C-\\><C-n>";
      options = {
        desc = "Exit terminal mode";
      };
    }

    {

      mode = "n";
      key = "<leader>dx";
      action = "<cmd>split term://docker exec -it app bash<CR>";
      options = {
        desc = "Docker exec app container";
      };
    }
    {

      mode = "n";
      key = "<leader>dc";
      action = "<cmd>split term://docker-compose<CR>";
      options = {
        desc = "Docker compose terminal";
      };
    }
    {

      mode = "n";
      key = "<leader>dpa";
      action = "<cmd>split term://docker exec app php artisan<CR>";
      options = {
        desc = "PHP Artisan (Laravel)";
      };
    }
    {
      mode = "n";
      key = "<leader>dpc";
      action = "<cmd>split term://docker exec app composer<CR>";
      options = {
        desc = "PHP Composer";
      };
    }
    {
      mode = "n";
      key = "<leader>dpu";
      action = "<cmd>split term://docker exec app vendor/bin/phpunit<CR>";
      options = {
        desc = "PHPUnit tests";
      };
    }
    {
      mode = "n";
      key = "<leader>dps";
      action = "<cmd>split term://docker exec app vendor/bin/phpstan analyse<CR>";
      options = {
        desc = "PHPStan analysis";
      };
    }

    {

      mode = "n";
      key = "<leader>gr";
      action = "<cmd>split term://go run .<CR>";
      options = {
        desc = "Go run";
      };
    }
    {
      mode = "n";
      key = "<leader>gt";
      action = "<cmd>split term://go test ./...<CR>";
      options = {
        desc = "Go test";
      };
    }
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>split term://go build<CR>";
      options = {
        desc = "Go build";
      };
    }

    {

      mode = "n";
      key = "gx";
      action = "<cmd>!open <cWORD><CR>";
      options = {
        silent = true;
        desc = "Open URL";
      };
    }
    {

      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
      options = {
        desc = "Half page down and center";
      };
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
      options = {
        desc = "Half page up and center";
      };
    }
    {
      mode = "n";
      key = "n";
      action = "nzzzv";
      options = {
        desc = "Next search and center";
      };
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
      options = {
        desc = "Previous search and center";
      };
    }
  ];
}

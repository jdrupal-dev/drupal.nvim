# drupal.nvim

**:warning: Archived. Check out [drupal_ls](https://github.com/jdrupal-dev/drupal_ls) which has all of the features from this plugin + much more.**

## :lock: Requirements

- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) (used for running drush)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) (currently autocompletion requires nvim-cmp)
- [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) (required for adding hook snippets)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (needs to be installed on your machine)
- [drush](https://www.drush.org/12.x) (needs to be installed on your machine/project)

## :package: Installation

Install this plugin using your favorite plugin manager, and then call
`require("drupal").setup()`.

### [lazy.nvim](https://github.com/folke/lazy.nvim)

Default configuration can be found in `lua/drupal/default_config.lua`.

```lua
{
    "jdrupal-dev/drupal.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("drupal").setup({
            services_cmp_trigger_character = "@",
            get_drush_executable = function(current_dir)
                -- You can use current_dir if you have different ways of
                -- executing drush across your Drupal projects.
                return "drush"
            end,
        })
    end
}
```
## :sparkles: Features

### Autocomplete services

You need the `devel` module installed for this feature to work.\
The `drush devel:services` command is used to get a list of all available Drupal services.

To trigger the autocompletion of services you need to input the trigger character, which by default is "@".
```php
\Drupal::service('@entity_') // Now you should see services beginning with entity_.
```
### Snippets

A few practical snippets are provided, you can find the complete list of snippets in `lua/drupal/snippets/docs.md`.

LuaSnip snippets are automatically generated for hooks when opening nvim in a Drupal project.

You can use the snippets by typing `hook_` in a `.module` or `.theme` file.
When the snippet is used `hook` will automatically get replaced with the name of the current module.

For example, typing `hook_theme + Enter` in `my_module.module` will generate the following code:
```php
<?php

/**
 * Implements hook_theme()
 */
function my_module_theme($existing, $type, $theme, $path) {
  
}
```

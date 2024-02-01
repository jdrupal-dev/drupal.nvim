# drupal.nvim

**drupal.nvim** - _a little less pain for Drupal developers daring to use neovim._

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
            end
            get_webroot = function(current_dir)
                -- You can use current_dir if you have different webroots
                -- across your Drupal projects.
                return "web"
            end
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

### Automatic autoloading of modules

Whenever you open a Drupal project, all core, contrib, and custom modules will 
be added to the PSR-4 autoloader. This allows LSPs (such as Phpactor),
to generate namespaces for classes located in a Drupal module.

This is possible thanks to the [fenetikm/autoload-drupal](https://github.com/fenetikm/autoload-drupal) composer plugin.

**How does this work?**
1. Copies of composer.json and composer.lock files are made, so that we can restore the original file.
2. `fenetikm/autoload-drupal` is being installed in the project.
3. Necessary changes are being done in the temporary `composer.json` file.
4. `composer dump-autoload` is run. This is what generates the autoloader.
5. composer.json and composer.lock are being restored. By doing this you don't need to add `fenetikm/autoload-drupal` to your project's repo.
6. Your LSP is now able to pick up the newly generated autoloader, and use it when generating namespaces in your Drupal modules.

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

# Snippets

## General snippets
The following snippets are available when the `enabled_snippets.general` option is set to true.

An **X** marks the final cursor position.

Empty docblock: `/**`
```php
/**
 * X
 */
```

Inheritdoc doc block: `ihdoc`
```php
/**
 * {@inheritdoc}
 */X
```

## Hooks
Snippets for core and contrib hooks are available when the `enabled_snippets.hooks` option is set to true.
The list of possible hooks is fetched when the module is loaded, and is cached in `/tmp/hooks.txt`.

To use the snippets simply type `hook_` followed by the name of the hook you need to implement.

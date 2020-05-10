# avram_scoped_id

An small helper to set an scoped id for the model, based on the query you set as well.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     avram_scoped_id:
       github: microgit-com/avram_scoped_id
   ```

2. Run `shards install`

3. Require the shard after requiring Avram

**If using Lucky**, require the shard in your src/shards.cr file after requiring Avram:

```
# In src/shards.cr
# Put this after `require "avram"`
require "avram_scoped_id"
```

**If not using Lucky**, require the shard after Avram:

```
# In whichever file you require your shards
# Put this after `require "avram"`
require "avram_scoped_id"
```

## Usage
Create column `scoped_id` in your model, as `Int64` - if not it will fail.

Then You add it to the operation where you want to save the new scoped id. Like `SaveArticle`.

```
class SaveArticle < Article::SaveOperation
  before_save do
    AvramScopedId.set column: scoped_id,
      query: ArticleQuery.new.team_id(team_id)
  end
end
```

**scoped_id** is hardcoded for now due to how avram is built. so for now you need to have scoped_id on column.

> Good thing to know is that variables in the query might fail due to they can be `Nil` - So use `needs` and set that in the query and if necessary with `.not_nil!`

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/microgit-com/avram_scoped_id/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Håkan Nylén](https://github.com/confact) - creator and maintainer

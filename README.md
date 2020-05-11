# avram_scoped_id

[![Build Status](https://travis-ci.org/microgit-com/avram_scoped_id.svg?branch=master)](https://travis-ci.org/microgit-com/avram_scoped_id)

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

```crystal
# In src/shards.cr
# Put this after `require "avram"`
require "avram_scoped_id"
```

**If not using Lucky**, require the shard after Avram:

```crystal
# In whichever file you require your shards
# Put this after `require "avram"`
require "avram_scoped_id"
```

## Usage
Create column `scoped_id` in your model, as `Int64`
You can call it differently if you want, just change to your column in the set method inside the `before_save` below

```crystal
class AddScopeIdToArticle::V20200510065019 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(Article) do
      add scoped_id : Int64, default: 0
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
```

> Feel free to add index on the scoped_id for faster queries later on.

Then You add it to the operation where you want to save the new scoped id. Like `SaveArticle`.

```crystal
class SaveArticle < Article::SaveOperation
  before_save do
    AvramScopedId.set column: scoped_id,
      query: ArticleQuery.new.team_id(team_id)
  end
end
```

> Good thing to know is that variables in the query might fail due to they can be `Nil` - So use `needs` and set that in the query and if necessary with `.not_nil!`

### Find scoped_id
To find by scoped id you can add method to query, like this:
```crystal
class ArticleQuery < Article::BaseQuery
  def find_scoped(scoped_id : Int64) : Article
    scoped_id(scoped_id).first
  end
end
```

Don't forget to query based on the query you used when setting the scoped_id, like `ArticleQuery.new.team_id(team_id)` when finding the Article.

So example, the whole query would be:
```crystal
ArticleQuery.new.team_id(team_id).find_scoped(1)
```

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

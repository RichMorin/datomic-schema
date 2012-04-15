# Datomic-schema

A concise shorthand for writing Datomic schemas

## Usage

To convert a shorthand schema to a Clojure-readable data structure,
just do: 

``` $ ruby parser.rb schema.txt ```

which will output a file `schema.dtm` in the same folder.

## Shorthand

The parser expects each line to contain one attribute definition.

The format for an attribute definition is a series of space-separated
words in the following order:

```
entity-name attribute-name cardinality valueType & options
```

`cardinality` may be either `one` or `many`

`valueType` may be any of the valid
[Datomic value types]("http://datomic.com/company/resources/schema").

Note that instead of writing `db.type/string` (for instance) you would
just write `string`.

Options may include zero or more of the following:

- `unique-id` or `unique-val` (corresponding to db.unique/identity | /value)
- `index`
- `fulltext`
- `isComponent`
- `noHistory`

The presence of options other than `unique-*` indicate that you want
them to appear as `true`; `unique-*` specifies a type of uniqueness.

## Why is this in Ruby?

I tried it in Clojure, first. The problem I ran into was that Clojure wants
to evaluate `#db/id[:db.part/db]` too eagerly, making it rather complicated
to build dictionaries with ID specifications programatically.

So the way this works is to just circumvent that entirely and work
only with strings, producing a file that can be converted into a valid
Clojure data structure and passed along to the DB with:

```clojure 
@(d/transact conn (read-string (slurp "schema.dtm")))
```

I think it's still simple enough to be worthwhile, and it will save a
whole bunch of typing.

You could add in docstring support. It would be less pretty, though. I
think that you might as well keep the documentation separate.

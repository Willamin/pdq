# pdq

A utility for dealing with PlainData files.

PlainData is a format focused on a plaintext description and a list of data sections each containing either more plaintext or some set of data (often in csv or similar).

## Installation

1. `$ shards build`
2. `cp bin/pdq ~/bin` (or somewhere else in your path)

## Usage

```
usage: pdq SUBCOMMAND [AGRS] FILE

subcommands:
  version         prints the pdq version
  list            lists the sections available for querying in FILE
  read NAME       prints the contents of the section NAME in FILE
  append NAME     appends STDIN to the section NAME of the FILE

```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/pdq/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Will Lewis](https://github.com/your-github-user) - creator and maintainer

# Band or person name Bayesian classifier

A simple Naive-Bayes classifier for determining if a token is likely to be a person's name, or a band name.

It generates a bayes.dat file, that can then be saved and loaded for use in an application.

At [Jammed](https://jammed.app) we use this to clean up data coming from feeds like Google Calendar, where people often enter people or band names as the event titles.

## Generating the data file

The Last.fm scraper script is written in Ruby, install Bundler then install the dependences:

```
bundle install
```

Add your own API keys as a `.env` file using the `.env.example` as a guide.

Last.fm doesn't have an 'get all bands' API, so we search for bands for names including vowels. It might be best to change this to a more exhaustive list of band names, but this is a good start.

Scraping the data takes a while, so it's best to run it and go make a cup of tea.

### Sorting & removing duplicate band names

Once the scraper script is finished, use `sort -u` to sort and unsure each line is unique.

```
cat artists.txt | sort -u > sorted_artists.txt
```

## Sourcing the name data

I acquired the names from IMDB's huge list of crew members - their data set is absolutely massive, so I've taken a 1% sample of it for our uses here, which still comes to almost 75,000 real names.

To generate your own dataset:

1. Download the names.tsv from here: https://www.imdb.com/interfaces/
1. Extract all the names from the TSV file using awk: `awk 'BEGIN{ FS=OFS="\t" }{ print $2 }' name.basics.tsv > all-names.txt`
1. Take a 1% sample of the names using awk (again): `cat all-names.txt | awk 'BEGIN {srand()} !/^$/ { if (rand() <= .01) print $0}' > sample-names.txt`
1. Sort and dedupe them: `cat sample-name.txt | sort -u > names.txt`

## Using the classifier

In your client application, load the gem omnicat

```bash
bundle add omnicat
```

To load the data file, we use a worker process, and then use it to classify names as either bands or people.

```ruby
new_hash = File.open('data/bayes.dat', "r") { |from_file|
  Marshal.load(from_file)
}

bayes_obj = OmniCat::Classifiers::Bayes.new(new_hash)
puts bayes_obj.classify('George W Bush').to_hash
=> {:band=>0.1, :person=>1.0}
```

The classifier will return a hash with the probability of the name being a band, or a person.

## License

MIT

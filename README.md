# Glutton

## URLQueue

- GenServer to capture new URLs.
- Could use URLProducer, but that's overloading what the producer should be
  doing

## URLProducer

- GenStage server to handle demand and retrieve new URLs from the queue

## Pipeline

No real need for a batch since we're limited by processing power of running
multiple chrome instances

## URLRegistry

## Scrapers

## TODO

- [ ] Ignore already processed urls
- [ ] Copy images?


## Not Covered

- Being a good netizen
  - writing about that will make the code more complicated.
- Scraping all the things. We're limiting to a limited number of sites

BOSO - Best of Stack Overflow
====

This app displays the top questions on Stack Overflow (along with their tags, author names and 1 answer).

For questions that have an accepted answer, it displays that. For those that don't, but have multiple answers, it displays the top answer.

To see a live demo, check it out here: http://boso.herokuapp.com


Getting Started
===

The first thing you need to do is to create an initializer for Serel with your Stack Exchange API Key (get it from here - https://api.stackexchange.com/).

An example looks like this:

`config/initializers/serel.rb` 

```
Serel::Base.config(:stackoverflow, 'some-API-key')
```

Setup DB & Gems
===

Run `bundle install`

Run `rake db:migrate`

Then run `rake db:seed`

---

That gives you a database with 1 question, 1 answer & 1 tag.


Getting the Top Questions from SO
===

Launch your console - `rails c`

Run `Question.update_top_questions`....which will take a long time....because it is pulling all the top questions and their answers & tags.

Run it a handful of times, much quicker
==

In `lib\question_fetcher.rb`, change the `pagesize()` value to just `1` in `self.fetch_top_questions`. i.e. change:

````ruby
def self.fetch_top_questions(page_num)
  top_questions = Serel::Question.filter(:withbody).pagesize(100).page(page_num).sort('votes').get
end
````

to 

````ruby
def self.fetch_top_questions(page_num)
  top_questions = Serel::Question.filter(:withbody).pagesize(1).page(page_num).sort('votes').get
end
````

Also at line 41 of `question.rb`, change the loop from `20.times do` to `1.time do`.


Copyright &copy; 2013 - Marc Gayle 

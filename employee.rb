require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'development.sqlite3'
)

class Employee < ActiveRecord::Base
  belongs_to :department
  has_many :reviews

  def satisfactory?
    satisfactory
  end

  def give_raise(amount)
    update(salary: self.salary + amount)
  end

  def give_raise_percent(percent)
    update(salary: self.salary * (1 + percent.to_f/100))
  end

  def give_review(review)
    reviews << review
    assess_performance
    save
  end

  def assess_performance
    good_terms = [/positive/i, /good/i, /\b(en)?courag(e[sd]?|ing)\b/i, /ease/i, /improvement/i, /quick(ly)?/i, /incredibl[ey]/i, /\bimpress[edving]?{2,3}/i]
    bad_terms = [/\broom\bfor\bimprovement/i, /\boccur(ed)?\b/i, /not/i, /\bnegative\b/i, /less/i, /\bun[a-z]?{4,9}\b/i, /\b((inter)|e|(dis))?rupt[ivnge]{0,3}\b/i]
    good_terms = Regexp.union(good_terms)
    bad_terms = Regexp.union(bad_terms)

    good_count = reviews.inject(0){ |sum, r| r.review.scan(good_terms).length}
    bad_count = reviews.inject(0){ |sum, r| r.review.scan(bad_terms).length}

    self.satisfactory = (good_count - bad_count > 0)
  end

  def self.overpaid
    total = 0
    self.all.each do |e|
      total += e.salary
    end
    average = total /self.count
    self.where(["salary > ?", average])
  end

  def self.palindromes
    self.all.select {|e| e.name == e.name.reverse}
  end

  def self.raise_all_satisfactory
    self.where(satisfactory: true).all.each {|e| e.give_raise_percent(10)}
  end

end

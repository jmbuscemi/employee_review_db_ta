require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'development.sqlite3'
)

class Department < ActiveRecord::Base
  has_many :employees

  def add_employee(employee)
    employees << employee
  end

  def total_salary
    employees.reduce(0){|sum, employee| sum + employee.salary}
  end

  def give_raise(total_amount)
    getting_raise = employees.select {|e| e.satisfactory?}
    getting_raise.each {|e| e.give_raise(total_amount / getting_raise.length)}
  end

  def move_employees(new_department)
    self.employees.each do |e|
      new_department.add_employee(e)
    end
  end

  def employee_count
    employees.count
  end

  def lowest_paid_employee
    employees.order(:salary).first
  end

  def sorted_employees
    employees.order(:name)
  end

  def self.biggest
    joins(:employees).group(:department_id).order("count(employees.id) DESC").first
  end

end

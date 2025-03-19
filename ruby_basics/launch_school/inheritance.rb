class Student
  attr_writer :grade

  attr_reader :name

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(student)
    grade > student.grade
  end

  protected

  attr_reader :grade
end

bob = Student.new('Bob', 6.8)
joe = Student.new('Joe', 9.8)

puts 'Well done!' if joe.better_grade_than?(bob)

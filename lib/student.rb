require_relative "../config/environment.rb"

class Student
 
  attr_accessor :name, :grade
  attr_reader :id
   
    def initialize(id=nil, name, grade)
      @id = id
      @name = name
      @grade = grade
    end
   
    def self.create_table
      sql =  <<-SQL
        CREATE TABLE IF NOT EXISTS students (
          id INTEGER PRIMARY KEY,
          name TEXT,
          album TEXT
          )
          SQL
      DB[:conn].execute(sql)
    end
   
    def save
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
   
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
   
    def self.create(name:, grade:)
      student = Student.new(name, grade)
      student.save
      student
    end
   
    def self.find_by_name(name)
      sql = "SELECT * FROM students WHERE name = ?"
      result = DB[:conn].execute(sql, name)[0]
      Student.new(result[0], result[1], result[2])
    end

end

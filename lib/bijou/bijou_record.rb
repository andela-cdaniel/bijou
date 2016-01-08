require "sqlite3"

module Bijou
  class BijouRecord
    @@create_table_query = []
    @@valid_parameters = []

    def initialize(params = {})
      params.reject { |k, _v| k.class == Fixnum }.each do |k, v|
        instance_variable_set "@#{k}", v if @@valid_parameters.include? k.to_sym
      end

      create_accessor_methods
    end

    def create_accessor_methods
      self.class.class_eval do
        @@valid_parameters.each do |method|
          define_method "#{method}" do
            instance_variable_get "@#{method}"
          end

          define_method "#{method}=" do |value|
            instance_variable_set "@#{method}", value
          end
        end
      end
    end

    private :create_accessor_methods

    def save
      columns = []
      values = []

      instance_variables.each do |instance|
        columns << instance.to_s.gsub("@", "")
        values << instance_variable_get(instance)
      end

      columns, values = columns.join(", "), values.map(&:to_s)

      query = "INSERT INTO #{@@table} (#{columns}) VALUES (#{values})"
      query = query.gsub("[", "").gsub("]", "").gsub("\"", "'")

      @@db.execute query
    end

    def update(params = {})
      params = params.reject { |_k, v| v.nil? }
      values = []

      params.each do |k, v|
        values << "#{k} = '#{v}'"
      end

      query = "UPDATE #{@@table} SET #{values.join(", ")} WHERE id = #{@id}"
      @@db.execute query
    end

    def delete
      query = "DELETE FROM #{@@table} WHERE id = #{@id}"
      @@db.execute query
    end

    class << self
      def create(params = {})
        new(params).save
      end

      def setup_db
        Dir.mkdir "#{PATH}/db" unless Dir.exists? "#{PATH}/db"
        File.new "#{PATH}/db/data.sqlite", "w+" unless File.exists? "#{PATH}/db/data.sqlite"

        @@db = SQLite3::Database.new File.join "#{PATH}/db/data.sqlite"
        @@db.results_as_hash = true
      end

      def table_property column_name:,
                         type:,
                         default: "",
                         unique: false,
                         primary_key: false,
                         nullable: true

        @@valid_parameters << column_name.to_sym
        query = ""

        query << "#{column_name} #{type.upcase} "

        default.to_s.length > 0 ? query << "DEFAULT #{default} " : ""
        unique ? query << "UNIQUE " : ""
        primary_key ? query << "PRIMARY KEY " : ""
        nullable ? "" : query << "NOT NULL"

        @@create_table_query << query.strip
      end

      def map_model_to_table(table_name)
        setup_db
        @@table = table_name
      end

      def create_table
        query = @@create_table_query.join(", ")
        unless query.include? "PRIMARY KEY"
          query = "id INTEGER PRIMARY KEY, " << query
          @@valid_parameters << :id
        end
        @@db.execute "CREATE TABLE IF NOT EXISTS #{@@table} (#{query})"
      end

      def drop_table
        @@db.execute "DROP TABLE IF EXISTS #{@@table}"
      end

      def all
        (@@db.execute "SELECT * FROM #{@@table}").map { |result| new result }
      end

      def find(id)
        new (@@db.execute "SELECT * FROM #{@@table} WHERE id = #{id}").first
      end

      def count
        @@db.execute "SELECT COUNT(*) FROM #{@@table}"
      end
    end
  end
end

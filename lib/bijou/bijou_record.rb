require "sqlite3"
require_relative "hash_to_obj"

module Bijou
  class BijouRecord
    @@create_table_query = []
    @@valid_parameters = []

    @@valid_parameters.each do |param|
      attr_accessor param
    end

    def initialize(params = {})
      params.each do |k, v|
        instance_variable_set "@#{k}", v if @@valid_parameters.include? k
      end
    end

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

    class << self
      def create(params = {})
        new(params).save
      end

      def setup_db
        Dir.mkdir "db" unless Dir.exists? "db"
        File.new "db/data.sqlite", "w+" unless File.exists? "db/data.sqlite"

        @@db = SQLite3::Database.new File.join "db/data.sqlite"
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

      default.to_s.length > 0 ? query << "DEFAULT #{default} " : false
      unique ? query << "UNIQUE " : false
      primary_key ? query << "PRIMARY KEY " : false
      nullable ? false : query << "NOT NULL"

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

      def all
        (@@db.execute "SELECT * FROM #{@@table}").map { |record| HashToObj.new record }
      end

      def find(id)
        HashToObj.new (@@db.execute "SELECT * FROM #{@@table} WHERE id = ?", id).first
      end

      def count
        @@db.execute "SELECT COUNT(*) FROM #{@@table}"
      end

      def table
        @@table
      end

      def db
        @@db ||= SQLite3::Database.new File.join "db/data.sqlite"
      end
    end
  end
end

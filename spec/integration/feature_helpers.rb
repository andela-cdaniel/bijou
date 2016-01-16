module FeatureHelpers
  class << self
    def populate_table_with_items(amount)
      amount.times do |n|
        Agenda.create(name: "todo#{n + 1}")
      end
    end

    def drop_and_regenerate_table
      Agenda.drop_table
      Agenda.db.execute "CREATE TABLE IF NOT EXISTS agendas
                        (id INTEGER PRIMARY KEY, name TEXT, done BOOLEAN)"
    end
  end
end

class Agenda < Bijou::BijouRecord
  map_model_to_table :agendas
  table_property column_name: :name, type: :text, nullable: false
  table_property column_name: :done, type: :boolean, default: false
  create_table
end

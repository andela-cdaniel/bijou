module Bijou
  class BijouRecord
    class HashToObj
      def initialize(hash)
        convert_hash_to_objects(hash)
      end

      def convert_hash_to_objects(hash)
        hash.reject { |k, _v| k.class == Fixnum }.each do |k, v|
          instance_variable_set "@#{k}", boolean(v)
        end
      end

      def boolean(value)
        return value unless value.class == String
        value = value.downcase if value.class == String
        if value == "true"
          true
        elsif value == "false"
          false
        else
          value
        end
      end

      def method_missing(method_name)
        instance_variable_get "@#{method_name}"
      end

      def update(params = {})
        params = params.reject { |_k, v| v.nil? }
        values = []

        params.each do |k, v|
          values << "#{k} = '#{v}'"
        end

        query = "UPDATE #{bijou_record.table} SET #{values.join(", ")} WHERE id = #{@id}"
        bijou_record.db.execute query
      end

      def delete
        query = "DELETE FROM #{bijou_record.table} WHERE id = #{@id}"
        bijou_record.db.execute query
      end

      private

      def bijou_record
        BijouRecord
      end
    end
  end
end

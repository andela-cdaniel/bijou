class ::Object
  def self.const_missing(const)
    require const.to_s.to_snake_case
    const_get(const)
  end
end

class ::String
  def to_camel_case
    split("_").map(&:capitalize!).join
  end

  def to_snake_case
    arr = split("")
    arr.each_with_index do |_c, i|
      unless arr[i + 1].nil?
        if (arr[i] == arr[i].downcase) && arr[i + 1] == arr[i + 1].upcase
          arr[i] = arr[i] << "_"
        end
      end
    end

    arr.join.downcase
  end
end

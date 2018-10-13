require 'pg'

class Datacontroller

  def initialize(id, product, customer, measure, value, valid_from, valid_to)
    @id = id
    @product = product
    @customer = customer
    @measure = measure
    @value = value
    @valid_from = valid_from
    @valid_to = valid_to
  end

  def self.get_all
    data_sets = []
    connection = PG.connect(dbname: 'product_data')
    result = connection.exec("SELECT * FROM data")
    result.each do |row|
      data_sets << Datacontroller.new(row['id'], row['product'], row['customer'], row['measure'], row['value'], row['valid_from'], row['valid_to'])
    end
    return data_sets
  end

  def self.search(product, customer, measure)
    data_sets = []
    connection = PG.connect(dbname: 'product_data')
    result = connection.exec("SELECT * FROM data WHERE product='#{product}' AND customer='#{customer}' AND measure='#{measure}' ORDER BY valid_to ASC")
    result.each do |row|
      data_sets << Datacontroller.new(row['id'], row['product'], row['customer'], row['measure'], row['value'], row['valid_from'], row['valid_to'])
    end
    return data_sets
  end

end

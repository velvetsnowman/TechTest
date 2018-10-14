require 'pg'

class Datacontroller

  attr_reader :id,
              :product,
              :customer,
              :measure,
              :value,
              :valid_from,
              :valid_to

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
    connection = PG.connect(dbname: 'product_data')
    result = connection.exec("SELECT * FROM data ORDER BY id ASC")
    result.map { |row| Datacontroller.new(row['id'],
                                          row['product'],
                                          row['customer'],
                                          row['measure'],
                                          row['value'],
                                          row['valid_from'],
                                          row['valid_to'])}
  end

  def self.search(product, customer, measure)
    @product = product
    @customer = customer
    @measure = measure
    connection = PG.connect(dbname: 'product_data')
    result = connection.exec("SELECT * FROM data WHERE
                              product='#{product}'
                              AND customer='#{customer}'
                              AND measure='#{measure}'
                              ORDER BY valid_from ASC")
    result.map { |row| Datacontroller.new(row['id'],
                                          row['product'],
                                          row['customer'],
                                          row['measure'],
                                          row['value'],
                                          row['valid_from'],
                                          row['valid_to'])}
  end

  def self.check_errors
    @data_set = []
    connection = PG.connect(dbname: 'product_data')
    result = connection.exec("SELECT id, valid_from, valid_to FROM data WHERE
                              product='#{@product}'
                              AND customer='#{@customer}'
                              AND measure='#{@measure}'
                              ORDER BY valid_from ASC")
    result.map { |row| @data_set << row }
    i = 1
    while @data_set.length > i do
      if (DateTime.parse(@data_set[i-1]["valid_from"])..DateTime.parse(@data_set[i-1]["valid_to"])).cover?(DateTime.parse(@data_set[i]["valid_from"]))
        x = (DateTime.parse(@data_set[i]["valid_from"]) -1).strftime('%Y-%m-%d')
        y = @data_set[i-1]["id"]
        connection.exec("UPDATE data
                        SET valid_to = '#{x}'
                        WHERE id= #{y}")
      end
      i += 1
    end
  end

end

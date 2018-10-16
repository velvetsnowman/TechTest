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

  def self.check_searched_errors
    data_set = []
    connection = PG.connect(dbname: 'product_data')
    result = connection.exec("SELECT id, valid_from, valid_to FROM data WHERE
                              product='#{@product}'
                              AND customer='#{@customer}'
                              AND measure='#{@measure}'
                              ORDER BY valid_from ASC")
    result.map { |row| data_set << row }
    i = 1
    while data_set.length > i do
      if (DateTime.parse(data_set[i-1]["valid_from"])..DateTime.parse(data_set[i-1]["valid_to"])).cover?(DateTime.parse(data_set[i]["valid_from"]))

        new_valid_to = (DateTime.parse(data_set[i]["valid_from"]) -1).strftime('%Y%m%d')
        original_valid_to = (DateTime.parse(data_set[i-1]["valid_to"])).strftime('%Y%m%d')
        time_now = (Time.now).strftime("%Y%m%d")
        row_id = data_set[i-1]["id"]
        connection.exec("UPDATE data
                        SET valid_to = '#{new_valid_to}',
                        original_valid_to = '#{original_valid_to}',
                        time_updated = '#{time_now}'
                        WHERE id= #{row_id}")
      end
      i += 1
    end
  end

  def self.check_all_errors #here
    data_set = []
    connection = PG.connect(dbname: 'product_data')
    result = connection.exec("SELECT * FROM data
                              ORDER BY customer ASC,
                              product ASC,
                              measure ASC,
                              valid_from ASC")
    result.map { |row| data_set << row }
    i = 1
    while data_set.length > i do
      if data_set[i]["product"] == data_set[i-1]["product"] &&
        data_set[i]["customer"] == data_set[i-1]["customer"] &&
        data_set[i]["measure"] == data_set[i-1]["measure"] &&
        (DateTime.parse(data_set[i-1]["valid_from"])..DateTime.parse(data_set[i-1]["valid_to"])).cover?(DateTime.parse(data_set[i]["valid_from"]))

        original_valid_to = (DateTime.parse(data_set[i-1]["valid_to"])).strftime('%Y%m%d')
        new_valid_to = (DateTime.parse(data_set[i]["valid_from"]) -1).strftime('%Y%m%d')
        time_now = (Time.now).strftime("%Y%m%d")
        row_id = data_set[i-1]["id"]
        connection.exec("UPDATE data
                        SET valid_to = '#{new_valid_to}',
                        original_valid_to = '#{original_valid_to}'
                        time_updated = '#{time_now}'
                        WHERE id= #{row_id}")
      end
      i += 1
    end
  end

end

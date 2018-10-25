require 'pg'

class DatabaseCreator

  def self.create_database
    connection = PG.connect(dbname: 'postgres')
    connection.exec('CREATE DATABASE clients')
  end

  def self.create_table
    connection = PG.connect(dbname: 'clients')
    connection.exec('CREATE TABLE client_details (
                    Company_ID int,
                    Company_Name varchar,
                    Company_Telephone varchar,
                    Company_Representitive varchar,
                    Company_Email varchar,
                    Company_Address varchar,
                    Company_Contract_Start_Date varchar,
                    Company_Contract_End_Date varchar
                    )')
    connection = PG.connect(dbname: 'clients')
    connection.exec('CREATE TABLE orders_summary (
                    Company_ID int,
                    Summary_ID int,
                    Company_Name varchar,
                    Number_Of_Orders int,
                    Total_Revenue int,
                    Company_Telephone varchar,
                    Company_Email varchar,
                    )')
  end
end
DatabaseCreator.create_database
DatabaseCreator.create_table

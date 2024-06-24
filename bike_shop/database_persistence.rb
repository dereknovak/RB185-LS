require 'pg'

class DatabasePersistence
  def initialize(logger)
    @db = if Sinatra::Base.production?
            PG.connect(ENV['DATABASE_URL'])
          else
            PG.connect(dbname: 'bike_shop')
          end
    @logger = logger
  end

  def query(statement, *params)
    @logger.info "#{statement}: #{params}"
    @db.exec_params(statement, params)
  end

  def find_customer(value)
    customer_attributes = ['first_name', 'last_name', 'phone_number', 'email_address']
    sql = 'SELECT id FROM customers WHERE $1 = $2'
    
    customer_attributes.each do |attribute|
      result = query(sql, attribute, value).empty?
      next if result.empty?
      return result.first
    end
  end
end
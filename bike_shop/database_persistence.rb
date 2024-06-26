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

  def load_pricing
    sql = 'SELECT * FROM services'
    query(sql)
  end

  def find_customers(params)
    params.select! do |_, value|
      !value.empty?
    end

    return [] if params.empty?

    customers = query('SELECT * FROM customers;')

    customers = customers.select do |customer|
      params.all? do |attribute, value|
        customer[attribute].downcase == value.downcase
      end
    end

    customers
  end

  def load_customer_info(id, attribute)
    case attribute
    when 'customer'
      sql = 'SELECT * FROM customers WHERE id = $1'
    when 'workorder'
      sql = <<~SQL
        SELECT customers.* FROM customers
          JOIN bicycles ON customer_id = customers.id
          JOIN workorders ON bicycle_id = bicycles.id
         WHERE workorders.id = $1;
      SQL
    end

    query(sql, id).first
  end

  def load_customer_bicycles(customer_id)
    sql = <<~SQL
      SELECT bicycles.* FROM bicycles
        JOIN customers ON customer_id = customers.id
       WHERE customers.id = $1;
    SQL

    query(sql, customer_id)
  end

  def load_bicycle_info(workorder_number)
    sql = <<~SQL
      SELECT DISTINCT bicycles.* FROM bicycles
        JOIN workorders ON bicycle_id = bicycles.id
       WHERE workorders.id = $1;
    SQL

    query(sql, workorder_number).first
  end

  def load_workorders
    sql = <<~SQL
      SELECT workorders.id,
             make || ' ' || model AS bicycle_name,
             first_name || ' ' || last_name AS full_name,
             start_date,
             completed
        FROM workorders
        JOIN bicycles ON bicycle_id = bicycles.id
        JOIN customers ON customer_id = customers.id
       ORDER BY completed, workorders.id;
    SQL

    query(sql)
  end

  def load_customer_workorders(customer_id)
    sql = <<~SQL
      SELECT workorders.id,
             make || ' ' || model AS bicycle,
             start_date
        FROM workorders
        JOIN bicycles ON bicycle_id = bicycles.id
        JOIN customers ON customer_id = customers.id
       WHERE customers.id = $1;
    SQL

    query(sql, customer_id)
  end

  def load_workorder_info(workorder_number)
    sql = 'SELECT * FROM workorders WHERE id = $1'
    query(sql, workorder_number).first
  end

  def load_services(workorder_number)
    sql = <<~SQL
      SELECT name, price
        FROM services
        JOIN workorder_services ON service_id = services.id
       WHERE workorder_id = $1;
    SQL

    query(sql, workorder_number)
  end

  def add_customer(params)
    sql = <<~SQL
      INSERT INTO customers
      VALUES (DEFAULT, $1, $2, $3, $4);
    SQL

    query(sql, params['first_name'],
               params['last_name'],
               params['phone_number'],
               params['email_address'])
  end

  def add_bicycle(params)
    sql = <<~SQL
      INSERT INTO bicycles
      VALUES (DEFAULT, $1, $2, $3, $4, $5);
    SQL

    query(sql, params['serial_number'],
               params['make'],
               params['model'],
               params['color'],
               params['customer_id'].to_i)
  end

  def add_workorder(bicycle_id)
    sql = <<~SQL
      INSERT INTO workorders (bicycle_id)
      VALUES ($1);
    SQL

    query(sql, bicycle_id)
  end

  def add_service(params)
    sql = <<~SQL
      INSERT INTO workorder_services
      VALUES (DEFAULT, $1, $2);
    SQL

    query(sql, params['workorder_number'], params['service'])
  end

  def load_last_workorder
    sql = <<~SQL
      SELECT id FROM workorders
       ORDER BY id DESC
       LIMIT 1;
    SQL

    query(sql).first['id']
  end

  def complete_workorder(workorder_number)
    sql = <<~SQL
      UPDATE workorders
         SET completed = true
       WHERE id = $1;
    SQL

    query(sql, workorder_number)
  end
end


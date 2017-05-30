class Route < ActiveRecord::Base
  has_many(
    :buses,
    class_name: "Bus",
    foreign_key: :route_id,
    primary_key: :id
  )

  def n_plus_one_drivers
    buses = self.buses

    all_drivers = {}
    buses.each do |bus|
      drivers = []
      bus.drivers.each do |driver|
        drivers << driver.name
      end
      all_drivers[bus.id] = drivers
    end

    all_drivers
  end

  def better_drivers_query
    buses_n_drivers = self
      .buses
      .select("buses.id, drivers.name")
      .joins(:drivers)
      .order("buses.id")

    all_drivers = {}
    buses_n_drivers.map do |bus_n_driver|
      if all_drivers[bus_n_driver.id]
        all_drivers[bus_n_driver.id] << bus_n_driver.name
      else
        all_drivers[bus_n_driver.id] = [bus_n_driver.name]
      end
    end

    all_drivers
  end

  # def better_drivers_query
  #   buses = self.buses.includes(:drivers)
  #
  #   all_drivers = {}
  #   buses.each do |bus|
  #     drivers = []
  #     bus.drivers.each do |driver|
  #       drivers << driver.name
  #     end
  #     all_drivers[bus.id] = drivers
  #   end
  #
  #   all_drivers
  # end
end

module Users
  class CreateOperation
    include Dry::Transaction(container: Fundamenthus::Container)

    map :do_it

    def do_it
      :ok
    end
  end
end

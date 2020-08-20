class CollectWorker < ApplicationJob
  queue_as :source

  def perform
    input = { source_names: ['b3', 'status_invest', 'fundamentos'], storage_names: ['google_sheets', 'mongo_db'] }
    operation.call(input)
  end

  def operation
    @operation ||= SourceOperation.new
  end
end

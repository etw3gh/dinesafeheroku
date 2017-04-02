# Instead of calling the DB every time a route is accessed,
# Store the statuses array in a variable

Rails.application.config.statuses = Inspection.order(:status).distinct.pluck(:status).push('all')
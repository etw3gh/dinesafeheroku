# Instead of calling the DB every time a route is accessed,
# Store the statuses array in a variable
# add type 'all' to retrieved array
#Rails.application.config.statuses = Inspection.distinct.pluck(:status).push('all')
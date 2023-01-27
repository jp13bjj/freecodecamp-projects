def add_time(start, duration, day = ''):
  # Initalizing variables
  days_of_week = ['monday','tuesday','wednesday','thursday','friday','saturday','sunday']
  days_past = 0
  input_date,input_merid = start.split()
  input_hour,input_minute = input_date.split(':')
  duration_hour,duration_minute = duration.split(':')
  # Converting variable types
  input_hour = int(input_hour)
  input_minute = int(input_minute)
  duration_hour = int(duration_hour)
  duration_minute = int(duration_minute)
  # Formatting days and hours
  if day != '':
    day = day.lower()
  if input_merid == 'PM':
    input_hour += 12
    
  # Calculate time difference
  calc_minute = input_minute + duration_minute
  if calc_minute >= 60:
    calc_minute -= 60
    calc_hour = input_hour + duration_hour + 1
  else:
    calc_hour = input_hour + duration_hour

  while calc_hour / 24 >= 1:
    calc_hour -= 24
    days_past += 1

  # Calculate meridian
  if calc_hour < 12:
    display_merid = "AM"
  elif calc_hour >= 12:
    calc_hour -= 12
    display_merid = "PM"
  if calc_hour == 0:
    calc_hour = 12

  # Display output time
  display_hour = str(calc_hour)
  display_minute = str(calc_minute).zfill(2)

  # Calculate day of the week
  if day == '':
    display_week_day = ''
  elif day in days_of_week:
    input_day_pos = days_of_week.index(day)
    days_past_during_week = days_past % 7
    if input_day_pos + days_past_during_week <= 6:
      display_week_day = days_of_week[input_day_pos+days_past_during_week]
    else:
      display_week_day = days_of_week[input_day_pos+days_past_during_week-7]

  # Structuring output
  display_week_day = display_week_day.capitalize()
  new_time = display_hour+':'+display_minute+' '+display_merid
  if day != '':
    new_time += ', '+display_week_day
  if days_past == 1:
    new_time += ' (next day)'
  if days_past > 1:
    new_time += f' ({days_past} days later)'
    
  # Return output
  return new_time
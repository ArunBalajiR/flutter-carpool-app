
convertTimeTo12Hour(time24) {
  // time24=time24.substring(1,time24.length-1);
  var time2=time24.split('(');
  time2=time2[1].split(')');
  time24=time2[0];
  var time = time24.split(':');
  var hours = int.parse(time[0]);
  var mins = int.parse(time[1]);
  var amOrPm = 'AM';
  if (hours > 12) {
    hours = hours - 12;
    amOrPm = 'PM';
  }
  //Converting to string
  var shours = hours.toString();
  var smins = mins.toString();
  if (shours.length == 1) shours = '0' + shours;
  if (smins.length == 1) smins = '0' + smins;
  //Checking 12 AM & PM
  if (hours == 0) {
    shours = '12';
    amOrPm = 'AM';
  } else if (hours == 12) {
    amOrPm = 'PM';
  }
  var time12 = shours.toString() + ':' + smins.toString() + ' ' + amOrPm;
  return time12;
}
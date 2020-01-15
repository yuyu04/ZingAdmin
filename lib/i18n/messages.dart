import 'package:intl/intl.dart';

class Messages {
  String get entrance => Intl.message("entrance",
      name: "entrance"
  );

  String get cancle => Intl.message("cancle",
      name: "cancle"
  );

  String get waitingTeam => Intl.message("waiting team",
    name: "waitingTeam"
  );

  String get team => Intl.message("team",
    name: "team"
  );

  String get waitingTime => Intl.message("waiting time",
    name: "waitingTime"
  );

  String get minute => Intl.message("minute",
    name: "minute"
  );
}
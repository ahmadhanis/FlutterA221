class MyDevice {
  String? devicename,
      mode,
      dtupdate,
      time1,
      time2,
      time3,
      time4,
      time5,
      temp,
      relay,
      timeupdate,
      humidity;

  MyDevice(
      {this.devicename,
      this.mode,
      this.dtupdate,
      this.time1,
      this.time2,
      this.time3,
      this.time4,
      this.time5,
      this.temp,
      this.humidity,
      this.timeupdate,
      this.relay});

  MyDevice.fromJson(Map<String, dynamic> json) {
    devicename = json["devicename"];
    mode = json["mode"];
    dtupdate = json["dtupdate"];
    time1 = json["time1"];
    time2 = json["time2"];
    time3 = json["time3"];
    time4 = json["time4"];
    time5 = json["time5"];
    temp = json["temp"];
    humidity = json["humidity"];
    timeupdate = json["timeupdate"];
    relay = json["relay"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['devicename'] = devicename;
    data['mode'] = mode;
    data['humidity'] = humidity;
    data['timeupdate'] = timeupdate;
    data['relay'] = relay;
    data['time1'] = time1;
    data['time2'] = time2;
    data['time3'] = time3;
    data['time4'] = time4;
    data['time5'] = time5;
    data['dtupdate'] = dtupdate;
    data['temp'] = temp;

    return data;
  }
}

Date.prototype.diffDays = function(compareDate, type) {
	if (type == "d") {
		return parseInt((this.getTime()-compareDate.getTime())/(24*3600*1000));
	} else if (type == "w") {
		return parseInt((this.getTime()-compareDate.getTime())/(24*3600*1000*7));
	} else if (type == "m") {
		return (this.getMonth()+12*this.getFullYear())-(compareDate.getMonth()+12*compareDate.getFullYear());
	} else if (type == "y") {
		return this.getFullYear()-compareDate.getFullYear();
	}
};

Date.prototype.addDate = function(type, value) {
	if (type == "d") {
		this.setDate(this.getDate() + value);
	} else if (type == "w") {
		this.setTime(Date.parse(this) + (parseInt(value)*1000*60*60*24*7));
	} else if (type == "m") {
		this.setMonth(this.getMonth() + value);
	} else if (type == "y") {
		this.setFullYear(this.getFullYear() + value);
	}
};

Date.prototype.addTime = function(type, value) {
	if (type == "ss") {
		this.setTime(this.getTime() + parseInt(value)*1000);
	} else if (type == "mm") {
		this.setTime(this.getTime() + parseInt(value)*1000*60);
	} else if (type == "hh") {
		this.setTime(this.getTime() + parseInt(value)*1000*60*60);
	}
};

Date.prototype.formatString = function(format) {
	var year, month, day, hours, minutes, seconds;
	year = String(this.getFullYear());
	month = String(this.getMonth() + 1);
	if (month.length == 1)
		month = "0" + month;
	day = String(this.getDate());
	if (day.length == 1)
		day = "0" + day;
	hours = String(this.getHours());
	if (hours.length == 1)
		hours = "0" + hours;
	minutes = String(this.getMinutes());
	if (minutes.length == 1)
		minutes = "0" + minutes;
	seconds = String(this.getSeconds());
	if (seconds.length == 1)
		seconds = "0" + seconds;

	if (format == "yyyy-MM-dd")
		return year + "-" + month + "-" + day;
	else if (format == "yyyy-MM")
		return year + "-" + month;
	else if (format == "yyyyMMdd")
		return year + month + day;
	else if (format == "MM/dd/yyyy")
		return month + "/" + day + "/" + year;
	else if (format == "hh:mm:ss")
		return hours + ":" + minutes + ":" + seconds;
	else if (format == "hhmmss")
		return hours + minutes + seconds;
	else if (format == "yyyyMMddhhmmss")
		return year + month + day + hours + minutes + seconds;
	else
		return year + "-" + month + "-" + day + " " + hours + ":" + minutes + ":" + seconds;
};
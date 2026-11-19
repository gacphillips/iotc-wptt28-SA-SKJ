month2qrt = function(month) {
    qrt = floor((month-1)/3) + 1
}
yearqtr2numeric = function(year, qtr) {
	yearqtr = year + (qtr-1)/4+1/8
}
yearmonth2yearqrt = function (year,month) {
	yearqrt = year + (floor((month-1)/3))/4+1/8
}
yearqtr2qtr = function(year,qtr,initial,base) {
	qtr = (base-1)+4*(year-initial)+qtr
}

qtr2yearqtr = function(qtr,initial,base) {
	yearqtr = (qtr-base)/4+initial+1/8
}


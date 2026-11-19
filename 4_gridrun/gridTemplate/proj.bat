cp Starter.SSnoest starter.ss
cp ../ss.par ss.par

rm forecast.ss
cp Forecastc1.0.SS forecast.ss
ss_win -maxfn 10 -phase 10 -nohess -ams 1000000000 -cbs 1000000000 -gbs 1000000000 %1 %2 %3 %4
cp Report.sso Reportc1.0.sso
cp CompReport.sso CompReportc1.0.sso
cp Forecast-report.sso Forecast-reportc1.0.sso

rm forecast.ss
cp Forecastc0.6.SS forecast.ss
ss3_win -maxfn 10 -phase 10 -nohess -ams 1000000000 -cbs 1000000000 -gbs 1000000000 %1 %2 %3 %4
cp Report.sso Reportc0.6.sso
cp CompReport.sso CompReportc0.6.sso
cp Forecast-report.sso Forecast-reportc0.6.sso

rm forecast.ss
cp Forecastc0.8.SS forecast.ss
ss3_win -maxfn 10 -phase 10 -nohess -ams 1000000000 -cbs 1000000000 -gbs 1000000000 %1 %2 %3 %4
cp Report.sso Reportc0.8.sso
cp CompReport.sso CompReportc0.8.sso
cp Forecast-report.sso Forecast-reportc0.8.sso

rm forecast.ss
cp Forecastc1.2.SS forecast.ss
ss3_win -maxfn 10 -phase 10 -nohess -ams 1000000000 -cbs 1000000000 -gbs 1000000000 %1 %2 %3 %4
cp Report.sso Reportc1.2.sso
cp CompReport.sso CompReportc1.2.sso
cp Forecast-report.sso Forecast-reportc1.2.sso

rm forecast.ss
cp Forecastc1.4.SS forecast.ss
ss3_win -maxfn 10 -phase 10 -nohess -ams 1000000000 -cbs 1000000000 -gbs 1000000000 %1 %2 %3 %4
cp Report.sso Reportc1.4.sso
cp CompReport.sso CompReportc1.4.sso
cp Forecast-report.sso Forecast-reportc1.4.sso

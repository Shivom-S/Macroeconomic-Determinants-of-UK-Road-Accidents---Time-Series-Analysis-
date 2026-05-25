clear all
import excel "C:\Users\Shivom Srivastava\OneDrive\Desktop\Ashoka master folder\Ashoka Sem 6\ForecastingandAnalysis\Final Paper\Consolidated data set 1997-2024 monthly road accidents.xlsx", sheet("Sheet1") firstrow case(lower) clear


*Time variable*
gen modate = monthly(yearmonth, "YM")
format modate %tm
tsset modate
gen inf = D.cpi

*Unit root tests*
dfuller inf
dfuller tot_petrol
dfuller totalaccidents
dfuller car_reg
dfuller	tot_diesel
dfuller fuelprices
dfuller unemployment
dfuller gdp

*First differencing the unit root variables
gen d_gdp = D.gdp
gen d_unemp = D.unemployment
gen d_gas = D.fuelprices
gen d_petrol = D.tot_petrol
gen d_acc = D.totalaccidents



*Stability tests to confirm*
dfuller inf
dfuller d_petrol
dfuller d_acc
dfuller car_reg
dfuller	tot_diesel
dfuller d_gas
dfuller d_unemp
dfuller d_gdp


* Test the data for structural breaks in both intercept and trend*
zandrews d_acc, break(both) maxlags(4)

zandrews inf, break(both) maxlags(4)

zandrews d_gdp, break(both) maxlags(4)

zandrews d_gas, break(both) maxlags(4)

zandrews d_unemp, break(both) maxlags(4)

zandrews d_petrol, break(both) maxlags(4)

zandrews tot_diesel, break(both) maxlags(4)

zandrews car_reg, break(both) maxlags(4)

*   
* ZIVOT-ANDREWS STRUCTURAL BREAK DUMMIES
* Generated from identified break dates
*   

gen fin_crisis = (modate >= ym(2008, 9))

gen covid = (modate >= ym(2020, 4) & modate <= ym(2021, 12))

gen break_unemp = (modate >= ym(2011, 10))

gen brexit = (modate >= ym(2016, 6))
*   
* CHECKING CORRELATION
*   

correlate covid break_unemp fin_crisis brexit

* Graph to visualise breaks
twoway (line d_acc modate, lcolor(navy)), ///
    xline(`=ym(2020,4)',  lcolor(red)    lpattern(dash)) ///   // Lockdown 
	xline(`=ym(2020,9)',  lcolor(red)    lpattern(dash)) ///   // Petrol 
    xline(`=ym(2011,10)',  lcolor(green)  lpattern(dash)) ///   // Gas crisis
    xline(`=ym(2008,9)',  lcolor(green)  lpattern(dash)) ///   // Core inflation shock
    xline(`=ym(2016,2)', lcolor(green)  lpattern(dash)) ///   // GDP shift
    title("UK Road Accidents with All Structural Breaks") ///
    subtitle("Red = COVID shocks | Green = macroeconomic breaks") ///
    ytitle("Number of Accidents") xtitle("Date")
	
*   
* ARDL SPECIFICATION
*First difference*
ardl d_acc tot_diesel car_reg inf d_gdp d_unemp d_gas d_petrol, exog(covid fin_crisis) maxcombs(400000) ec
estat ic
estat bgodfrey, lags(4)
estat imtest, white
estat btest

cusum6 d_acc tot_diesel car_reg inf d_gdp d_unemp d_gas d_petrol, lw(lower) uw(upper)
	

predict accidents_fitted, xb
*At level*
ardl d_acc tot_diesel car_reg inf gdp unemployment fuelprices tot_petrol, exog(covid fin_crisis) maxcombs(400000) ec

estat ic
estat bgodfrey, lags(4)
estat imtest, white
estat btest

* 2. Graph the real data vs. model's predictions
twoway (line d_acc modate, lcolor(black) lpattern(solid)) ///
       (line accidents_fitted modate, lcolor(blue) lpattern(dash)), ///
       legend(order(1 "Actual Accidents" 2 "ARDL Predicted")) ///
       title("Actual vs. Predicted UK Road Accidents")

*Residual predictions
predict ardl_resid, residuals

* Standardise and cumulate
quietly sum ardl_resid
gen resid_std  = ardl_resid / r(sd)
gen cusum_stat = sum(resid_std)
gen obs        = _n

* CUSUM residual Plot
twoway ///
    (line lower    obs, lcolor(red)  lpattern(dash) lwidth(medium)) ///
    (line upper    obs, lcolor(red)  lpattern(dash) lwidth(medium)) ///
    (line cusum_stat obs, lcolor(navy) lwidth(medium)), ///
    yline(0, lcolor(gray) lpattern(dot)) ///
    legend(order(1 "5% critical bounds" 3 "CUSUM statistic")) ///
    title("CUSUM Parameter Stability Test") ///
    subtitle("Stability rejected if CUSUM crosses red bounds") ///
    xtitle("Observation") ytitle("CUSUM")


*VAR testing*

foreach var of varlist d_acc tot_diesel car_reg inf d_gdp d_unemp d_gas d_petrol {
    quietly regress `var' covid fin_crisis
    predict `var'_r, residuals
}


*RUNNING VARSOC ON THE CLEANED RESIDUALS


varsoc d_acc_r tot_diesel_r car_reg_r inf_r d_gdp_r d_unemp_r d_gas_r d_petrol_r, maxlag(8)
	   
var d_acc tot_diesel car_reg inf d_gdp d_unemp d_gas d_petrol, ///
    lags(1/8) exog(covid fin_crisis)


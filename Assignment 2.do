clear all
* Installing "getsymbols"
ssc install getsymbols
* TSCO.L = Tesco PLC
getsymbols TSCO.L, yahoo fy(2003) ly(2013)
gen time=_n
format time
gen close=adjclose_TSCO_L

*******************************************************************************

* 1. Describing the data by finding the stock return

* Graphs
tsline close /* not stationary*/

* Correlogram
corrgram close
ac close
pac close

* Generating the first and second log as "Returns"
gen l_close=ln(close)
gen dl_close=d.l_close

* Checking its stationarity
dfuller dl_close

* Graphs
tsline dl_close /* stationary*/

* Correlogram
corrgram dl_close
ac dl_close
pac dl_close

*******************************************************************************

* 2. Building ARIMA model USING "dl_close" model
*ARMA(1,1)
arima dl_close, arima(1,0,1)
estat ic
predict u, resid
corrgram u 
ac u

*******************************************************************************

* 3. ARCH & GARCH

******************************************
* ARCH Effects
******************************************
* Automatic test in Stata for ARCH effects in the residuals
reg dl_close l.dl_close
estat archlm, lags(1)

* Automatic test in Stata for higher order ARCH effects in the residuals: ARCH(6)
reg dl_close l.dl_close
estat archlm, lags(1/2)

******************************************
*ARCH Model
******************************************

arch dl_close l.dl_close, arch(1)
predict h_arch1, variance
tsline h_arch1

********************************************
* GARCH Model
********************************************

arch dl_close l.dl_close, arch(1) garch(1)
predict h_garch11, variance
tsline h_garch11

tsline h_arch1 h_garch11




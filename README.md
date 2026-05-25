# Macroeconomic-Determinants-of-UK-Road-Accidents---Time-Series-Analysis

**Course:** Economic Forecasting and Analysis
**Advisor:** Professor Piyali Banerjee
**Tools:** Stata, R, Time Series Analysis, Econometrics

## Overview
Analysed the effect of macroeconomic distress on road accidents in the UK
using 336 monthly observations spanning 27 years (1997-2024). Built an
ARDL-ECM model to estimate both short-run dynamics and long-run relationships
between road accidents and key macroeconomic indicators.

## Key Variables
- **Dependent:** Total monthly road accidents
- **Macroeconomic:** GDP growth, unemployment, inflation, fuel prices
- **Controls:** New car registrations, petrol consumption, diesel consumption

## Methodology
- Validated stationarity using Dickey-Fuller tests
- Detected structural breaks using Zivot-Andrews tests
- Benchmarked ARDL-ECM against VAR model
- Selected optimal specification using AIC, BIC, Breusch-Godfrey, and White's tests
- Confirmed long-run equilibrium via Pesaran bounds testing
- Validated parameter stability through CUSUM residual plots

## Key Findings
- Unemployment and inflation are the strongest long-run drivers of road accidents
- Short-run economic shocks show a counterintuitive suppression effect
- The 2008 Financial Crisis independently elevated accident rates beyond what macro variables explained
- COVID-19 effects were fully absorbed by underlying macroeconomic variables
- Model achieved R-squared of 0.81

## Files
- `Consolidated data set 1997-2004 monthly road accidents.xlsx` - fully complied dataset of macroeconomic variables
- `Macro_Indicators_Analysis.do` - full modelling and econometric pipeline in Stata
- `ECO-3402_FinalPaper.pdf` - final written paper

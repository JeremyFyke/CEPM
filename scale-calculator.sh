#!/bin/bash

cdo yearmean -cat '../CO2-em-anthro*.nc' tmp1.nc
cdo fldsum -mul tmp1.nc -gridarea tmp1.nc tmp2.nc
ncap2 -O -s 'emissions = CO2_em_anthro.total($sector)' tmp2.nc tmp3.nc
ncap2 -O -s 'emissions_scaled=emissions*31557600.' tmp3.nc tmp3.nc #seconds to years
ncap2 -O -s 'emissions_scaled=emissions/44.*12.' tmp3.nc tmp3.nc #CO2 to C
ncap2 -O -s 'emissions_scaled=emissions/1.e3' tmp3.nc tmp3.nc #kg to t
ncap2 -O -s 'emissions_scaled=emissions/1.e12' tmp3.nc tmp3.nc #t to Tt


#seconds to years
#CO2 to C
#kg to teratons
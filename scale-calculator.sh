#!/bin/bash

fin=../CO2-em-anthro_input4MIPs_emissions_CMIP_CEDS-2017-05-18_gn_200001-201412.nc

cdo -O yearmean $fin tmp1.nc
cdo -O fldsum -mul tmp1.nc -gridarea tmp1.nc tmp2.nc
ncap2 -O -s 'emissions = CO2_em_anthro.total($sector)' tmp2.nc tmp3.nc
ncap2 -O -s 'emissions=emissions*31557600.' tmp3.nc tmp3.nc #seconds to years
ncap2 -O -s 'emissions=emissions/44.*12.' tmp3.nc tmp3.nc #CO2 to C
ncap2 -O -s 'emissions=emissions/1.e3' tmp3.nc tmp3.nc #kg to t
ncap2 -O -s 'emissions=emissions/1.e12' tmp3.nc CMIP6_emissions.nc #t to Tt

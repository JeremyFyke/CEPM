import h5py
import numpy as np
import matplotlib.pyplot as plt
import xarray as xr
import datetime as dt

ntot=100#total years to save to record

plt.switch_backend('agg')
f=h5py.File('output/future_projection_output.mat','r')
emissions=f['emis_arr']
#plev=np.linspace(1,100,100)

plev=50.
p=np.transpose(np.nanpercentile(emissions,plev,axis=1))
p=np.squeeze(p)
p=p*1.e12 #Tt C/yr -> T C/yr
p=p*1.0e3 #T C/yr -> kg C/yr
p=p*44./12. #kg C/yr -> kg CO2/yr
p=p/31557600.#kg CO2/yr -> kg CO2/sec, assuming a noleap calendar (365 days)
p=p/510.e12 #kg CO2/s -> kg CO2/m^2/s
nt=len(p)

daysPerYear=365.#noleap
halfYear=daysPerYear/2.
ts=31. + (2011.-1850.+1.)*daysPerYear + halfYear #in
time=np.array([i*365 for i in range(nt)]) + ts

plt.plot(time[0:ntot],p[0:ntot])
#plt.legend(plev)
#plt.fill_between(time,p[:,9],p[:,89],label="10-90% range")
#plt.fill_between(time,p[:,32],p[:,65],label="33-66% range")
#plt.plot(time,p[:,49],'k',label="50th percentile")
#plt.xlim(2015,2100)
#plt.legend()
#plt.xlabel("years")
#plt.ylabel("C emissions (Gt/yr)")
prefix=str(plev)+"_timeseries"
plt.savefig(prefix+".png",dpi=300)

f=prefix+".nc"
da=xr.DataArray(p[0:ntot],name="CO2",
        attrs={"units":"kg m-2 s-1"},
        coords=[time[0:ntot]],
        dims="time")
da.time.attrs["calendar"]="noleap"
da.time.attrs["units"]="days since 1849-12-01"
da.to_netcdf(f)
da.close()

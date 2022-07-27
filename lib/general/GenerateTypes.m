DBL = 1;
if gpuDeviceCount && GPU
	DBL = gpuArray(DBL);
else
	GPU = false;
end
SNGL = single(DBL);

if GPU
	FLT = SNGL;
else
	FLT = DBL;
end	
CMPLX = complex(FLT);
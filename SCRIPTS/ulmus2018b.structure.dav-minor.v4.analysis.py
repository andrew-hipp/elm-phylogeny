import ipyrad.analysis as ipa
import ipyparallel as ipp
import toyplot

# in separate window:
# ipcluster start
# then, after that is running:

ipyclient = ipp.Client()

s = ipa.structure(
	name="udm50",
	workdir="./udm_v4",
	data="ulmus2018b_dav_min_v3_outfiles/ulmus2018b_dav_min_v3.ustr"
	)

s.mainparams.burnin = 10000
s.mainparams.numreps = 50000
s.mainparams.extracols = 2

s.popdata =[
    1,
    6,
    2,
    2,
    1,
    1,
    1,
    1,
    1,
    1,
    2,
    5,
    5,
    5,
    1,
    3,
    5,
    3,
    3,
    3,
    1,
    1,
    5,
    5,
    1,
    5,
    3,
    3,
    3,
    3,
    3,
    2,
    6,
    3,
    3,
    5,
    1,
    1,
    3,
    3,
    3,
    3,
    2,
    2,
    4,
    4,
    3,
    3]

kvalues=[2,3,4,5,6,7]

for kpop in kvalues:
  s.run(kpop=kpop, nreps=3, ipyclient=ipyclient)

ipyclient.wait()

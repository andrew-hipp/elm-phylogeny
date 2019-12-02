import ipyrad.analysis as ipa
import ipyparallel as ipp
import toyplot

import toyplot.svg
import toyplot.pdf
import toyplot.html

# in separate window:
# ipcluster start
# then, after that is running:

ipyclient = ipp.Client()

s = ipa.structure(
	name="ulmus.str.davidiana",
	workdir="ulmus_str_davidiana",
	data="ulmus2018b_davidiana_v2_outfiles/ulmus2018b_davidiana_v2.ustr"
	)

s.mainparams.burnin = 1000
s.mainparams.numreps = 5000

s.mainparams.extracols = 2 ## very important! If nothing happens, check this

s.popdata = [2, 6, 1, 1, 1, 5, 1,
			 3, 5, 4, 4, 1, 1, 1,
			 5, 5, 5, 5, 6, 5, 1,
			 5, 5, 4, 4, 7, 7, 5,
			 5]

kvalues=[3,4]

for kpop in kvalues:
  s.run(kpop=kpop, nreps=2, ipyclient=ipyclient)
ipyclient.wait()

myorder=['ULMBER-1',
		'ULMBER-2',
		'ULMBERvLAS-1',
		'ULMCAS-1',
		'ULMGAU-1',
		'ULMGAU-2',
		'ULMGLAU-1',
		'ULMMUL-1',
		'ELM-MOR-113',
		'ULMCHE-1',
		'ULMDAVvMAN-1',
		'ULMDAVvMAN-2',
		'ULMPROPvSUB-1',
		'ULMPROPvSUB-2',
		'ULMCARxJAP-1',
		'ULMCHE-2',
		'ULMJAP-1',
		'ULMJAP-2',
		'ULMJAPxWIL-1',
		'ULMJAPxWIL-2',
		'ULMMOR-4',
		'ULMPROP-1',
		'ULMPROP-2',
		'ULMWIL-2',
		'ULMWIL-3',
		'ELM-MOR-72B',
		'ULMMIC-1',
		'ULMSZE-1',
		'ULMSZE-2',
		]

for kpop in kvalues:
    ## parse outfile to a table and re-order it
    table = tables[kpop]
    table = table.ix[myorder]
    canvas, axes, mark = toyplot.bars(
                            table,
                            width=400,
                            height=200,
                            xshow=False,
                            style={"stroke": toyplot.color.near_black},
                            )
	toyplot.svg.render(canvas, "struct.K-"+str(kpop)+".svg")

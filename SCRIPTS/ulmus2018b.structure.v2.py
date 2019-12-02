import ipyrad.analysis as ipa
import ipyparallel as ipp
import toyplot

# in separate window:
# ipcluster start
# then, after that is running:

ipyclient = ipp.Client()

s = ipa.structure(
	name="ulmus_dav_50k",
	workdir="./ulmus_str_davidiana_try3",
	data="ulmus2018b_davidiana_v2_outfiles/ulmus2018b_davidiana_v2.ustr"
	)

s.mainparams.burnin = 10000
s.mainparams.numreps = 50000
s.mainparams.extracols = 2

s.popdata = [2, 6, 1, 1, 1, 5, 1,
			 3, 5, 4, 4, 1, 1, 1,
			 5, 5, 5, 5, 6, 5, 1,
			 5, 5, 4, 4, 7, 7, 5,
			 5]

kvalues=[3,4,5,6,7]

for kpop in kvalues:
  s.run(kpop=kpop, nreps=3, ipyclient=ipyclient)

ipyclient.wait()

etable = s.get_evanno_table(kvalues)
tables = s.get_clumpp_table(kvalues, quiet=True)

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

mypops = ['cast',
'cast',
'cast',
'cast',
'cast',
'cast',
'cast',
'cast',
'chang',
'chen',
'dv',
'dv',
'dv',
'dv',
'jp',
'jp',
'jp',
'jp',
'jp',
'jp',
'jp',
'jp',
'jp',
'jp',
'jp',
'mi',
'mi',
'sz',
'sz',
]

mylabels=['cast_ULMBER-1',
'cast_ULMBER-2',
'cast_ULMBERvLAS-1',
'cast_ULMCAS-1',
'cast_ULMGAU-1',
'cast_ULMGAU-2',
'cast_ULMGLAU-1',
'cast_ULMMUL-1',
'chang_ELM-MOR-113',
'chen_ULMCHE-1',
'dv_ULMDAVvMAN-1',
'dv_ULMDAVvMAN-2',
'dv_ULMPROPvSUB-1',
'dv_ULMPROPvSUB-2',
'jp_ULMCARxJAP-1',
'jp_ULMCHE-2',
'jp_ULMJAP-1',
'jp_ULMJAP-2',
'jp_ULMJAPxWIL-1',
'jp_ULMJAPxWIL-2',
'jp_ULMMOR-4',
'jp_ULMPROP-1',
'jp_ULMPROP-2',
'jp_ULMWIL-2',
'jp_ULMWIL-3',
'mi_ELM-MOR-72B',
'mi_ULMMIC-1',
'sz_ULMSZE-1',
'sz_ULMSZE-2',
]

for kpop in kvalues:
    table = tables[kpop]
    table = table.ix[myorder]
    style = {"stroke":toyplot.color.near_black,
         "stroke-width": 2}
	canvas = toyplot.Canvas(width=1200, height=300)
	axes = canvas.cartesian(bounds=("5%", "95%", "5%", "45%"))
	axes.bars(table, style=style)
	#ticklabels = [i for i in table.index.tolist()]
	ticklabels=mylabels
	axes.x.ticks.locator = toyplot.locator.Explicit(labels=ticklabels)
	axes.x.ticks.labels.angle = -60
	axes.x.ticks.show = True
	axes.x.ticks.labels.offset = 10
	axes.x.ticks.labels.style = {"font-size": "16px"}
	axes.x.spine.style = style
	axes.y.show = False
	toyplot.svg.render(canvas, "struct.K-"+str(kpop)+".svg")

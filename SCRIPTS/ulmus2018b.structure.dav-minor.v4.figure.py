import ipyrad.analysis as ipa
import toyplot
import toyplot.svg

s = ipa.structure(
	name="udm50",
	workdir="./udm_v4",
	data="ulmus2018b_davidia_minor_outfiles/ulmus2018b_davidia_minor.ustr"
	)

kvalues=[2,3,4,5,6,7]
#etable = s.get_evanno_table(kvalues)
tables = s.get_clumpp_table(kvalues, quiet=True)

myorder = [
    'ELM-MOR-109B',
    'ULMFOL-1',
    'ULMFOL-1.5',
    'ULMPROC-2',
    'ELM-MOR-78A',
    'ULMGLAB-2',
    'ELM-MOR-86B',
    'ELM-MOR-85B',
    'ELM-MOR-88A',
    'ELM-MOR-83B',
    'ELM-MOR-84B',
    'ULMCAN-1',
    'ULMPROC-1',
    'ULMPUM-2',
    'ULMLAC-1',
    'ULMPUM-1',
    'ELM-MOR-73B',
    'ELM-MOR-75A',
    'ELM-MOR-89B',
    'ULMGLAU-2',
    'ULMWIL-2',
    'ULMWIL-3',
    'ULMPROPvSUB-1',
    'ULMCHE-2',
    'ULMPROP-1',
    'ULMPROP-2',
    'ULMPROPvSUB-2',
    'ULMJAP-1',
    'ULMJAP-2',
    'ULMCARxJAP-1',
    'ULMDAVvMAN-2',
    'ULMDAVvMAN-1',
    'ULMJAPxWIL-2',
    'ULMJAPxWIL-1',
    'ULMMOR-4',
    'ULMMOR-2',
    'ULMSZE-1',
    'ULMSZE-2',
    'ULMGAU-2',
    'ULMGAU-1',
    'ULMBERvLAS-1',
    'ULMCAS-1',
    'ULMBER-2',
    'ULMBER-1',
    'ULMGLAU-1',
    'ULMMUL-1',
    'ELM-MOR-72B',
    'ULMMIC-1']

mypops = [
    'minor',
    'minor',
    'minor',
    'minor',
    'minor',
    'minor',
    'minor',
    'minor',
    'minor',
    'minor',
    'minor',
    'minor',
    'minor',
    'pumila',
    'pumila',
    'pumila',
    'pumila',
    'pumila',
    'pumila',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'davidiana',
    'szechuanica',
    'szechuanica',
    'castaneifolia',
    'castaneifolia',
    'castaneifolia',
    'castaneifolia',
    'castaneifolia',
    'castaneifolia',
    'castaneifolia',
    'castaneifolia',
    'microcarpa',
    'microcarpa']

mylabels = [
    'U minor ssp canescens 1',
    'U minor 1',
    'U minor 2',
    'U minor (procera) 1',
    'U minor (goodyeri)',
    'U minor 3',
    'U minor 4',
    'U minor (plotii)',
    'U minor 5',
    'U minor (angustifolia)',
    'U minor (sarniensis)',
    'U minor ssp canescens 2',
    'U minor (procera) 2',
    'U pumila unk 1',
    'U laciniata x pumila',
    'U pumila unk 2',
    'U pumila unk 3',
    'U pumila unk 4',
    'U pumila OK',
    'U dav. var. japonica 1',
    'U dav. var. japonica 2',
    'U dav. var. japonica 3',
    'U dav. var. dav. 1',
    'U dav. var. japonica 4',
    'U dav. var. japonica 5',
    'U dav. var. japonica 6',
    'U dav. var. dav. 2',
    'U dav. var. japonica 7',
    'U dav. var. japonica 8',
    'U dav. var. japonica 9',
    'U dav. var. dav. 3',
    'U dav. var. dav. 4',
    'U dav. var. japonica 10',
    'U dav. var. japonica 11',
    'U dav. var. japonica 12',
    'U dav. var. japonica 13',
    'U szechuanica 1',
    'U szechuanica 2',
    'U castaneifolia 1',
    'U castaneifolia 2',
    'U castaneifolia 3',
    'U castaneifolia 4',
    'U castaneifolia 5',
    'U castaneifolia 6',
    'U castaneifolia 7',
    'U castaneifolia 8',
    'U microcarpa 1',
    'U microcarpa 2']

for kpop in kvalues:
    table = tables[kpop]
    table = table.ix[myorder]
    style = {"stroke":toyplot.color.near_black, "stroke-width": 2}
    canvas = toyplot.Canvas(width=1200, height=300)
    axes = canvas.cartesian(bounds=("5%", "95%", "5%", "45%"))
    axes.bars(table, style=style)
    ticklabels=mylabels
    axes.x.ticks.locator = toyplot.locator.Explicit(labels=ticklabels)
    axes.x.ticks.labels.angle = -60
    axes.x.ticks.show = True
    axes.x.ticks.labels.offset = 10
    axes.x.ticks.labels.style = {"font-size": "16px"}
    axes.x.spine.style = style
    axes.y.show = False
    toyplot.svg.render(canvas, "struct.K-"+str(kpop)+".svg")

#!/usr/bin/env python3
# gera-docx.py — gera a "Especificação Funcional" (.docx) de um Feature Set (N2 + seus N3),
# de forma PADRONIZADA, preenchendo o template PHL (scripts/templates/…docx).
#
# Uso (a partir da raiz do repositório):
#   python3 scripts/gera-docx.py --all                 # todos os feature sets com N3
#   python3 scripts/gera-docx.py modules/.../faq       # um feature set (pasta do N2)
#
# Saída: documentos/<SIGLA_N2>.docx  (+ documentos/_diagramas/<SIGLA_N2>.png, se renderizado)
#
# ESCOPO: esta exportação é deliberadamente LOCAL aos repositórios que a usam
# (premio-iel, transparencia-web, portal-compras) — decidido em 2026-09-02.
# NÃO promova ao siesa-engine: o engine distribuiria o script e o template PHL
# para instâncias que não fazem essa entrega. Mantenha as três cópias idênticas
# entre si ao mexer aqui.
#
# Diagrama da Jornada: renderiza o bloco ```mermaid do N2 via Chromium headless, se
# houver um no PATH/PLAYWRIGHT_BROWSERS_PATH; senão reaproveita o PNG em cache; senão
# cai para uma lista textual dos passos. Assim o script roda com ou sem navegador.
import os, re, sys, html, glob, subprocess, unicodedata, zipfile

ROOT      = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TEMPLATE  = os.path.join(ROOT, "scripts", "templates", "especificacao-funcional.docx")
OUT_DIR   = os.path.join(ROOT, "documentos")
DIAG_DIR  = os.path.join(OUT_DIR, "_diagramas")
MERMAIDJS = os.path.join(ROOT, "assets", "vendor", "mermaid.min.js")
GRID, TEAL = 9628, "00B4C8"
# Autor do "Histórico de Versões": fixo. O changelog do N2 registra quem editou a
# spec (o analista, a engenharia reversa, uma decisão de produto), e isso é
# rastreabilidade interna; o documento entregue ao cliente sai em nome da PHL TI.
# Regra comum às três instâncias (2026-09-03) — documentos/README.md.
AUTOR_HISTORICO = "PHL TI"
ASPECT_MAX_H_IN = 7.4

def rd(p):
    try: return open(p, encoding="utf-8").read()
    except Exception: return ""

# nome/sigla do sistema (nó de topo): do config.js do visualizador; sigla provisória
NOME_SISTEMA  = (re.search(r'name:\s*"([^"]+)"', rd(os.path.join(ROOT,"assets/js/config.js"))) or [None,"Documentação"])[1] \
                if re.search(r'name:\s*"([^"]+)"', rd(os.path.join(ROOT,"assets/js/config.js"))) else "Documentação"
# Sigla do sistema: vem do ambiente (é o que os workflows passam). Sem ela, tenta o
# `**Sigla**` do global/MASTER.md e, não achando, ABORTA — o default antes era a sigla
# de uma instância específica, então rodar noutra marcava o documento com o sistema
# errado, em silêncio. Documento com a sigla errada é pior que documento não gerado.
def _sigla_do_master():
    m = re.search(r"^-\s+\*\*Sigla\*\*:\s*`?([A-Z]{3,6})`?\b",
                  rd(os.path.join(ROOT, "global", "MASTER.md")), re.M)
    return m.group(1) if m else None

SIGLA_SISTEMA = os.environ.get("SIGLA_SISTEMA") or _sigla_do_master()
if not SIGLA_SISTEMA:
    sys.exit("✗ Sigla do sistema indefinida. Passe SIGLA_SISTEMA=XXXXX ou declare "
             "`- **Sigla**: XXXXX` em global/MASTER.md.")

# ─────────────────────────── parsing de markdown ───────────────────────────
def section(md, title):
    m = re.search(r'^##\s+'+re.escape(title)+r'\s*\n(.*?)(?=\n##\s|\n---\s*\n|\Z)', md, re.S|re.M)
    return m.group(1).strip() if m else ""
def clean_md(s):
    s = re.sub(r'<small>.*?</small>', '', s)
    s = re.sub(r'\[\*\*(.*?)\*\*\]\([^)]*\)', r'\1', s)
    s = re.sub(r'\[(.*?)\]\([^)]*\)', r'\1', s)
    s = s.replace('**','').replace('`','')
    return re.sub(r'\s+', ' ', s).strip()
def md_table(block):
    rows=[]
    for line in block.splitlines():
        line=line.strip()
        if not line.startswith('|'): continue
        cells=[c.strip() for c in line.strip('|').split('|')]
        if all(re.fullmatch(r':?-{2,}:?', c or '-') for c in cells): continue
        rows.append([clean_md(c) for c in cells])
    return rows
def md_tables(block):
    """Cada tabela markdown da seção, em separado — `[(subtítulo, linhas), …]`.

    `md_table()` achata TODAS as linhas `|` da seção numa lista só. Numa seção com
    duas tabelas de larguras diferentes (a matriz de perfis e a de visibilidade por
    natureza da etapa) isso produzia uma única tabela Word: a segunda entrava como
    linhas da primeira, espremida nas colunas dela.
    """
    out, atual, sub = [], [], None
    for line in (block or "").splitlines():
        s = line.strip()
        if s.startswith("|"):
            cells = [c.strip() for c in s.strip("|").split("|")]
            if not all(re.fullmatch(r":?-{2,}:?", c or "-") for c in cells):
                atual.append([clean_md(c) for c in cells])
            continue
        if atual:
            out.append((sub, atual)); atual, sub = [], None
        m = re.match(r"^#{3,4}\s+(.+?)\s*$", s)
        if m:
            sub = clean_md(m.group(1))
    if atual:
        out.append((sub, atual))
    return [(s, r) for s, r in out if len(r) > 1]

def widths_por_conteudo(linhas, grid=None):
    """Larguras proporcionais ao conteúdo, amortecidas pela raiz.

    A regra anterior dava 4628 (quase metade da grade) à primeira coluna, qualquer
    que fosse o número de colunas: numa tabela de 8, sobravam ~714 por coluna e os
    cabeçalhos quebravam em quatro linhas. A raiz evita o extremo oposto — uma
    célula muito longa não engole a tabela inteira.
    """
    grid = grid or GRID
    n = len(linhas[0])
    tam = [max((len(r[i]) if i < len(r) else 0) for r in linhas) or 1 for i in range(n)]
    peso = [max(t, 4) ** 0.5 for t in tam]
    total = sum(peso)
    w = [max(int(grid * x / total), 700) for x in peso]
    w[-1] += grid - sum(w)          # a última absorve o arredondamento
    return w

def numbered(block):
    return [(m.group(1), clean_md(m.group(2))) for line in block.splitlines()
            if (m:=re.match(r'^\s*(\d+)\.\s+(.*)$', line))]
def notes(block):
    return [clean_md(l) for l in block.splitlines()
            if l.strip().startswith('⚠️') or l.strip().startswith('*')]
# ─────────────── regra citada por remissão: o documento leva a regra original ────────
# Um N3 que cita a regra de outro artefato — "→ ver N1 Registro de Preços: Regras
# transversais de negócio: 3" ou "→ ver PUB-REL-01 Consultar Relatório de Carga: Regras
# de negócio: 2" — costuma trazer só um RESUMO dela: o texto completo mora na origem, e
# quem lê a spec chega lá pelo link. Quem lê o .docx não chega. Por isso a Especificação
# Funcional leva a regra ORIGINAL no lugar do resumo, e a remissão some — nem "ver N1…"
# nem número de regra de outro documento. Regra comum às três instâncias (2026-09-23);
# índice em documentos/README.md, "Regras de exportação".
#
# Um intervalo ("6 a 9") vira as regras citadas, uma após a outra, na mesma linha. O que
# vem DEPOIS da remissão (uma nota ⚠️, por exemplo) é preservado. Alvo que não existe:
# fica o texto do N3 sem a remissão, e o console avisa — o documento não pode sair com
# um "ver N1…" que não leva a lugar nenhum, nem com uma regra inventada.
REF_REGRA = re.compile(
    r'\s*→\s*ver\s+(?:N1\s+(?P<dom>[^:]+?)\s*:\s*Regras transversais de negócio'
    r'|(?P<fid>[A-Z]{3}-[A-Z]{3}-\d{2})\s+[^:]*?:\s*Regras de negócio)'
    r'\s*:\s*(?P<ini>\d+)(?:\s*(?:a|–|-)\s*(?P<fim>\d+))?\.?')

def _chave(txt):
    t = unicodedata.normalize("NFD", txt)
    return re.sub(r'\s+', ' ', "".join(c for c in t if unicodedata.category(c) != "Mn")).strip().lower()

_REGRAS_CITAVEIS = {}   # ("n1", domínio) / ("n3", ID) -> {nº: texto}; lido uma vez por execução

def _regras_do_n1(dominio):
    k = ("n1", _chave(dominio))
    if k not in _REGRAS_CITAVEIS:
        achado = {}
        for f in glob.glob(os.path.join(ROOT, "modules", "*", "README.md")):
            md = rd(f)
            h = re.search(r'^#\s*Dom[ií]nio:\s*(.+)$', md, re.M)
            if h and _chave(h.group(1)) == k[1]:
                achado = {int(n): t for n, t in numbered(section(md, "Regras transversais de negócio"))}
                break
        _REGRAS_CITAVEIS[k] = achado
    return _REGRAS_CITAVEIS[k]

def _regras_do_n3(fid):
    k = ("n3", fid)
    if k not in _REGRAS_CITAVEIS:
        achado = {}
        for f in glob.glob(os.path.join(ROOT, "modules", "**", "f-*.md"), recursive=True):
            md = rd(f)
            if re.search(r'^id:\s*' + re.escape(fid) + r'\s*$', md, re.M):
                achado = {int(n): t for n, t in numbered(section(md, "Regras de negócio"))}
                break
        _REGRAS_CITAVEIS[k] = achado
    return _REGRAS_CITAVEIS[k]

def regra_original(texto, origem="", _nivel=0):
    """Texto de uma regra do N3 pronto para o .docx: cada remissão a regra de outro
    artefato é trocada pelo texto da(s) regra(s) citada(s), e o resumo que a precedia
    sai. Sem remissão, devolve o texto como veio."""
    partes, pos = [], 0
    for m in REF_REGRA.finditer(texto):
        resumo = texto[pos:m.start()].strip()
        if m.group('dom'):
            fonte, rotulo = _regras_do_n1(m.group('dom')), f"N1 {m.group('dom').strip()}"
        else:
            fonte, rotulo = _regras_do_n3(m.group('fid')), m.group('fid')
        ini = int(m.group('ini')); fim = int(m.group('fim') or ini)
        citadas = [fonte[n] for n in range(ini, fim + 1) if n in fonte]
        if citadas and len(citadas) == fim - ini + 1:
            original = " ".join(citadas)
            if _nivel < 2:                       # a regra citada pode, ela mesma, citar outra
                original = regra_original(original, rotulo, _nivel + 1)
            partes.append(original)
        else:
            faixa = m.group('ini') + (f"–{m.group('fim')}" if m.group('fim') else "")
            print(f"  ⚠️  {origem}: remissão a {rotulo}, regra {faixa}, não encontrada — "
                  f"fica o texto do N3, sem a remissão")
            partes.append(resumo)
        pos = m.end()
    if not partes:
        return texto
    resto = texto[pos:].strip()
    return " ".join(p for p in partes + [resto] if p)

def gherkin(md):
    m=re.search(r'```gherkin\s*\n(.*?)```', md, re.S)
    return m.group(1).rstrip('\n').split('\n') if m else []
def mermaid(md):
    m=re.search(r'```mermaid\s*\n(.*?)```', md, re.S)
    return m.group(1).strip() if m else ""

# ─────────────────────────── helpers de WordprocessingML ───────────────────
def x(s): return html.escape(s, quote=False)
HRPR='<w:b/><w:bCs/><w:sz w:val="28"/><w:szCs w:val="28"/><w:u w:val="none"/>'  # 14pt · negrito · sem sublinhado
GKW={'Given':'Dado','When':'Quando','Then':'Então','And':'E','But':'Mas'}
KW_MUTED="6E6E6E"; _hn=[0]

def _run(text, bold=False, italic=False, color=None):
    rpr=""
    if bold: rpr+="<w:b/><w:bCs/>"
    if italic: rpr+="<w:i/><w:iCs/>"
    if color: rpr+=f'<w:color w:val="{color}"/>'
    rpr=f"<w:rPr>{rpr}</w:rPr>" if rpr else ""
    return f'<w:r>{rpr}<w:t xml:space="preserve">{x(text)}</w:t></w:r>'
def P(text, italic=False, size=None, bold=False, align=None):
    rpr=""
    if bold: rpr+="<w:b/><w:bCs/>"
    if italic: rpr+="<w:i/><w:iCs/>"
    if size: rpr+=f'<w:sz w:val="{size}"/><w:szCs w:val="{size}"/>'
    prpr=f"<w:rPr>{rpr}</w:rPr>" if rpr else ""
    jc=f'<w:jc w:val="{align}"/>' if align else ''
    ppr=f"<w:pPr>{jc}{prpr}</w:pPr>" if (jc or prpr) else ""
    return f'<w:p>{ppr}<w:r>{prpr}<w:t xml:space="preserve">{x(text)}</w:t></w:r></w:p>'
def _head(text, center=False, page_break=False):
    p='<w:keepNext/>'
    if page_break: p+='<w:pageBreakBefore/>'
    if center: p+='<w:jc w:val="center"/>'
    return (f'<w:p><w:pPr><w:pStyle w:val="AxureHeadingBasic"/>{p}<w:rPr>{HRPR}</w:rPr></w:pPr>'
            f'<w:r><w:rPr>{HRPR}</w:rPr><w:t xml:space="preserve">{x(text)}</w:t></w:r></w:p>')
def H(text, page_break=False):
    _hn[0]+=1
    return _head(f"{_hn[0]}. {text}", page_break=page_break)
def H_plain(text, center=False):
    return _head(text, center=center)
def FUNC(text):
    _hn[0]=0
    rpr='<w:rPr><w:b/><w:bCs/><w:sz w:val="28"/><w:szCs w:val="28"/></w:rPr>'
    return (f'<w:p><w:pPr><w:keepNext/><w:pageBreakBefore/>{rpr}</w:pPr>'
            f'<w:r>{rpr}<w:t xml:space="preserve">{x(text)}</w:t></w:r></w:p>')
def cell(text, w, header=False):
    rpr="<w:b/><w:bCs/>" if header else ""
    jc='<w:jc w:val="center"/>' if header else ''
    shd=f'<w:shd w:val="clear" w:color="auto" w:fill="{TEAL}"/>' if header else ''
    sp='<w:spacing w:before="120" w:after="120"/>' if header else '<w:spacing w:before="0" w:after="0"/>'
    prpr=f"<w:rPr>{rpr}</w:rPr>" if rpr else ""
    p=(f'<w:p><w:pPr>{sp}{jc}{prpr}</w:pPr><w:r>{prpr}<w:t xml:space="preserve">{x(text)}</w:t></w:r></w:p>')
    return f'<w:tc><w:tcPr><w:tcW w:w="{w}" w:type="dxa"/>{shd}<w:vAlign w:val="center"/></w:tcPr>{p}</w:tc>'
def table(headers, rows, widths):
    if abs(sum(widths)-GRID)>=5: raise ValueError(f"grid {sum(widths)} != {GRID}")
    grid="".join(f'<w:gridCol w:w="{w}"/>' for w in widths)
    trs=[f'<w:tr><w:trPr><w:tblHeader/></w:trPr>'+"".join(cell(h,w,True) for h,w in zip(headers,widths))+'</w:tr>']
    for r in rows: trs.append('<w:tr>'+"".join(cell(c,w) for c,w in zip(r,widths))+'</w:tr>')
    tblpr=('<w:tblPr><w:tblStyle w:val="Tabelacomgrade"/><w:tblW w:w="0" w:type="auto"/>'
           '<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="1" '
           'w:lastColumn="0" w:noHBand="0" w:noVBand="1"/></w:tblPr>')
    return f'<w:tbl>{tblpr}<w:tblGrid>{grid}</w:tblGrid>{"".join(trs)}</w:tbl>'
def eq_widths(n):
    base=GRID//n; return [base]*(n-1)+[GRID-base*(n-1)]
def cenarios_paras(md):
    TT={'Scenario':'Cenário','Scenario Outline':'Esquema do Cenário','Background':'Contexto','Examples':'Exemplos'}
    out=[]
    for raw in gherkin(md):
        s=raw.strip()
        if not s or s.startswith('#') or s.startswith('Feature:'): continue
        m=re.match(r'^(Scenario Outline|Scenario|Background|Examples):?\s*(.*)$', s)
        if m:
            title=f"{TT[m.group(1)]}: {m.group(2)}" if m.group(2) else TT[m.group(1)]
            out.append(f'<w:p><w:pPr><w:spacing w:before="140" w:after="40"/></w:pPr>{_run(title,bold=True)}</w:p>'); continue
        st=re.match(r'^(Given|When|Then|And|But)\b\s*(.*)$', s)
        if st:
            out.append(f'<w:p><w:pPr><w:spacing w:before="0" w:after="0"/><w:ind w:left="454"/></w:pPr>'
                       f'{_run(GKW[st.group(1)]+" ",bold=True,color=KW_MUTED)}{_run(st.group(2))}</w:p>'); continue
        out.append(f'<w:p><w:pPr><w:spacing w:before="0" w:after="0"/><w:ind w:left="454"/></w:pPr>{_run(s)}</w:p>')
    return out
def img_jornada(cx, cy):
    A='http://schemas.openxmlformats.org/drawingml/2006/main'; PICNS='http://schemas.openxmlformats.org/drawingml/2006/picture'
    return (f'<w:p><w:pPr><w:jc w:val="center"/></w:pPr><w:r><w:drawing>'
            f'<wp:inline distT="0" distB="0" distL="0" distR="0"><wp:extent cx="{cx}" cy="{cy}"/>'
            f'<wp:effectExtent l="0" t="0" r="0" b="0"/><wp:docPr id="100" name="Jornada"/>'
            f'<wp:cNvGraphicFramePr><a:graphicFrameLocks xmlns:a="{A}" noChangeAspect="1"/></wp:cNvGraphicFramePr>'
            f'<a:graphic xmlns:a="{A}"><a:graphicData uri="{PICNS}"><pic:pic xmlns:pic="{PICNS}">'
            f'<pic:nvPicPr><pic:cNvPr id="100" name="Jornada"/><pic:cNvPicPr/></pic:nvPicPr>'
            f'<pic:blipFill><a:blip r:embed="rId20"/><a:stretch><a:fillRect/></a:stretch></pic:blipFill>'
            f'<pic:spPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="{cx}" cy="{cy}"/></a:xfrm>'
            f'<a:prstGeom prst="rect"><a:avLst/></a:prstGeom></pic:spPr></pic:pic></a:graphicData></a:graphic>'
            f'</wp:inline></w:drawing></w:r></w:p>')
def img(rid, cx, cy, nome, ident):
    A='http://schemas.openxmlformats.org/drawingml/2006/main'; PICNS='http://schemas.openxmlformats.org/drawingml/2006/picture'
    return (f'<w:p><w:pPr><w:jc w:val="center"/></w:pPr><w:r><w:drawing>'
            f'<wp:inline distT="0" distB="0" distL="0" distR="0"><wp:extent cx="{cx}" cy="{cy}"/>'
            f'<wp:effectExtent l="0" t="0" r="0" b="0"/><wp:docPr id="{ident}" name="{x(nome)}"/>'
            f'<wp:cNvGraphicFramePr><a:graphicFrameLocks xmlns:a="{A}" noChangeAspect="1"/></wp:cNvGraphicFramePr>'
            f'<a:graphic xmlns:a="{A}"><a:graphicData uri="{PICNS}"><pic:pic xmlns:pic="{PICNS}">'
            f'<pic:nvPicPr><pic:cNvPr id="{ident}" name="{x(nome)}"/><pic:cNvPicPr/></pic:nvPicPr>'
            f'<pic:blipFill><a:blip r:embed="{rid}"/><a:stretch><a:fillRect/></a:stretch></pic:blipFill>'
            f'<pic:spPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="{cx}" cy="{cy}"/></a:xfrm>'
            f'<a:prstGeom prst="rect"><a:avLst/></a:prstGeom></pic:spPr></pic:pic></a:graphicData></a:graphic>'
            f'</wp:inline></w:drawing></w:r></w:p>')

def spacer(): return '<w:p/>'

# ─────────────────────────── render do diagrama (mermaid) ───────────────────
def find_chrome():
    if os.environ.get("GERA_DOCX_NO_BROWSER"):   # CI: reusa o cache de _diagramas, sem navegador
        return None
    for env in ("PLAYWRIGHT_BROWSERS_PATH",):
        base=os.environ.get(env)
        if base:
            for pat in ("**/chrome-linux/headless_shell","**/chrome-linux/chrome","**/chrome-mac*/**/Chromium*","**/chrome"):
                for p in glob.glob(os.path.join(base,pat), recursive=True):
                    if os.access(p, os.X_OK) and os.path.isfile(p): return p
    from shutil import which
    for n in ("chromium","chromium-browser","google-chrome","google-chrome-stable","chrome"):
        p=which(n)
        if p: return p
    return None
def render_jornada(src, out_png):
    if os.path.exists(out_png): return out_png            # cache
    chrome=find_chrome()
    if not (chrome and src and os.path.exists(MERMAIDJS)): return None
    os.makedirs(os.path.dirname(out_png), exist_ok=True)
    def page(force_w=None):
        css = ".mermaid{width:%dpx}.mermaid svg{width:100%%!important;height:auto!important;display:block}"%force_w if force_w else ""
        grid=("body{background-color:#f4f8fc;background-image:linear-gradient(#d3e2f1 1px,transparent 1px),"
              "linear-gradient(90deg,#d3e2f1 1px,transparent 1px);background-size:26px 26px}.mermaid svg{background:transparent}")
        return (f"<!doctype html><meta charset=utf-8><style>html,body{{margin:0;padding:0}}{grid}{css}</style>"
                f'<div class="mermaid">{src}</div><script src="file://{MERMAIDJS}"></script><script>'
                "try{mermaid.initialize({startOnLoad:false,theme:'default',flowchart:{useMaxWidth:false,htmlLabels:true,curve:'basis'}});}catch(e){}"
                "(function(){try{(mermaid.run?mermaid.run({querySelector:'.mermaid'}):mermaid.init(undefined,'.mermaid'));}catch(e){document.title='ERR';}})();</script>")
    def run(args, cap=False):
        base=[chrome,"--no-sandbox","--disable-gpu","--disable-dev-shm-usage","--force-device-scale-factor=2"]
        return subprocess.run(base+args, capture_output=cap, text=True, timeout=90)
    h1=out_png+".p1.html"; h2=out_png+".p2.html"
    try:
        open(h1,"w").write(page())
        dom=run(["--virtual-time-budget=8000","--dump-dom",f"file://{h1}"], cap=True).stdout
        mm=re.search(r'viewBox="0 0 ([\d.]+) ([\d.]+)"', dom or "")
        if not mm: return None
        W,H=float(mm.group(1)),float(mm.group(2)); TW=1200; TH=round(TW*H/W)+8
        open(h2,"w").write(page(force_w=TW))
        run(["--virtual-time-budget=8000",f"--window-size={TW},{TH}",f"--screenshot={out_png}",f"file://{h2}"])
        return out_png if os.path.exists(out_png) else None
    except Exception:
        return None
    finally:
        for f in (h1,h2):
            try: os.remove(f)
            except OSError: pass
# ── telas do protótipo ──────────────────────────────────────────────────────
# O capítulo "Telas e Protótipos" dizia, para toda funcionalidade, que não havia
# protótipo — texto fixo, escrito antes de os protótipos existirem. Existem: um
# fluxo por Feature Set, em `prototypes/<domínio>/<feature-set>/`, mesma pasta
# relativa de `modules/`. Daqui saem as fotos das telas.
#
# As telas vêm da barra `.proto-bar`: cada botão ANTES do primeiro `.sepv` leva a
# uma, e o texto do botão a nomeia. Clicar é mais fiel do que chamar showScreen()
# — alguns botões abrem modal ou preparam estado antes de trocar de tela.
#
# O arquivo temporário nasce NA PASTA do protótipo: o HTML referencia
# `../../_biblioteca-ds/ds.css` por caminho relativo e, gerado em /tmp, sairia sem
# o design system — com a estrutura certa e nenhuma cor, que parece defeito do
# protótipo e não é.
PROTO_DIR = os.path.join(ROOT, "prototypes")
PROTO_OUT = os.path.join(OUT_DIR, "_prototipos")
# O selo entra na lista porque é `position:fixed`: numa foto de página inteira ele
# desce para o rodapé da imagem e o vão até o fim do conteúdo vira espaço em branco.
# Some com o andaime do protótipo e com os elementos `position:fixed`: numa foto de
# página inteira eles descem para o rodapé da imagem, e o vão entre o fim do
# conteúdo e eles vira uma faixa branca. O selo e o botão flutuante se repetem
# igual em toda tela — nada se perde tirando-os da foto.
ESCONDE = (".proto-bar,.proto-demo,.proto-conformidade,.dsc-proto-notes,"
           ".dsc-proto-badge,.dsc-fab{display:none!important}")

# Uma tela de 1280×4744 em 6,4" de largura daria 23" de altura. Encolhida para
# caber na página, vira uma tira de 2" — ilegível, e ilegível com cara de imagem.
# Por isso a tela alta é FATIADA em pedaços que cabem inteiros, cada um em tamanho
# de leitura. Sem Pillow o corte não acontece e a imagem sai encolhida, que é pior
# mas continua funcionando — o script não pode exigir dependência que as outras
# instâncias podem não ter.
try:
    from PIL import Image as _PILImage
except ImportError:
    _PILImage = None

def apara(png):
    """Corta as linhas de fundo no pé da imagem.

    Medir a altura pelo DOM não resolve: o container da tela tem altura própria
    maior que o conteúdo, e a foto sai com uma faixa vazia embaixo. Depois de
    fotografar, a resposta está na própria imagem — a última linha que difere do
    fundo é onde o conteúdo acaba.
    """
    if _PILImage is None: return
    try:
        im = _PILImage.open(png).convert("RGB")
    except Exception:
        return
    w, h = im.size
    px = im.load()
    fundo = px[4, h - 4]
    ultima = 0
    for y in range(h - 1, -1, -1):
        if any(px[xx, y] != fundo for xx in range(0, w, 5)):
            ultima = y; break
    corte = min(h, ultima + 24)
    if corte < h - 8:                       # margem: não reescreve por 8px à toa
        im = im.crop((0, 0, w, corte))
    otimiza(im).save(png, optimize=True)

def otimiza(im):
    """Paleta de 256 cores. Numa captura de interface a diferença não se enxerga
    (média de 0,2 por canal na amostragem) e o arquivo cai a um terço — o cache é
    versionado para a CI reusar, então o tamanho importa."""
    try:
        return im.quantize(colors=256, method=_PILImage.MEDIANCUT, dither=_PILImage.NONE)
    except Exception:
        return im

# 6,4" de largura por, no máximo, 7,2" de altura. Em pixels isso depende da
# largura da imagem: a tela é capturada a 1280 e o diagrama da jornada a 2400.
# Limiar fixo fatiaria a jornada em pedaços de 3" — ou não fatiaria nada.
RAZAO_MAX = 7.2 / 6.4

def fatia(png, titulo):
    if _PILImage is None: return [(png, titulo)]
    try:
        im = _PILImage.open(png); w, h = im.size
    except Exception:
        return [(png, titulo)]
    alt_max = int(w * RAZAO_MAX)
    if h <= alt_max: return [(png, titulo)]
    n = -(-h // alt_max)                       # teto da divisão
    passo = -(-h // n)
    saida = []
    for i in range(n):
        alvo = png[:-4] + f"-p{i+1}.png"
        if not os.path.exists(alvo):
            otimiza(im.crop((0, i*passo, w, min((i+1)*passo, h)))).save(alvo, optimize=True)
        saida.append((alvo, f"{titulo} ({i+1} de {n})"))
    return saida

def slug_arquivo(txt):
    t = unicodedata.normalize("NFD", txt)
    t = "".join(c for c in t if unicodedata.category(c) != "Mn").lower()
    return re.sub(r"^-|-$", "", re.sub(r"[^a-z0-9]+", "-", t))[:40] or "tela"

# ─────────────────── estados de tela que ficam fora do .docx ─────────────────
# Regra comum às três instâncias (2026-09-03): protótipo que representa o estado
# "loading", "empty" ou "error" NÃO vai para a Especificação Funcional. O documento
# entregue ao cliente mostra a tela que o usuário opera; espera, vazio e falha são
# contrato do protótipo e da regra de negócio escrita, não figura do documento.
# Vale também para as variantes em português (carregando, vazio/vazia, erro) e para o
# estado de um componente da tela (`combos-ano-vazio`). Mesmo texto nas três
# cópias — índice das regras em documentos/README.md, "Regras de exportação".
ESTADOS_FORA_DO_DOCX = ("loading", "empty", "error", "carregando", "vazio", "vazia", "erro")

def estado_fora_do_docx(nome):
    """`nome` é o que identifica a tela: o nome do arquivo do protótipo
    (`empty.html`, `combos-ano-erro.html`) ou o título do botão na barra do fluxo
    ("Erro de servidor"). Casa por palavra inteira, sem acento nem caixa — `erro`
    casa em "Erro de servidor" e em `combos-ano-erro`, mas não em "Erros de
    crítica", que é conteúdo de negócio e continua no documento."""
    t = unicodedata.normalize("NFD", os.path.splitext(os.path.basename(str(nome)))[0])
    t = "".join(c for c in t if unicodedata.category(c) != "Mn").lower()
    palavras = set(re.split(r"[^a-z0-9]+", t))
    return any(e in palavras for e in ESTADOS_FORA_DO_DOCX)

def _botoes_de_tela(html_src):
    m = re.search(r'<div class="proto-bar">(.*?)</div>', html_src, re.S)
    if not m: return []
    bloco = m.group(1).split('class="sepv"')[0]      # depois do 1º separador é perfil/estado
    # `data-feature` é o vínculo tela → funcionalidade. Não dá para inferir do
    # nome do botão: "Designar avaliadores" e "Alocar Avaliador à Inscrição" são a
    # mesma coisa com nomes diferentes, e adivinhar põe a tela na funcionalidade
    # errada. Botão sem o atributo cai no capítulo do Feature Set, como antes.
    out = []
    for m in re.finditer(r'<button id="([^"]+)"([^>]*)>(.*?)</button>', bloco, re.S):
        # `data-doc="nao"`: tela que existe no protótipo para explicar a navegação
        # mas não pertence à especificação — o stub "fora do escopo deste protótipo",
        # por exemplo. Sem isso ela cairia no capítulo das não atribuídas, virando
        # uma página de ruído no documento entregue.
        if re.search(r'data-doc="nao"', m.group(2)):
            continue
        titulo = re.sub(r"<[^>]+>", "", m.group(3)).strip()
        # Tela que É o estado de carregamento, vazio ou erro fica fora do documento
        # (regra comum às três instâncias — ver ESTADOS_FORA_DO_DOCX). Aqui o nome
        # da tela é o título do botão, então é por ele que a regra se aplica.
        if estado_fora_do_docx(titulo):
            continue
        feats = re.search(r'data-feature="([^"]*)"', m.group(2))
        out.append((m.group(1), titulo, feats.group(1).split() if feats else []))
    return out

def telas_prototipo(fs_dir):
    """[(caminho do png, título)] das telas do Feature Set — [] se não houver."""
    rel = os.path.relpath(fs_dir, os.path.join(ROOT, "modules"))
    pasta = os.path.join(PROTO_DIR, rel)
    chrome = find_chrome()
    if not os.path.isdir(pasta): return []
    destino = os.path.join(PROTO_OUT, os.path.basename(fs_dir))
    os.makedirs(destino, exist_ok=True)
    out, n_tela = [], 0
    for arq in sorted(glob.glob(os.path.join(pasta, "*.html"))):
        src = rd(arq)
        for bid, titulo, feats in _botoes_de_tela(src):
            # numera a TELA, não a fatia: `out` cresce de vários em vários quando a
            # tela é alta, e usar o tamanho dele pularia números — e, pior, mudaria
            # o nome do arquivo em cache assim que o fatiamento mudasse.
            n_tela += 1
            png = os.path.join(destino, f"{n_tela:02d}-{slug_arquivo(titulo)}.png")
            # Cache primeiro, como o dos diagramas: é ele que faz a CI reproduzir o
            # capítulo sem navegador. A tela alta fica guardada só em fatias — a
            # inteira serve de origem do corte e é descartada —, então procura as duas.
            prontas = sorted(glob.glob(png[:-4] + "-p*.png"))
            if prontas:
                out.extend((f, f"{titulo} ({i+1} de {len(prontas)})", feats)
                           for i, f in enumerate(prontas))
                continue
            if os.path.exists(png):
                out.append((png, titulo, feats)); continue
            if not chrome:
                # Sem navegador e sem cache a tela sumiria em silêncio, e o documento
                # sairia menor com cara de completo.
                print(f"  \u26a0\ufe0f  {os.path.basename(fs_dir)}: tela \u201c{titulo}\u201d sem cache "
                      f"em documentos/_prototipos/ e sem Chromium — o .docx sairá sem ela. "
                      f"Gere localmente com um navegador e commite o PNG.")
                continue
            tmp = os.path.join(pasta, f"_tmp-{os.getpid()}.html")
            injecao = ("<style>" + ESCONDE + "</style><script>window.addEventListener('load',function(){"
                       f"var b=document.getElementById({bid!r});if(b)b.click();"
                       "setTimeout(function(){"
                       # o fim do CONTEÚDO, não o do documento: scrollHeight cresce com
                       # o container que se estica até a altura da janela, e a diferença
                       # sai na foto como um vão branco no pé da tela.
                       # `offsetParent` é null em elemento `position:fixed` — usar isso como
                       # teste de visibilidade dá "invisível" para toda máscara de modal, e a
                       # sobreposição passa despercebida. Vale o display + a altura real.
                       "var vis=function(e){return getComputedStyle(e).display!=='none'"
                       "&&e.getBoundingClientRect().height>0;};"
                       "var fim=0;"
                       "document.querySelectorAll('.dsc-screen,.dsc-modal-mask,.dsc-drawer-mask').forEach(function(e){"
                       "if(vis(e)){var r=e.getBoundingClientRect();"
                       "fim=Math.max(fim,r.bottom+window.scrollY);}});"
                       "if(!fim)fim=document.documentElement.scrollHeight;"
                       # modal/gaveta aberta: a máscara cobre a página inteira e o painel
                       # branco vai até o fim, então não há faixa de fundo para aparar. O
                       # enquadramento certo é o da janela — é assim que a sobreposição foi
                       # desenhada para ser vista.
                       "var sobre=0;"
                       "document.querySelectorAll('.dsc-modal-mask,.dsc-drawer-mask').forEach(function(e){"
                       "if(vis(e))sobre=1;});"
                       "document.title='H:'+(sobre?900:Math.ceil(fim)+24);},250);});</script>")
            try:
                open(tmp, "w", encoding="utf-8").write(src.replace("</body>", injecao + "</body>"))
                base = [chrome, "--headless", "--no-sandbox", "--disable-gpu", "--disable-dev-shm-usage"]
                dom = subprocess.run(base + ["--virtual-time-budget=4000", "--dump-dom", "file://" + tmp],
                                     capture_output=True, text=True, timeout=90).stdout or ""
                mh = re.search(r"<title>H:(\d+)</title>", dom)
                alt = min(int(mh.group(1)), 6000) if mh else 900
                subprocess.run(base + ["--virtual-time-budget=4000", f"--window-size=1280,{alt}",
                                       f"--screenshot={png}", "file://" + tmp], capture_output=True, timeout=90)
                if os.path.exists(png):
                    apara(png)
                    pedacos = fatia(png, titulo)
                    if len(pedacos) > 1:
                        os.remove(png)          # a inteira já cumpriu o papel de origem
                    out.extend((f, t, feats) for f, t in pedacos)
            except Exception:
                pass
            finally:
                try: os.remove(tmp)
                except OSError: pass
    return out

def png_size(path):
    import struct
    with open(path,"rb") as f: f.read(16); w,h=struct.unpack(">II", f.read(8))
    return w,h

# ─────────────────────────── montagem do corpo do N2 ────────────────────────
def build_body(fs_dir):
    n2 = rd(os.path.join(fs_dir,"README.md"))
    nome_n2 = (re.search(r'^#\s*Feature Set:\s*(.+)$', n2, re.M) or [None,fs_dir])[1].strip()
    sigla_n2 = (re.search(r'Nível 2[^`]*`([A-Z][A-Z-]+)`', n2) or [None,"N2"])[1]
    sfs = sigla_n2.split('-')[-1]
    nome_base = re.sub(r'\s*\([^)]*\)\s*$','',nome_n2).strip()
    n2_label = f"{nome_base} ({sfs})"
    _hn[0]=0
    body=[]
    body.append(P(SIGLA_SISTEMA, bold=True, size=28, align="right"))
    body.append(P("Especificação Funcional", bold=True, align="right"))
    body.append(P(n2_label, align="right"))
    body.append(spacer())
    # Histórico de Versões (do changelog do N2), sem número, centralizado
    body.append(H_plain("Histórico de Versões", center=True))
    chg = md_table(section(n2,"Changelog"))
    ver=[f"1.{i}" for i in range(len(chg)-2,-1,-1)]
    hist=[[ver[i] if i<len(ver) else "—", r[0], f"{r[2]} — {r[3]}" if len(r)>=4 else r[-1], AUTOR_HISTORICO]
          for i,r in enumerate(chg[1:])] if len(chg)>1 else []
    if hist: body.append(table(["Versão","Data","Descrição","Autor"], hist, [1077,1367,5616,1568]))
    body.append(spacer())
    # 1. Nome (SFS) + descrição — começa em nova página
    body.append(H(n2_label, page_break=True))
    for para in [p for p in section(n2,"Descrição").split("\n") if p.strip()]:
        body.append(P(clean_md(para)))
    body.append(spacer())
    # 2. Funcionalidades (só o nome)
    body.append(H("Funcionalidades"))
    feats=md_table(section(n2,"Features"))
    if feats and len(feats)>1:
        frows=[[r[0], r[-1]] for r in feats[1:]]
        body.append(table(["Funcionalidade","Descrição"], frows, [3600,6028]))
    body.append(spacer())
    # 3. Telas — o inventário do Feature Set, com o caminho de menu que leva a cada uma.
    # O caminho é propriedade da TELA, não da feature: metade delas atende mais de uma,
    # e repetir o caminho em cada N3 seria o mesmo dado envelhecendo em ritmos
    # diferentes. Fica aqui pelo mesmo motivo que as permissões ficam no N2.
    telas_n2 = md_table(section(n2, "Telas"))
    if telas_n2 and len(telas_n2) > 1:
        body.append(H("Telas"))
        iMenu = next((i for i, h in enumerate(telas_n2[0]) if re.search(r"Caminho de menu", h, re.I)), -1)
        if iMenu >= 0:
            cols = [0, iMenu, len(telas_n2[0])-1]
            body.append(table(["Tela", "Caminho de menu", "Descrição"],
                              [[r[i] if i < len(r) else "" for i in cols] for r in telas_n2[1:]],
                              [2600, 3200, 3828]))
            body.append(P("“—” no caminho de menu: a tela não tem entrada própria no menu — "
                          "chega-se a ela a partir de outra tela.", italic=True, size=18))
        else:
            # N2 ainda sem a coluna: entrega o que há, em vez de omitir o capítulo
            body.append(table(telas_n2[0], telas_n2[1:], eq_widths(len(telas_n2[0]))))
        body.append(spacer())
    # 4. Jornada do Usuário — imagem (ou passos textuais)
    body.append(H("Jornada do Usuário", page_break=True))
    src=mermaid(n2); png=render_jornada(src, os.path.join(DIAG_DIR, f"{sigla_n2}.png")) if src else None
    # A jornada fica INTEIRA e em UMA página: quebrada em pedaços ela perde as setas
    # que cruzam o corte, e um fluxograma partido em três páginas não se lê de uma
    # vez. Sozinha na página, o quadro útil é quase a folha toda (6,6" × 9,6"), o
    # que devolve boa parte do tamanho que o limite de 7,4" tirava.
    jornada = [(png, "Jornada")] if png else []
    if jornada:
        jp = jornada[0][0]
        w, h = png_size(jp)
        cx, cy = int(6.6*914400), int(6.6*914400*h/w)
        # 10,12" de área útil menos o título do capítulo. Apertar demais faz o Word
        # empurrar a imagem para a página seguinte e deixar o título sozinho — que é
        # o mesmo defeito de ocupar duas páginas, por outro caminho.
        maxh = int(9.2*914400)
        if cy > maxh: cy = maxh; cx = int(cy*w/h)
        body.append(img("rId40", cx, cy, "Jornada", 300))
    else:
        for lbl in re.findall(r'[\[\({]+"?([^"\]\)}|]+?)"?[\]\)}]+', src or ""):
            if lbl.strip(): body.append(P("• "+lbl.strip()))
        if not src: body.append(P("Jornada não disponível.", italic=True, size=18))
    body.append(spacer())
    # 4. Permissões
    body.append(H("Permissões", page_break=True))
    for i, (sub, linhas) in enumerate(md_tables(section(n2,"Permissões por perfil"))):
        if i: body.append(spacer())
        if sub: body.append(P(sub, bold=True))
        body.append(table(linhas[0], linhas[1:], widths_por_conteudo(linhas)))
    body.append(spacer())
    # 5. Telas do protótipo — do Feature Set, não da funcionalidade: o fluxo é
    # desenhado por Feature Set e as telas se encadeiam entre as funcionalidades.
    # Atribuir cada tela a uma delas exigiria um vínculo que não existe em lugar
    # nenhum; inventá-lo poria a tela na funcionalidade errada.
    telas = telas_prototipo(fs_dir)
    # NUNCA reusar o nome `png` num laço daqui em diante: ele guarda o diagrama da
    # jornada e é devolvido no fim de build_body. Sombreá-lo já mandou a última tela
    # do protótipo para o slot do diagrama, achatada pelo limite de altura.
    _seq = [200]        # id de <wp:docPr>: precisa ser único no documento, e a mesma
                        # tela aparece em mais de uma funcionalidade — indexar pela
                        # imagem repetiria o id e o Word recusa o arquivo.

    def bloco_de_telas(itens, ja_vistas):
        """Parágrafos das telas; devolve quantas eram repetição."""
        saida, repetidas = [], 0
        for tela_png, titulo, _f in itens:
            w, h = png_size(tela_png)
            cx = int(6.4*914400); cy = int(cx*h/w)
            maxh = int(ASPECT_MAX_H_IN*914400)
            if cy > maxh: cy = maxh; cx = int(cy*w/h)
            saida.append(P(titulo, bold=True))
            _seq[0] += 1
            saida.append(img(f"rId{30+_ORDEM[tela_png]}", cx, cy, titulo, _seq[0]))
            saida.append(spacer())
            if tela_png in ja_vistas: repetidas += 1
            ja_vistas.add(tela_png)
        return saida, repetidas

    _ORDEM = {t[0]: i for i, t in enumerate(telas)}
    orfas = [t for t in telas if not t[2]]
    ja_vistas = set()
    if orfas:
        body.append(H("Telas e Protótipos"))
        body.append(P("Telas do protótipo navegável deste Feature Set ainda não atribuídas a uma "
                      "funcionalidade. São desenho de referência — guiam a intenção, não substituem "
                      "as regras de negócio.", italic=True, size=18))
        paras, _ = bloco_de_telas(orfas, ja_vistas)
        body.extend(paras)
    # por feature (N3) — cada um em nova página; numeração reinicia
    for fn in sorted(glob.glob(os.path.join(fs_dir,"f-*.md"))):
        md=rd(fn)
        nome=(re.search(r'^#\s+(.+)$', md, re.M) or [None,os.path.basename(fn)])[1].strip()
        body.append(FUNC(f"Funcionalidade: {nome}"))
        body.append(H("Descrição")); body.append(P(clean_md(section(md,"Descrição"))))
        reg=section(md,"Regras de negócio")
        body.append(H("Regras de Negócio"))
        # a remissão a regra de outro artefato vira a regra original — ver regra_original()
        nums=[(n, regra_original(t, f"{os.path.basename(fn)} regra {n}")) for n, t in numbered(reg)]
        body.append(table(["Nº","Descrição"], nums, [700,8928]) if nums else P("—"))
        for nt in notes(reg): body.append(P(nt, italic=True, size=18))
        body.append(H("Cenários")); body.extend(cenarios_paras(md) or [P("—")])
        body.append(H("Telas e Protótipos"))
        fid=(re.search(r'^id:\s*(\S+)', md, re.M) or [None,""])[1].strip()
        minhas=[t for t in telas if fid and fid in t[2]]
        if minhas:
            paras, repetidas = bloco_de_telas(minhas, ja_vistas)
            body.append(P("Telas do protótipo navegável desta funcionalidade. São desenho de "
                          "referência — guiam a intenção, não substituem as regras de negócio.",
                          italic=True, size=18))
            body.extend(paras)
        else:
            repetidas = 0
            body.append(P("Sem protótipo de tela para esta funcionalidade.", italic=True, size=18))
        campos=md_table(section(md,"Campos"))
        # Tela repetida não repete a descrição dos campos: quando TODAS as telas desta
        # funcionalidade já apareceram antes, a tabela vira uma remissão. Repetir a
        # mesma lista embaixo da mesma imagem só engorda o documento.
        if minhas and repetidas == len(minhas):
            body.append(P("Campos: os mesmos já descritos na primeira ocorrência desta tela.",
                          italic=True, size=18))
        elif campos and len(campos)>1:
            body.append(P("Campos da funcionalidade:", italic=True, size=18))
            hdr=campos[0]
            widths=[1500,1350,1150,1550,1250,2828] if len(hdr)==6 else eq_widths(len(hdr))
            body.append(table(hdr, campos[1:], widths))
        body.append(H("Campos Automáticos"))
        ca=md_table(section(md,"Campos automáticos"))
        body.append(table(ca[0], ca[1:], [2400,4628,2600]) if ca and len(ca)>1 else P("Não se aplica."))
    return "".join(body), sigla_n2, nome_n2, jornada, telas

def eq_widths_rest(total, n):
    if n<=0: return []
    base=total//n; return [base]*(n-1)+[total-base*(n-1)]

# ─────────────────────────── escrita do .docx (zip) ─────────────────────────
def build_docx(fs_dir):
    CONTENT, sigla_n2, nome_n2, jornada, telas = build_body(fs_dir)
    z=zipfile.ZipFile(TEMPLATE)
    doc=z.read('word/document.xml').decode('utf-8')
    prefix=doc[:doc.index('<w:p ')]
    cover=re.search(r'<w:p [^>]*>(?:(?!</w:p>).)*?<w:drawing.*?</w:p>', doc, re.S).group(0)
    sectpr=re.search(r'<w:sectPr\b.*?</w:sectPr>', doc, re.S).group(0)
    newdoc=prefix+cover+CONTENT+sectpr+"</w:body></w:document>"
    hdr=z.read('word/header1.xml').decode('utf-8')
    hdr=hdr.replace('&lt;&lt;SIGLA&gt;&gt;', x(SIGLA_SISTEMA)).replace('&lt;&lt;Nome do Sistema&gt;&gt;', x(NOME_SISTEMA))
    rels=z.read('word/_rels/document.xml.rels').decode('utf-8')
    novos=""
    for i in range(len(jornada)):
        novos+=(f'<Relationship Id="rId{40+i}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image"'
                f' Target="media/jornada{i}.png"/>')
    for i in range(len(telas)):
        novos+=(f'<Relationship Id="rId{30+i}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image"'
                f' Target="media/tela{i}.png"/>')
    if novos: rels=rels.replace('</Relationships>', novos+'</Relationships>')
    os.makedirs(OUT_DIR, exist_ok=True)
    out=os.path.join(OUT_DIR, nome_arquivo(nome_n2))
    with zipfile.ZipFile(out,"w",zipfile.ZIP_DEFLATED) as o:
        for it in z.infolist():
            n=it.filename
            if n=='word/document.xml': o.writestr(it,newdoc)
            elif n=='word/header1.xml': o.writestr(it,hdr)
            elif n=='word/_rels/document.xml.rels': o.writestr(it,rels)
            else: o.writestr(it, z.read(n))
        for i, (jp, _r) in enumerate(jornada):
            zi=zipfile.ZipInfo(f'word/media/jornada{i}.png', date_time=(1980,1,1,0,0,0))  # determinístico (sem churn no CI)
            zi.compress_type=zipfile.ZIP_DEFLATED
            o.writestr(zi, open(jp,"rb").read())
        for i, (tela, _t, _f) in enumerate(telas):
            zi=zipfile.ZipInfo(f'word/media/tela{i}.png', date_time=(1980,1,1,0,0,0))
            zi.compress_type=zipfile.ZIP_DEFLATED
            o.writestr(zi, open(tela,"rb").read())
    z.close()
    return out, sigla_n2, nome_n2

def feature_sets():
    out=[]
    for r in glob.glob(os.path.join(ROOT,"modules","*","*","README.md")):
        if re.search(r'^#\s*Feature Set:', rd(r), re.M) and glob.glob(os.path.join(os.path.dirname(r),"f-*.md")):
            out.append(os.path.dirname(r))
    return sorted(out)

def title_case(s):
    """"Apuração e Devolutiva" -> "ApuracaoEDevolutiva"; acentos e pontuação saem."""
    s = unicodedata.normalize("NFD", s)
    s = "".join(c for c in s if unicodedata.category(c) != "Mn")
    return "".join(w[0].upper()+w[1:] for w in re.split(r"[^A-Za-z0-9]+", s) if w)

def nome_arquivo(nome_n2):
    """Nome do .docx: o nome do N2 em TitleCase, sem a sigla.

    A sigla identifica o Feature Set na spec; o documento entregue e citado
    (coluna `Requisito` da planilha de contagem) é o nome. `AVL-APU.docx` obriga
    quem recebe a consultar a tabela de siglas — `ApuracaoDevolutiva.docx` não.
    O diagrama em `_diagramas/` continua nomeado pela SIGLA: é cache interno,
    chaveado pela identidade do Feature Set, que sobrevive a renomear o N2.
    """
    return f"{title_case(nome_n2)}.docx"

def fs_meta(fs_dir):
    n2=rd(os.path.join(fs_dir,"README.md"))
    nome=(re.search(r'^#\s*Feature Set:\s*(.+)$',n2,re.M) or [None,os.path.basename(fs_dir)])[1].strip()
    sigla=(re.search(r'Nível 2[^`]*`([A-Z][A-Z-]+)`',n2) or [None,"N2"])[1]
    dom=(re.search(r'^#\s*Domínio:\s*(.+)$', rd(os.path.join(os.path.dirname(fs_dir),"README.md")), re.M) or [None,""])[1].strip()
    return sigla, {"nome":nome,"dominio":dom,"nfeat":len(glob.glob(os.path.join(fs_dir,"f-*.md")))}

def read_pendencias():
    idx=rd(os.path.join(ROOT,"modules","INDEX.md"))
    m=re.search(r'<!-- PENDENCIAS:INICIO -->(.*?)<!-- PENDENCIAS:FIM -->', idx, re.S)
    blk=m.group(1) if m else ""
    def sub(t):
        mm=re.search(r'###\s+'+t+r'[^\n]*\n(.*?)(?=\n###\s|\Z)', blk, re.S)
        return md_table(mm.group(1)) if mm else []
    return sub("Exist"), sub("Conte")

def _htbl(rows, cls=""):
    if not rows or len(rows)<2: return "<p class='vazio'>Nenhum item.</p>"
    th="".join(f"<th>{html.escape(c)}</th>" for c in rows[0])
    tb="".join("<tr>"+"".join(f"<td>{html.escape(c)}</td>" for c in r)+"</tr>" for r in rows[1:])
    return f"<table class='{cls}'><thead><tr>{th}</tr></thead><tbody>{tb}</tbody></table>"

def write_docs_index():
    meta=dict(fs_meta(fs) for fs in feature_sets())
    # Percorre os Feature Sets, não os nomes de arquivo: o arquivo passou a se chamar
    # pelo nome do N2, e casar nome de arquivo com sigla perderia domínio e contagem.
    linhas=""; n_docs=0
    for sig, m in sorted(meta.items(), key=lambda kv: (kv[1]["dominio"], kv[1]["nome"])):
        arq=nome_arquivo(m["nome"])
        if not os.path.exists(os.path.join(OUT_DIR, arq)): continue
        n_docs+=1
        linhas+=(f"<tr><td>{html.escape(m['dominio'])}</td>"
                 f"<td><strong>{html.escape(m['nome'])}</strong> <span class='sig'>{sig}</span></td>"
                 f"<td class='c'>{m['nfeat']}</td>"
                 f"<td class='c'><a class='dl' href='{html.escape(arq)}' download>&#8595;&nbsp;.docx</a></td></tr>")
    exi, con = read_pendencias()
    CSS="""
:root{--teal:#00B4C8;--ink:#1a2b3c;--muted:#5b6b7a;--line:#d6e3f0;--bg:#f4f8fc}
*{box-sizing:border-box}body{font-family:'Segoe UI',Arial,sans-serif;color:var(--ink);margin:0;background:var(--bg)}
header{background:#fff;border-bottom:3px solid var(--teal);padding:22px 32px;display:flex;align-items:baseline;gap:14px;flex-wrap:wrap}
header h1{font-size:20px;margin:0;color:var(--ink)}header .sys{color:var(--teal);font-weight:700}
header a.voltar{margin-left:auto;color:var(--teal);text-decoration:none;font-size:13px;font-weight:600}
main{max-width:1100px;margin:0 auto;padding:26px 32px 60px}
h2{font-size:16px;margin:30px 0 12px;color:var(--ink);border-bottom:1px solid var(--line);padding-bottom:6px}
h2 .cnt{color:var(--muted);font-weight:400;font-size:13px}
table{border-collapse:collapse;width:100%;background:#fff;font-size:13px;margin:8px 0 4px;box-shadow:0 1px 2px rgba(0,0,0,.04)}
th,td{border:1px solid var(--line);padding:7px 10px;text-align:left;vertical-align:top}
thead th{background:var(--teal);color:#083039;font-weight:700}
td.c,th.c{text-align:center;white-space:nowrap}
.sig{color:var(--muted);font-size:11px;font-weight:600;background:#eef3f9;border-radius:4px;padding:1px 6px;margin-left:4px}
a.dl{display:inline-block;background:var(--teal);color:#fff;text-decoration:none;padding:5px 12px;border-radius:5px;font-weight:600;font-size:12px}
a.dl:hover{filter:brightness(.93)}
.pend th{background:#eef3f9;color:var(--ink)}
.nota{color:var(--muted);font-size:12px;margin:4px 0 0}
.vazio{color:var(--muted)}
"""
    doc=f"""<!doctype html><html lang="pt-BR"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Docs — {html.escape(NOME_SISTEMA)}</title><style>{CSS}</style></head><body>
<header><h1>Central de Documentos</h1><span class="sys">{html.escape(NOME_SISTEMA)}</span>
<a class="voltar" href="../index.html">&larr; Documentação</a></header>
<main>
<p class="nota">Especificações Funcionais (.docx) geradas por <code>scripts/gera-docx.py</code> — uma por Feature Set. Regerar após aprovar/alterar N2/N3.</p>
<h2>Especificações Funcionais <span class="cnt">({n_docs} documento(s))</span></h2>
<table><thead><tr><th>Domínio</th><th>Feature Set</th><th class="c">Features</th><th class="c">Download</th></tr></thead>
<tbody>{linhas}</tbody></table>
<h2>Pendências de especificação <span class="cnt">— o que ainda falta (de <code>modules/INDEX.md</code>)</span></h2>
<h3 style="font-size:14px;color:#5b6b7a">Existência — falta N3</h3>
{_htbl(exi,'pend')}
<h3 style="font-size:14px;color:#5b6b7a">Conteúdo — ⚠️/❓ em aberto</h3>
{_htbl(con,'pend')}
</main></body></html>"""
    os.makedirs(OUT_DIR, exist_ok=True)
    open(os.path.join(OUT_DIR,"index.html"),"w",encoding="utf-8").write(doc)
    return n_docs

def main(argv):
    args=[a for a in argv if not a.startswith('--')]
    targets = feature_sets() if ('--all' in argv or not args) else [os.path.join(ROOT,a) if not os.path.isabs(a) else a for a in args]
    # `--all` respeita o recorte declarado em documentos/ESCOPO.txt. Sem ele a CI
    # regenera os 21 Feature Sets a cada push e desfaz, em silêncio, qualquer
    # decisão de entregar só um subconjunto — foi o que aconteceu com a SP05.
    if '--all' in argv or not args:
        escopo = os.path.join(OUT_DIR, "ESCOPO.txt")
        if os.path.exists(escopo):
            siglas = {l.split("#")[0].strip() for l in rd(escopo).splitlines()}
            siglas.discard("")
            if siglas:
                antes = len(targets)
                targets = [fs for fs in targets if fs_meta(fs)[0] in siglas]
                print(f"  ESCOPO.txt: {len(targets)} de {antes} Feature Sets — {', '.join(sorted(siglas))}")
    if not os.path.exists(TEMPLATE):
        print(f"✗ template ausente: {TEMPLATE}"); return 2
    ok=0
    for fs in targets:
        try:
            out, sig, nome = build_docx(fs)
            print(f"  ✓ {sig}  {nome}  → {os.path.relpath(out, ROOT)}"); ok+=1
        except Exception as e:
            print(f"  ✗ {os.path.relpath(fs, ROOT)}: {e}")
    n=write_docs_index()
    print(f"\n{ok}/{len(targets)} documento(s) gerado(s) · documentos/index.html lista {n} · pendências de INDEX.md")
    return 0 if ok else 1

if __name__=="__main__":
    sys.exit(main(sys.argv[1:]))

#!/usr/bin/env node
/**
 * gera-doc-n2.js — documento Word consolidando os N2 (Feature Sets) de um domínio.
 *
 *   node scripts/gera-doc-n2.js <dominio> [-o saida.docx] [--fluxos <pasta>]
 *
 * Reúne, para cada Feature Set do domínio, as seções que interessam a quem lê a
 * especificação sem abrir o repositório: descrição, features, fluxo, dependências,
 * telas e a matriz de permissões. O Changelog fica de fora — é histórico de
 * manutenção, não conteúdo da spec.
 *
 * O fluxo é Mermaid no markdown. Se a pasta `--fluxos` tiver `<feature-set>.png`,
 * a imagem entra no lugar; senão entra o código-fonte em monoespaçada, com um
 * aviso — melhor um diagrama feio do que um capítulo faltando sem avisar.
 * As imagens saem de `scripts/render-mermaid.mjs`.
 *
 * A planilha é saída, não fonte: mudou a spec, gere de novo.
 */
const fs = require('fs');
const path = require('path');
const {
  Document, Packer, Paragraph, TextRun, HeadingLevel, AlignmentType, PageBreak,
  Table, TableRow, TableCell, WidthType, ShadingType, BorderStyle, ImageRun,
  TableOfContents, PageOrientation, LevelFormat, convertInchesToTwip,
} = require('docx');

// ── cores do design system da instância ─────────────────────────────────────
const MARCA = '3B8580', TEXTO = '0A2440', SUAVE = '5B7A94', CABEC = 'EAF2F8', BORDA = 'D6E3F0';

// ── markdown inline → runs ──────────────────────────────────────────────────
// O texto da spec traz negrito, código, links e <small>. Jogar a string crua no
// Word deixa os asteriscos visíveis; por isso a conversão mínima aqui.
function runs(txt, base = {}) {
  const out = [];
  let s = String(txt ?? '')
    .replace(/<small>(.*?)<\/small>/g, '$1')
    .replace(/\[([^\]]+)\]\([^)]*\)/g, '$1')          // link → só o texto
    .replace(/→ ver/g, '→ ver');
  const re = /(\*\*[^*]+\*\*|`[^`]+`|\*[^*]+\*)/g;
  let i = 0, m;
  while ((m = re.exec(s)) !== null) {
    if (m.index > i) out.push(new TextRun({ ...base, text: s.slice(i, m.index) }));
    const t = m[0];
    if (t.startsWith('**')) out.push(new TextRun({ ...base, text: t.slice(2, -2), bold: true }));
    else if (t.startsWith('`')) out.push(new TextRun({ ...base, text: t.slice(1, -1), font: 'Consolas', size: 18 }));
    else out.push(new TextRun({ ...base, text: t.slice(1, -1), italics: true }));
    i = m.index + t.length;
  }
  if (i < s.length) out.push(new TextRun({ ...base, text: s.slice(i) }));
  return out.length ? out : [new TextRun({ ...base, text: '' })];
}

const P = (txt, o = {}) => new Paragraph({ children: runs(txt), spacing: { after: 140 }, ...o });

// ── leitura do markdown ─────────────────────────────────────────────────────
function celulas(l) { return l.trim().replace(/^\||\|$/g, '').split('|').map((c) => c.trim()); }

function secoes(md) {
  const mapa = {};
  let atual = null;
  for (const l of md.split('\n')) {
    const h = /^##\s+(.+)$/.exec(l);
    if (h) { atual = h[1].trim(); mapa[atual] = []; continue; }
    if (atual) mapa[atual].push(l);
  }
  return mapa;
}

function tabela(linhas) {
  const i = linhas.findIndex((l) => l.startsWith('|'));
  if (i < 0 || !/^\|[\s:|-]+\|$/.test((linhas[i + 1] || '').trim())) return null;
  const cab = celulas(linhas[i]);
  const corpo = [];
  for (let k = i + 2; k < linhas.length && linhas[k].startsWith('|'); k++) corpo.push(celulas(linhas[k]));
  return { cab, corpo };
}

// ── tabela Word ─────────────────────────────────────────────────────────────
function tabelaWord({ cab, corpo }, larguras) {
  const total = larguras.reduce((a, b) => a + b, 0);
  const borda = { style: BorderStyle.SINGLE, size: 4, color: BORDA };
  const bordas = { top: borda, bottom: borda, left: borda, right: borda };
  const cel = (txt, w, opts = {}) => new TableCell({
    width: { size: w, type: WidthType.DXA },
    shading: opts.cabec ? { type: ShadingType.CLEAR, fill: CABEC } : undefined,
    margins: { top: 80, bottom: 80, left: 110, right: 110 },
    children: [new Paragraph({
      children: runs(txt, { size: 18, bold: !!opts.cabec, color: opts.cabec ? TEXTO : undefined }),
      spacing: { after: 0 },
    })],
  });
  return new Table({
    width: { size: total, type: WidthType.DXA },
    columnWidths: larguras,
    borders: bordas,
    rows: [
      new TableRow({ tableHeader: true, children: cab.map((c, i) => cel(c, larguras[i], { cabec: true })) }),
      ...corpo.map((linha) => new TableRow({
        children: larguras.map((w, i) => cel(linha[i] ?? '', w)),
      })),
    ],
  });
}

// ── um Feature Set ──────────────────────────────────────────────────────────
function blocoN2(arquivo, pastaFluxos, avisos) {
  const md = fs.readFileSync(arquivo, 'utf8');
  const slug = path.basename(path.dirname(arquivo));
  const nome = (/^#\s+Feature Set:\s*(.+)$/m.exec(md) || [, slug])[1].trim();
  const meta = /^>\s*\*\*Nível 2\*\*\s*-\s*Domínio:\s*([^-]+)-\s*`([^`]+)`/m.exec(md);
  const dominio = meta ? meta[1].trim() : '';
  const codigo = meta ? meta[2].trim() : '';
  const sec = secoes(md);
  const filhos = [];

  filhos.push(new Paragraph({
    heading: HeadingLevel.HEADING_1,
    spacing: { before: 240, after: 60 },
    children: [new TextRun({ text: nome, bold: true, color: TEXTO, size: 32 })],
  }));
  filhos.push(new Paragraph({
    spacing: { after: 220 },
    children: [new TextRun({ text: `${codigo} · Domínio: ${dominio}`, color: SUAVE, size: 19 })],
  }));

  const titulo = (t) => new Paragraph({
    heading: HeadingLevel.HEADING_2,
    spacing: { before: 260, after: 100 },
    children: [new TextRun({ text: t, bold: true, color: MARCA, size: 24 })],
  });

  // Descrição — prosa
  if (sec['Descrição']) {
    filhos.push(titulo('Descrição'));
    for (const l of sec['Descrição']) {
      const t = l.trim();
      if (t && t !== '---') filhos.push(P(t));
    }
  }

  // Features
  const tf = sec['Features'] && tabela(sec['Features']);
  if (tf) {
    filhos.push(titulo('Features'));
    filhos.push(tabelaWord(tf, [3100, 1200, 4900]));
  }

  // Fluxo — imagem renderizada, ou o código-fonte com aviso
  if (sec['Fluxo Principal']) {
    filhos.push(titulo('Fluxo principal'));
    const png = pastaFluxos && path.join(pastaFluxos, `${slug}.png`);
    if (png && fs.existsSync(png)) {
      const dim = tamanhoPng(png);
      // Escalar só pela largura deixa passar o diagrama ALTO e estreito: ele cabe
      // na largura, não cabe na página, e o Word o empurra sozinho para a folha
      // seguinte. A altura entra na conta com folga para o título da seção.
      const larguraMax = 6.1;  // polegadas úteis com as margens de 0,75"
      const alturaMax = 8.0;
      const escala = Math.min(1, larguraMax / (dim.w / 96), alturaMax / (dim.h / 96));
      filhos.push(new Paragraph({
        alignment: AlignmentType.CENTER,
        spacing: { after: 200 },
        children: [new ImageRun({
          type: 'png',
          data: fs.readFileSync(png),
          transformation: {
            width: Math.round((dim.w / 96) * escala * 96),
            height: Math.round((dim.h / 96) * escala * 96),
          },
        })],
      }));
    } else {
      avisos.push(`${slug}: sem imagem do fluxo — entrou o código Mermaid`);
      const src = sec['Fluxo Principal'].join('\n').replace(/```mermaid|```/g, '').trim();
      for (const l of src.split('\n')) {
        filhos.push(new Paragraph({
          spacing: { after: 0 },
          children: [new TextRun({ text: l, font: 'Consolas', size: 16, color: SUAVE })],
        }));
      }
    }
  }

  // Dependências — itens
  if (sec['Dependências entre features']) {
    filhos.push(titulo('Dependências entre features'));
    for (const l of sec['Dependências entre features']) {
      const m = /^[-*]\s+(.+)$/.exec(l.trim());
      if (m) filhos.push(new Paragraph({ children: runs(m[1]), bullet: { level: 0 }, spacing: { after: 100 } }));
    }
  }

  // Telas
  const tt = sec['Telas'] && tabela(sec['Telas']);
  if (tt) {
    filhos.push(titulo('Telas'));
    filhos.push(tabelaWord(tt, [2000, 2600, 2400, 2200]));
  }

  // Permissões — a matriz é a fonte única; as notas abaixo dela também
  if (sec['Permissões por perfil']) {
    filhos.push(titulo('Permissões por perfil'));
    const linhas = sec['Permissões por perfil'];
    const tp = tabela(linhas);
    for (const l of linhas) {
      const t = l.trim();
      if (!t || t === '---' || t.startsWith('|')) continue;
      if (t.startsWith('>')) { filhos.push(P(t.replace(/^>\s*/, ''), { spacing: { after: 120 } })); continue; }
      if (/^[-*]\s+/.test(t)) continue;
      if (!t.startsWith('###')) filhos.push(P(t));
    }
    if (tp) {
      const n = tp.cab.length;
      const larg = [2400, ...Array(n - 1).fill(Math.floor(6800 / (n - 1)))];
      filhos.push(tabelaWord(tp, larg));
      filhos.push(new Paragraph({ spacing: { after: 80 }, children: [] }));
    }
    for (const l of linhas) {
      const m = /^[*-]\s+(.+)$/.exec(l.trim());
      if (m) filhos.push(new Paragraph({ children: runs(m[1]), bullet: { level: 0 }, spacing: { after: 100 } }));
    }
  }

  return filhos;
}

// dimensões de um PNG sem dependência externa (IHDR nos bytes 16–24)
function tamanhoPng(arq) {
  const b = fs.readFileSync(arq);
  return { w: b.readUInt32BE(16), h: b.readUInt32BE(20) };
}

// ── documento ───────────────────────────────────────────────────────────────
function main() {
  const args = process.argv.slice(2);
  const dominio = args.find((a) => !a.startsWith('-'));
  const saida = args.includes('-o') ? args[args.indexOf('-o') + 1] : `N2-${dominio}.docx`;
  const fluxos = args.includes('--fluxos') ? args[args.indexOf('--fluxos') + 1] : null;
  if (!dominio) {
    console.error('Uso: node scripts/gera-doc-n2.js <dominio> [-o saida.docx] [--fluxos <pasta>]');
    process.exit(2);
  }
  const base = path.join('modules', dominio);
  if (!fs.existsSync(base)) { console.error(`✗ domínio não encontrado: ${base}`); process.exit(1); }

  const arquivos = fs.readdirSync(base)
    .map((d) => path.join(base, d, 'README.md'))
    .filter((f) => fs.existsSync(f))
    .sort();
  if (!arquivos.length) { console.error(`✗ nenhum N2 em ${base}`); process.exit(1); }

  const n1 = fs.existsSync(path.join(base, 'README.md'))
    ? fs.readFileSync(path.join(base, 'README.md'), 'utf8') : '';
  const nomeDominio = (/^#\s+(?:Domínio:\s*)?(.+)$/m.exec(n1) || [, dominio])[1].trim();

  const avisos = [];
  const corpo = [];
  arquivos.forEach((f, i) => {
    if (i) corpo.push(new Paragraph({ children: [new PageBreak()] }));
    corpo.push(...blocoN2(f, fluxos, avisos));
  });

  const hoje = new Date().toISOString().slice(0, 10);
  const capa = [
    new Paragraph({ spacing: { before: 2400, after: 120 }, children: [
      new TextRun({ text: 'Prêmio IEL de Talentos', color: SUAVE, size: 26 })] }),
    new Paragraph({ spacing: { after: 100 }, children: [
      new TextRun({ text: `Especificação — ${nomeDominio}`, bold: true, color: TEXTO, size: 52 })] }),
    new Paragraph({ spacing: { after: 600 }, children: [
      new TextRun({ text: `Nível 2 · Feature Sets · ${arquivos.length} no domínio`, color: MARCA, size: 24 })] }),
    new Paragraph({ spacing: { after: 60 }, children: [
      new TextRun({ text: `Gerado de modules/${dominio}/ em ${hoje}.`, color: SUAVE, size: 19 })] }),
    new Paragraph({ spacing: { after: 60 }, children: [
      new TextRun({ text: 'Documento derivado: a fonte é o repositório de especificação. '
        + 'Mudou a spec, gere de novo — não edite este arquivo.', color: SUAVE, size: 19 })] }),
    new Paragraph({ children: [new PageBreak()] }),
    new Paragraph({ spacing: { after: 160 }, heading: HeadingLevel.HEADING_1, children: [
      new TextRun({ text: 'Sumário', bold: true, color: TEXTO, size: 32 })] }),
    new TableOfContents('Sumário', { hyperlink: true, headingStyleRange: '1-2' }),
    new Paragraph({ children: [new PageBreak()] }),
  ];

  const doc = new Document({
    creator: 'docqui', title: `Especificação — ${nomeDominio}`,
    numbering: { config: [{ reference: 'lista', levels: [{
      level: 0, format: LevelFormat.BULLET, text: '•', alignment: AlignmentType.LEFT,
      style: { paragraph: { indent: { left: convertInchesToTwip(0.3), hanging: convertInchesToTwip(0.18) } } },
    }] }] },
    styles: { default: { document: { run: { font: 'Calibri', size: 21, color: TEXTO } } } },
    sections: [{
      properties: { page: {
        size: { orientation: PageOrientation.PORTRAIT },
        margin: { top: 1080, bottom: 1080, left: 1080, right: 1080 },
      } },
      children: [...capa, ...corpo],
    }],
  });

  Packer.toBuffer(doc).then((buf) => {
    fs.writeFileSync(saida, buf);
    console.log(`✓ ${arquivos.length} Feature Set(s) em ${saida} — ${Math.round(buf.length / 1024)} KB`);
    if (avisos.length) {
      console.warn(`⚠️  ${avisos.length} fluxo(s) sem imagem:`);
      avisos.forEach((a) => console.warn(`      ${a}`));
      console.warn('    Gere com: node scripts/render-mermaid.mjs modules/<dominio>/*/README.md');
    }
  });
}

main();

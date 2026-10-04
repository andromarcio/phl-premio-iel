#!/usr/bin/env node
// gera-standalone.mjs — empacota o visualizador num ÚNICO arquivo .html.
//
// Para quê: consultar a base fora do PC — celular, tablet, um anexo de e-mail,
// um pendrive. O site normal (index.html + assets/) precisa de servidor: aberto
// por `file://` os `<script src>` até carregam, mas o conjunto fica frágil e
// não dá para mandar por mensagem. Este empacotador resolve inlinando tudo:
// CSS, JS, dados da árvore, mapa e logotipos viram data URI.
//
// Uso:  node scripts/gera-standalone.mjs [saida.html] [--fragmento]
//       (padrão: premio-iel-standalone.html na raiz)
//
// --fragmento: sai sem <!doctype>/<html>/<head>/<body>, para hospedagens que
// embrulham o conteúdo num esqueleto próprio (ex.: publicar como Artifact).
// O <title> é preservado — é ele que dá nome à página no destino.
//
// --somente-n3: versão leve para leitura no celular. Mantém como CONTEÚDO só
// as features (N3), preservando os README de domínio e Feature Set porque é
// deles que saem os rótulos da árvore e da trilha — sem eles a navegação cai
// para nomes de pasta. Sai tudo o mais: prompts do engine, dicionários,
// protótipos, backlog, QA. E sai o mermaid (3,5 MB, dois terços do arquivo):
// nenhum N3 tem diagrama, e o visualizador já trata a ausência da biblioteca.
//
// Regenerar SEMPRE depois de mexer em index.html, assets/ ou nos .md — o
// arquivo é um retrato, não um link: `node assets/generate-tree.js` e
// `node scripts/gera-mapa-features.mjs` primeiro, este depois.

import { readFileSync, writeFileSync, statSync } from 'node:fs';
import { join } from 'node:path';

const ROOT = new URL('..', import.meta.url).pathname;
const args = process.argv.slice(2);
const FRAGMENTO = args.includes('--fragmento');
const SOMENTE_N3 = args.includes('--somente-n3');
const SAIDA = args.find((a) => !a.startsWith('--')) || join(ROOT, 'premio-iel-standalone.html');
// --titulo "…": nome da página no destino. O <title> do index.html serve à aba
// do navegador; numa galeria de artefatos vale um nome próprio, sem o rótulo
// de categoria.
const TITULO = (args.find((a) => a.startsWith('--titulo=')) || '').slice('--titulo='.length);

const ler = (rel) => readFileSync(join(ROOT, rel), 'utf8');
const kb = (n) => (n / 1024).toFixed(0) + ' KB';

let html = ler('index.html');
const orig = html.length;

// ── 0. Modo fragmento: descasca o esqueleto ANTES de embutir ────────────────
// Precisa vir antes: depois de inlinar, `</body>` e `</head>` aparecem dentro
// de strings do JS de terceiros (o mermaid monta HTML por string) e um regex
// ingênuo truncaria o arquivo no meio. No index.html cru essas tags só
// existem uma vez, como estrutura do documento.
if (FRAGMENTO) {
  const titulo = (html.match(/<title>[\s\S]*?<\/title>/i) || [''])[0];
  html = html
    .replace(/^[\s\S]*?<head[^>]*>/i, '')
    .replace(/<\/head\s*>/i, '')
    .replace(/<body[^>]*>/i, '')
    .replace(/<\/body\s*>[\s\S]*$/i, '')
    .replace(/<meta[^>]*>/gi, '')          // charset e viewport são do host
    .trim();
  // O <title> volta ao topo: o destino o lê nos primeiros KB para nomear a página.
  html = titulo + '\n' + html.replace(titulo, '');
}
const embutidos = [];
const descartados = [];

// Reduz o tree.js às features e ao esqueleto de navegação. O arquivo declara
// `repoFiles` (caminhos) e `repoFilesContent` (conteúdo); avaliamos os dois,
// filtramos e reserializamos — mais seguro que recortar por regex num arquivo
// de 1,3 MB com markdown embutido.
function apenasFeatures(src) {
  const { repoFiles, repoFilesContent } = new Function(src + '\nreturn { repoFiles, repoFilesContent };')();
  const eN3 = (p) => /^modules\/[^/]+\/[^/]+\/f-[^/]+\.md$/.test(p);
  const eEsqueleto = (p) => /^modules\/[^/]+\/(?:[^/]+\/)?README\.md$/.test(p);
  const fica = repoFiles.filter((p) => eN3(p) || eEsqueleto(p));

  const conteudo = {};
  for (const p of fica) {
    let c = repoFilesContent[p] ?? '';
    // Sem a biblioteca de diagramas, o bloco mermaid apareceria como um bolo de
    // texto cru no meio do N2 — melhor dizer o que falta e onde encontrá-lo.
    if (eEsqueleto(p)) {
      c = c.replace(/```mermaid[\s\S]*?```/g,
        '> *(diagrama de fluxo — disponível na versão completa da base)*');
    }
    conteudo[p] = c;
  }
  console.log('  tree.js filtrado: ' + repoFiles.length + ' → ' + fica.length + ' arquivos ('
    + fica.filter(eN3).length + ' features + ' + fica.filter(eEsqueleto).length + ' README de navegação)');
  return '// Filtrado por scripts/gera-standalone.mjs --somente-n3\n'
    + 'const repoFiles = ' + JSON.stringify(fica, null, 0) + ';\n'
    + 'const repoFilesContent = ' + JSON.stringify(conteudo) + ';\n';
}

// ── 1. Folhas de estilo locais → <style> ────────────────────────────────────
html = html.replace(/[ \t]*<link[^>]*href="((?:assets|identidade-visual)\/[^"]+\.css)"[^>]*>/g, (m, rel) => {
  const css = ler(rel);
  embutidos.push([rel, css.length]);
  return '<style>\n/* ↓ ' + rel + ' */\n' + css + '\n</style>';
});

// ── 2. Scripts locais → <script> ────────────────────────────────────────────
// A ordem original é preservada (tree.js antes do app, mermaid antes do uso).
html = html.replace(/[ \t]*<script[^>]*src="((?:assets|identidade-visual)\/[^"]+\.js)"[^>]*><\/script>/g, (m, rel) => {
  if (SOMENTE_N3 && rel.includes('mermaid')) {
    descartados.push([rel, ler(rel).length]);
    return '<!-- mermaid omitido nesta versão leve: nenhum N3 tem diagrama -->';
  }
  const js = rel.endsWith('tree.js') && SOMENTE_N3 ? apenasFeatures(ler(rel)) : ler(rel);
  embutidos.push([rel, js.length]);
  // `</script>` dentro de string JS encerraria a tag do host — escapa.
  return '<script>\n/* ↓ ' + rel + ' */\n' + js.replace(/<\/script>/gi, '<\\/script>') + '\n</script>';
});

// ── 3. Imagens locais → data URI ────────────────────────────────────────────
const MIME = { svg: 'image/svg+xml', png: 'image/png', jpg: 'image/jpeg', jpeg: 'image/jpeg', ico: 'image/x-icon' };
html = html.replace(/(src|href)="((?:assets|identidade-visual)\/[^"]+\.(svg|png|jpe?g|ico))"/g, (m, attr, rel, ext) => {
  const bin = readFileSync(join(ROOT, rel));
  embutidos.push([rel, bin.length]);
  return attr + '="data:' + MIME[ext.toLowerCase()] + ';base64,' + bin.toString('base64') + '"';
});

// ── 4. Aviso no topo, para ninguém confundir o retrato com o site ───────────
const hoje = new Date().toISOString().slice(0, 10);
if (!FRAGMENTO) html = html.replace(/<head>/i, '<head>\n<!--\n  RETRATO AUTOCONTIDO da base de documentação — gerado em ' + hoje + '\n'
  + '  por scripts/gera-standalone.mjs. Tudo embutido: abre offline, sem servidor.\n'
  + '  NÃO é o site: não se atualiza sozinho. Regere depois de alterar os .md.\n-->');

if (TITULO) html = html.replace(/<title>[\s\S]*?<\/title>/i, '<title>' + TITULO + '</title>');

writeFileSync(SAIDA, html);

console.log('standalone gerado: ' + SAIDA);
console.log('  ' + kb(orig) + ' (index.html) → ' + kb(statSync(SAIDA).size) + ' com ' + embutidos.length + ' recursos embutidos');
for (const [rel, tam] of embutidos.sort((a, b) => b[1] - a[1])) {
  console.log('    ' + kb(tam).padStart(9) + '  ' + rel);
}
for (const [rel, tam] of descartados) {
  console.log('    ' + ('−' + kb(tam)).padStart(9) + '  ' + rel + '  (descartado)');
}

// Rede zerada é o requisito: se sobrou referência local, o arquivo não é
// autocontido e falharia no celular sem avisar.
const sobras = [...html.matchAll(/(?:src|href)="((?:assets|identidade-visual|modules|global|prototypes)\/[^"]+)"/g)]
  .map((m) => m[1]).filter((v, i, a) => a.indexOf(v) === i);
if (sobras.length) {
  console.log('\n⚠️  referências locais NÃO embutidas (o arquivo não é autocontido):');
  for (const s of sobras) console.log('    ' + s);
  process.exit(1);
}
console.log('\n✓ autocontido — nenhuma referência local pendente (só as fontes do Google, que degradam para fontes do sistema offline).');

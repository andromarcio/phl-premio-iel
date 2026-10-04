#!/usr/bin/env node
/**
 * render-mermaid.mjs — renderiza o `## Fluxo Principal` de cada N2 em PNG.
 *
 *   node scripts/render-mermaid.mjs <arquivo.md ...> [--saida <pasta>]
 *
 * Existe para o `gera-doc-n2.js`: no markdown o fluxo é Mermaid, que o Word não
 * entende. As imagens saem com o nome da pasta do Feature Set, que é como o
 * gerador do documento as procura.
 *
 * Precisa do pacote `mermaid` e do Playwright. Nenhum dos dois é dependência do
 * repositório — instale onde for rodar (`npm i mermaid playwright`) e, se o
 * navegador do ambiente for outro, aponte CHROMIUM_PATH para o executável.
 * O bundle é lido do disco de propósito: em ambiente com egress restrito o CDN
 * não responde, e um diagrama que só renderiza com internet não serve.
 */
import { chromium } from 'playwright';
import { readFileSync, mkdirSync, existsSync } from 'fs';
import { join, dirname, basename } from 'path';
import { createRequire } from 'module';

const req = createRequire(import.meta.url);
const args = process.argv.slice(2);
const saidaDir = args.includes('--saida') ? args[args.indexOf('--saida') + 1] : 'fluxos';
const arquivos = args.filter((a) => a.endsWith('.md'));
if (!arquivos.length) {
  console.error('Uso: node scripts/render-mermaid.mjs <arquivo.md ...> [--saida <pasta>]');
  process.exit(2);
}

let lib;
try {
  lib = readFileSync(req.resolve('mermaid/dist/mermaid.min.js'), 'utf8');
} catch {
  console.error('✗ pacote `mermaid` não encontrado. Instale com `npm i mermaid` no diretório de onde você roda.');
  process.exit(2);
}

if (!existsSync(saidaDir)) mkdirSync(saidaDir, { recursive: true });
const navegador = await chromium.launch(
  process.env.CHROMIUM_PATH ? { executablePath: process.env.CHROMIUM_PATH } : {});
const pag = await navegador.newPage({ viewport: { width: 1400, height: 900 }, deviceScaleFactor: 2 });
const erros = [];
pag.on('pageerror', (e) => erros.push(e.message));

let feitos = 0;
for (const arq of arquivos) {
  const m = /```mermaid\n([\s\S]*?)```/.exec(readFileSync(arq, 'utf8'));
  if (!m) { console.log(`  — ${arq}: sem bloco mermaid`); continue; }
  const nome = basename(dirname(arq));
  await pag.setContent(`<!doctype html><html><head><meta charset="utf-8">
    <style>body{margin:0;padding:24px;background:#fff}</style>
    <script>${lib}</script></head>
    <body><pre class="mermaid">${m[1].replace(/</g, '&lt;')}</pre>
    <script>mermaid.initialize({startOnLoad:true,theme:'base',themeVariables:{
      primaryColor:'#EAF2F8',primaryTextColor:'#0A2440',primaryBorderColor:'#3B8580',
      lineColor:'#5B7A94',fontFamily:'IBM Plex Sans, Arial, sans-serif',fontSize:'15px'}});
    </script></body></html>`);
  await pag.waitForSelector('.mermaid svg', { timeout: 15000 }).catch(() => {});
  const svg = await pag.$('.mermaid svg');
  if (!svg) { console.error(`  ✗ ${nome}: não renderizou`); continue; }
  const saida = join(saidaDir, `${nome}.png`);
  await svg.screenshot({ path: saida });
  console.log(`  ✓ ${nome} → ${saida}`);
  feitos++;
}

await navegador.close();
console.log(erros.length ? `\n✗ erros de página: ${erros.join(' | ')}` : `\n✓ ${feitos} fluxo(s) renderizado(s), sem erro de página.`);
if (erros.length) process.exit(1);

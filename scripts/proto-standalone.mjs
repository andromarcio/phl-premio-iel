#!/usr/bin/env node
/**
 * Gera a versão autocontida de um protótipo: embute o `ds.css` (e qualquer
 * outro stylesheet relativo) no próprio HTML, para o arquivo poder ser baixado
 * e aberto sozinho — em Downloads, anexo de e-mail, pen drive.
 *
 *   node scripts/proto-standalone.mjs <protótipo.html> [saída.html]
 *
 * Por que existe: os protótipos referenciam `../../_biblioteca-ds/ds.css`, que
 * é o certo dentro do repositório (uma cópia só do design system). Fora dele o
 * caminho quebra e a página abre SEM ESTILO NENHUM — telas empilhadas e ícones
 * gigantes —, o que parece defeito do protótipo e não é. Sempre entregue a
 * versão gerada por este script quando o arquivo for sair do repositório.
 */
import { readFileSync, writeFileSync, existsSync, statSync } from 'fs';
import { dirname, resolve, basename, join } from 'path';

/**
 * Lê um CSS resolvendo os `@import` em cadeia. Sem isto o arquivo sai sem os
 * TOKENS: o `ds.css` importa `tokens.css`, e uma vez embutido no HTML esse
 * @import passa a resolver a partir da pasta do HTML — onde tokens.css não
 * existe. O resultado abre com a estrutura certa e nenhuma cor.
 */
function leCssResolvido(arquivo, vistos = new Set()) {
  const abs = resolve(arquivo);
  if (vistos.has(abs)) return '';
  vistos.add(abs);
  if (!existsSync(abs)) { console.error(`  ✗ não encontrei ${arquivo}`); process.exit(1); }
  const base = dirname(abs);
  return readFileSync(abs, 'utf8').replace(
    /@import\s+url\(\s*["']?([^"')]+)["']?\s*\)\s*;/g,
    (_, href) => (/^https?:/.test(href)
      ? `/* @import externo mantido: ${href} */`
      : `/* ↓ ${href} */\n` + leCssResolvido(join(base, href), vistos))
  );
}

const [entrada, saidaArg] = process.argv.slice(2);
if (!entrada || !existsSync(entrada)) {
  console.error('Uso: node scripts/proto-standalone.mjs <protótipo.html> [saída.html]');
  process.exit(2);
}
const saida = saidaArg || join(dirname(entrada), basename(entrada, '.html') + '.standalone.html');

let html = readFileSync(entrada, 'utf8');
const links = [...html.matchAll(/<link[^>]+rel="stylesheet"[^>]*href="([^"]+)"[^>]*>/g)];
let embutidos = 0;

for (const [tag, href] of links) {
  if (/^https?:/.test(href)) { console.warn(`  ⚠ stylesheet externo mantido: ${href}`); continue; }
  const arquivo = resolve(dirname(entrada), href);
  if (!existsSync(arquivo)) { console.error(`  ✗ não encontrei ${href} (a partir de ${entrada})`); process.exit(1); }
  html = html.replace(tag, `<style>\n/* ===== ${href} embutido (com os @import resolvidos) ===== */\n${leCssResolvido(arquivo)}\n</style>`);
  embutidos++;
}

writeFileSync(saida, html);
/* Varre só o MARCADO: tag <link>/<script> de verdade. Procurar o caminho como
   texto solto dá falso positivo — o cabeçalho do ds.css cita o próprio <link>. */
const semBlocos = html.replace(/<style[\s\S]*?<\/style>/g, '').replace(/<script[\s\S]*?<\/script>/g, '');
const restantes = [...semBlocos.matchAll(/<(?:link|script|img)[^>]+(?:src|href)="((?!https?:|#|data:|mailto:)[^"]+)"/g)].map((m) => m[1]);
console.log(`✓ ${saida} — ${Math.round(statSync(saida).size / 1024)} KB · ${embutidos} stylesheet(s) embutido(s)`);
if (restantes.length) {
  console.warn(`⚠ ainda há ${restantes.length} referência(s) relativa(s): ${[...new Set(restantes)].join(', ')}`);
  process.exit(1);
}
console.log('✓ nenhuma dependência relativa restante — abre sozinho.');

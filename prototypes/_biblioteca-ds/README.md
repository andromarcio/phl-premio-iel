# `_biblioteca-ds/` — biblioteca de componentes para protótipos (Prêmio IEL)

> ⚠️ **Exclusiva de protótipos.** As classes `.dsc-*` existem para tornar protótipos navegáveis — **nunca** aparecem no código de produção (lá entram os componentes reais do PrimeNG; ver o *Mapa de equivalência* em `global/DESIGN-SYSTEM.md`). Recomenda-se regra de lint na CI do front proibindo `dsc-` em templates — a presença denuncia cópia de protótipo.

HTML/CSS **sem build e sem dependências** para os protótipos do docqui (classes `.dsc-*`), reproduzindo fielmente o **sistema atual do Prêmio IEL de Talentos** (Angular + PrimeNG): marca **teal `#3B8580`** para ação/topbar, **roxo `#883CAE`** de apoio, **verde `#198754`** para criação e **raio pequeno 4px** (nunca pill em botões/inputs). É consumida pelos prompts de protótipo e pela skill `/prototype` — todo protótipo gerado linka o `ds.css` daqui.

> ℹ️ **Origem.** Esta biblioteca foi extraída por engenharia reversa do tema em produção (`arquivos/html/`) e das capturas (`arquivos/prints/`), a mesma fonte do `global/DESIGN-SYSTEM.md`. Os componentes em `ds.css` são **token-driven**: para ajustar cores/raios, altere `tokens.css` (`--dsc-*`) — não edite valores fixos no `ds.css`.

| Arquivo | O que é |
|---|---|
| [`ds.css`](ds.css) | Componentes `.dsc-*` (importa `tokens.css`) — **o link dos protótipos** |
| [`tokens.css`](tokens.css) | Tokens `--dsc-*`: cores, tipografia, espaçamento, raios, sombras |
| [`index.html`](index.html) | **Catálogo navegável** — shell, paleta, e todos os componentes com markup de exemplo |
| [`shell-responsive.html`](shell-responsive.html) | Demo do shell (topbar teal + menu horizontal + Estrutura) nos breakpoints |

## Como linkar

O caminho relativo depende da profundidade do protótipo dentro de `prototypes/`:

```html
<!-- prototypes/[dominio]/[feature-set]/flow.html -->
<link rel="stylesheet" href="../../_biblioteca-ds/ds.css">

<!-- prototypes/[dominio]/[feature-set]/[feature]/form.html -->
<link rel="stylesheet" href="../../../_biblioteca-ds/ds.css">
```

**Tema escuro** (conveniência de protótipo; o sistema atual é light-only): adicione a classe `app-dark` ao `<html>` ou `<body>`.

## O shell (protótipos FULL)

Estrutura canônica: **barra superior teal fixa** com a marca "Prêmio IEL" à esquerda e usuário/avatar à direita, **menu horizontal** logo abaixo (Dashboard · Administração · Premiação, item ativo em teal), conteúdo em **cards sobre o ground `#EFEFEF`** e **FAB** teal no canto inferior direito. As telas de configuração usam o layout de **duas colunas** `.dsc-config-layout` com o card **"Estrutura"** (árvore) à esquerda.

```html
<div class="dsc-app">
  <header class="dsc-topbar">
    <a class="dsc-topbar-brand" href="#">Prêmio IEL</a>
    <div class="dsc-topbar-user">
      <span class="dsc-topbar-name">Nome do Usuário</span>
      <span class="dsc-topbar-avatar"><!-- svg pessoa --></span>
    </div>
  </header>
  <nav class="dsc-navbar">
    <a class="dsc-nav-item" href="#">Dashboard</a>
    <a class="dsc-nav-item is-active" href="#">Premiação</a>
  </nav>
  <main class="dsc-main">
    <div class="dsc-config-layout">
      <aside class="dsc-structure">
        <div class="dsc-structure-title">Estrutura</div>
        <ul class="dsc-tree"> … </ul>
      </aside>
      <div><!-- página: page-header, abas, cards, tabela --></div>
    </div>
  </main>
  <button class="dsc-fab" aria-label="Estrutura"><!-- svg --></button>
</div>
```

Para uma tela de listagem (título + ações à direita, barra de filtros e tabela), troque o `.dsc-config-layout` por `.dsc-page-header` + `.dsc-filterbar` + `.dsc-table-wrap`. **Protótipo sem shell** (Storybook, iframe, doc técnica): use `<main class="dsc-component-only">…</main>` no lugar do bloco `.dsc-app`.

## Catálogo de classes

O markup de exemplo de cada componente está no [`index.html`](index.html) — **não invente variações**: se algo não está aqui, não existe na biblioteca.

| Grupo | Classes |
|---|---|
| Shell | `dsc-app` · `dsc-topbar` `dsc-topbar-brand` `dsc-topbar-user` `dsc-topbar-name` `dsc-topbar-avatar` · `dsc-navbar` `dsc-nav-item` `is-active` `dsc-nav-caret` · `dsc-main` `is-narrow` · `dsc-config-layout` `dsc-structure` `dsc-structure-title` · `dsc-fab` · `dsc-component-only` |
| Cabeçalho de página | `dsc-page-header` `dsc-page-title-wrap` `dsc-page-title` `dsc-page-subtitle` `dsc-page-actions` · `dsc-breadcrumb` `is-current` `dsc-sep` |
| Grid / utilitários | `dsc-row` `dsc-col-{1..12}` · `dsc-grid-{2,3,4}` `dsc-gap-{1,2,3}` · `dsc-flex` `dsc-items-center` `dsc-items-start` `dsc-justify-between` `dsc-justify-end` `dsc-wrap` · `dsc-divider` |
| Tipografia | `dsc-display` `dsc-title` `dsc-title-sm` `dsc-body` `dsc-body-sm` `dsc-caption` · `dsc-text-muted` `dsc-text-primary` `dsc-text-secondary` · `dsc-req` |
| Card | `dsc-card` `dsc-card-title` `dsc-card-header` |
| Botões | `dsc-btn` (+ `--create` `--secondary` `--neutral` `--outline` `--chromeless` `--danger` `--sm` `--icon` · `is-loading` `disabled`) · `dsc-segmented` · `dsc-icon-action` (+ `--primary` `--info` `--success` `--danger`) |
| Formulários | `dsc-field` (+ `is-invalid`) `dsc-field-label` `dsc-field-hint` `dsc-field-error` `dsc-field-action` · `dsc-input` `dsc-textarea` `dsc-select` `dsc-input-icon` `dsc-search` · `dsc-check` `dsc-radio` `dsc-switch` (+ `is-on`) `dsc-slider` `dsc-number` `dsc-number-spin` `dsc-stepper` · `dsc-money` `dsc-pin` `dsc-input-chips` `dsc-calendar` · `dsc-filterbar` `dsc-filterbar-actions` |
| Tabela | `dsc-table-wrap` `dsc-table` (+ `--dense`) · `dsc-col-check` `dsc-col-actions` · `dsc-sortable` (+ `is-sorted`) `dsc-num` `dsc-cell-editable` · `tr.is-selected` · `dsc-table-empty` · `dsc-pagination` `dsc-pagination-info` `dsc-pagination-controls` `dsc-pagination-btn` (+ `is-current`) `dsc-pagination-size` · `dsc-lv` `dsc-lv-label` `dsc-lv-value` |
| Abas | `dsc-tabs` `dsc-tab` (+ `is-active`) |
| Modal | `dsc-modal-mask` `dsc-modal` (+ `--lg`) `dsc-modal-header` `dsc-modal-close` `dsc-modal-body` `dsc-modal-footer` `dsc-modal-footer-start` |
| Árvore (Estrutura) | `dsc-tree` `dsc-tree-row` (+ `--root` `is-selected` `is-collapsed`) `dsc-tree-toggle` (+ `is-empty`) `dsc-tree-icon` `dsc-tree-label` |
| Lista reordenável | `dsc-reorder` `dsc-reorder-item` `dsc-reorder-handle` `dsc-reorder-index` `dsc-reorder-body` `dsc-reorder-actions` |
| Feedback | `dsc-toast` (+ `--positive` `--danger` `--warning`) · `dsc-alert` (+ `--success` `--warning` `--danger`, `dsc-alert-cta`) · `dsc-badge` (+ `--success` `--neutral` `--info` `--warning` `--danger` `--sm`) · `dsc-tag` (+ `--highlight` `--secondary` `--neutral` `--success` `--info` `--warning` `--danger` `--sm` `--lg`) · `dsc-chip` · `dsc-avatar` (+ `--sm`) |
| Estados de tela | `dsc-skeleton` · `dsc-state` `dsc-state-icon` `dsc-state-title` `dsc-state-text` · `dsc-spinner` `dsc-loading-inline` · `dsc-progress` |
| Protótipo | `dsc-proto-badge` · `dsc-proto-notes` · `dsc-screen` (+ `is-active`) |

## Fonte e ícones

O sistema usa a **pilha de fontes do sistema** (`-apple-system, "Segoe UI", Roboto, …`) — não há fonte proprietária embutida, então nada a instalar. Os ícones são **SVG inline** no markup dos exemplos (traço fino, estilo PrimeIcons) — **sem CDN**: a biblioteca é 100% offline. Em produção esses SVGs dão lugar aos PrimeIcons/Font Awesome do tema.

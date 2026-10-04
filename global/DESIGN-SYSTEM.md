<!-- docqui: 2.8.0 | prompt: DESIGN-SYSTEM | atualizado: 2026-08-27 -->
# DESIGN-SYSTEM.md
> Padrões de interface, componentes e escrita do **Prêmio IEL de Talentos**. Cole em sessões que envolvam criação ou alteração de telas e protótipos.
>
> **Base visual**: extraída por engenharia reversa do **sistema atual em produção** — CSS do tema (`arquivos/html/`) + 30 capturas de tela (`arquivos/prints/`). Stack de UI: **Angular + PrimeNG** com tema customizado (base Bootstrap-flavored). Fonte: pilha de sistema (sem web-font proprietária). Raio pequeno (4px), superfícies claras, densidade média.
>
> **Biblioteca pronta para protótipos**: [`prototypes/_biblioteca-ds/`](../prototypes/_biblioteca-ds/README.md) — HTML/CSS sem build (classes `.dsc-*`) que reproduz este design; todo protótipo linka o `ds.css` de lá.
>
> **Marca (confirmada pelo produto)**: a identidade deste sistema é a do **Prêmio IEL**. A barra superior e as ações usam **verde-petróleo (teal) `#3B8580`** como **cor primária**; o **roxo `#883CAE`** (token `--primary-color` do tema PrimeNG) é a **cor de apoio** — contornos secundários, seleção e foco. O kit `identidade-visual/` ("aval", azul/verde) **não é adotado aqui**: os protótipos seguem a identidade **Prêmio IEL** (teal primário + roxo de apoio).

---

## Fundamentos

### Cores

**Marca e ação**

| Papel | Nome | Hex | Onde aparece |
|---|---|---|---|
| Primária (marca) | Verde-petróleo / Teal | `#3B8580` | Barra superior (gradiente), botões de confirmação (Salvar, Aplicar, Filtrar, Importar), aba/menu ativo, FAB |
| Primária — hover | Teal escuro | `#2F6A66` | Estado hover/pressionado do botão primário |
| Primária — realce | Teal claro | `#E7F1F0` | Fundo do item selecionado na árvore, realce sutil |
| Criação / positiva | Verde | `#198754` | Botões "Novo/Adicionar" (com ícone +), badge "Ativo", switch ligado |
| Apoio / destaque (tema) | Roxo | `#883CAE` | Botões de contorno secundários (ex.: "Baixar Template"), seleção PrimeNG, anel de foco |
| Link / navegação | Azul | `#0D6EFD` | Links, paginação, ícones de ação (editar/configurar), badge informativo |

**Semânticas (status)** — par fundo claro + cor forte (base Bootstrap):

| Status | Forte | Fundo | Uso |
|---|---|---|---|
| Sucesso | `#198754` | `#E7F4EA` | Badge "Ativo", confirmações, toast de sucesso |
| Erro / perigo | `#DC3545` | `#F7CFD2` | Validação, ação destrutiva (inativar/excluir), asterisco de obrigatório |
| Alerta | `#FFC107` | `#FFF0C3` | Avisos; texto sobre alerta usa tom escuro `#B38705` |
| Informação | `#0D6EFD` | `#C5DCFF` | Dicas, contadores ("0 selecionada(s)"), links |

**Superfícies e texto** (grayscale do tema):

| Token | Hex | Uso |
|---|---|---|
| Superfície 0 (card/header) | `#FFFFFF` | Cards, tabelas, formulários, modais, barra de filtros |
| Ground (fundo da app) | `#EFEFEF` | Fundo geral atrás dos cards |
| Hover / zebra | `#E9ECEF` | Hover de linha, faixa alternada |
| Borda / divisor | `#DEE2E6` | Bordas de card/input, divisores de linha |
| Texto principal | `#212529` | Títulos e corpo |
| Texto secundário | `#495057` | Rótulos, texto de apoio |
| Texto suave / placeholder | `#6C757D` | Placeholder, legendas, cabeçalho de tabela |

### Tipografia

- **Família**: pilha de sistema — `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif`. Ícones: **PrimeIcons** (+ Font Awesome no `all.min.css`). Não há fonte proprietária embutida.
- **Base**: 14px (escala PrimeNG). Escala observada:

| Papel | Tamanho / peso |
|---|---|
| Título de página ("Premiações", "Editar Categoria") | 28px · 600 · `#212529` |
| Título de seção / card ("Sub Modalidades") | 20px · 600 |
| Subtítulo / rótulo de campo | 14px · 600 |
| Corpo / célula de tabela | 14px · 400 |
| Legenda / auxiliar ("Deixe vazio para não limitar.") | 12–13px · 400 · `#6C757D` |

### Forma, espaçamento e elevação

- **Raio**: **4px** em botões, inputs, selects, cards internos e caixas; **6px** em cards/modais; **pill** (arredondado total) em badges de status, tags e switches. *(É o traço mais distintivo — cantos discretos, nada de pill em botões.)*
- **Espaçamento**: grade de 4px (4 · 8 · 12 · 16 · 24 · 32 · 40). Padding de card ≈ 24px; gap de formulário ≈ 16px; padding de botão ≈ 8px 16px.
- **Elevação**: sombra sutil em cards (`0 1px 2px rgba(0,0,0,.06)`); sombra maior em modais/overlays (`0 10px 30px rgba(0,0,0,.15)`) sobre backdrop escuro translúcido.
- **Densidade**: média — linhas de tabela ~56px, inputs ~40px de altura.

### Iconografia

PrimeIcons (traço fino) e Font Awesome. Ícones sempre acompanham o texto em botões (à esquerda) e itens de menu. Ícones de ação em tabela: **editar** (lápis, azul/teal), **configurar** (engrenagem, azul), **inativar/bloquear** (círculo cortado, vermelho), **excluir** (lixeira, vermelho), **exportar** (planilha, verde). Nós da árvore usam ícones de troféu/pasta/pessoa.

---

## Layout e navegação

- **Barra superior fixa** (full width, ~64px): gradiente teal `#3B8580`, "Prêmio IEL" à esquerda (texto branco, peso 600), nome do usuário + avatar circular à direita.
- **Menu principal horizontal** logo abaixo (fundo claro): itens com ícone — **Dashboard**, **Administração ▾**, **Premiação ▾** (dropdowns). O item ativo recebe destaque teal.
- **Conteúdo** sobre o ground `#EFEFEF`, em **cards brancos**. Título da página à esquerda; **ações da página** (botões) alinhadas à direita, na mesma linha do título.
- **Telas de configuração** usam **duas colunas**: à esquerda um card **"Estrutura"** com a **árvore** (Premiação → Categoria → Modalidade → Tipo de Participante) expansível; à direita o conteúdo do nó selecionado (formulário, abas, listas).
- **Barra de filtros**: card branco com campos rotulados (texto, intervalo de datas, seleção) + botão **Filtrar** (teal) e **Limpar** (contorno neutro).
- **FAB** (botão flutuante circular teal) no canto inferior direito para atalho da estrutura.

---

## Componentes

> Anatomia e estados dos componentes recorrentes. A implementação usa os componentes **PrimeNG** correspondentes (ver *Mapa de equivalência*); os protótipos usam as classes `.dsc-*` da biblioteca.

### Botões

| Variante | Aparência | Uso |
|---|---|---|
| Primário | Fundo teal `#3B8580`, texto branco, ícone à esquerda, raio 4px | Salvar, Aplicar, Filtrar, Importar |
| Criação | Fundo verde `#198754`, texto branco, ícone `+` | Nova Premiação, Nova Sub Modalidade, Adicionar Questão |
| Secundário (contorno) | Fundo branco, borda + texto roxo `#883CAE` | Baixar Template, ações de apoio |
| Neutro (contorno) | Fundo branco, borda cinza `#DEE2E6`, texto `#495057` | Cancelar, Limpar |
| Perigo | Texto/ícone vermelho `#DC3545` (link ou contorno) | Excluir, Restaurar Padrão, Inativar |

Estados: hover escurece ~8%; foco mostra anel translúcido (roxo/teal 3px); desabilitado reduz opacidade. Altura ~40px.

### Campos de formulário

- **Rótulo** acima do campo, 14px/600, com **asterisco vermelho** quando obrigatório (`Nome *`).
- **Input de texto / textarea / select / número (spinner) / intervalo de datas**: fundo branco, borda `#DEE2E6` (1px), raio 4px, foco com borda teal/roxa + anel. Placeholder em `#6C757D`.
- **Segmented (toggle de opções)**: pílula com opções lado a lado; a ativa recebe fundo teal e texto branco (ex.: "Discursiva | Objetiva").
- **Switch**: pílula; verde `#198754` quando ligado, cinza quando desligado.
- **Checkbox**: quadrado 4px; marcado em teal/roxo.
- **Editor de texto rico** (modelos de e-mail): barra de ferramentas (negrito/itálico/lista/link/H1-H2) sobre o campo; painel lateral de *placeholders* clicáveis.
- **Ajuda inline**: legenda `#6C757D` abaixo do campo ("Deixe vazio para não limitar.").

### Barra de filtros

Card branco com campos rotulados em linha (Nome · Período · Situação) + Filtrar (teal) e Limpar (neutro). Recolhe em coluna no mobile.

### Tabela de dados

- Dentro de um card branco. **Cabeçalho**: texto `#6C757D`, colunas ordenáveis com seta. **Linhas**: ~56px, divisor `#DEE2E6`, hover `#E9ECEF`.
- Coluna **Situação**: badge/pílula (verde "Ativo"). Coluna **Ações** à direita: ícones (editar, configurar, inativar…).
- **Paginação** centralizada abaixo: "Mostrando X a Y de Z registros" + `«  ‹  1  ›  »` + seletor de itens por página (10 ▾). Números/controles em azul `#0D6EFD`.

### Badge / status (pílula)

Pílula arredondada, texto branco, ~12px: **verde** (Ativo/Sucesso), **cinza** (Inativo), **azul** (informativo/contador). Variante suave (fundo claro + texto forte) para rótulos como "DISCURSIVA", "Personalizado".

### Abas

Barra de abas com ícone + rótulo (ex.: Geral · Formulário de Inscrição · Sub Modalidades · Equipe · Anexos · Avaliação). A ativa: texto teal com sublinhado; inativas em `#6C757D`.

### Modal / diálogo

Centralizado, card branco raio 6px, sombra forte sobre backdrop escuro translúcido. **Cabeçalho**: título + `×`. **Corpo**: formulário. **Rodapé**: à direita, botão neutro (Cancelar) + ação (Aplicar/Salvar, teal); ação destrutiva (Restaurar Padrão) à esquerda em vermelho.

### Árvore de estrutura

Card "Estrutura" com nós expansíveis (chevron), ícones por nível (troféu/pasta/pessoa), nó selecionado com fundo teal claro `#E7F1F0`. Suporta reordenar por arrastar.

### Lista reordenável

Itens com alça de arraste (≡), numerados, com ações por item (engrenagem, subir/descer, lixeira) e asterisco de obrigatório.

---

## Estados de tela

> Textos literais do `global/MESSAGE-DICTIONARY.md` — nunca "conforme o Design System".

| Estado | Comportamento / texto |
|---|---|
| Carregando | Indicador + "Carregando…"; botão de ação desabilitado enquanto grava |
| Vazio (sem dados) | "Nenhum registro encontrado." |
| Busca sem resultado | "Nenhum resultado para a busca." |
| Erro ao carregar | "Não foi possível carregar os dados." |
| Erro de servidor | Toast "Ocorreu um erro. Tente novamente." |
| Validação de campo | Destaque vermelho no campo + "Campo obrigatório." |
| Sucesso | Toast verde "Registro salvo com sucesso." |
| Sem permissão | "Você não tem permissão para esta ação." |
| Confirmação | Diálogo "Deseja realmente excluir este registro?" |

---

## Tom de voz e escrita (UX writing)

Do N0: **direto, profissional e institucional** (produto do Sistema Indústria / IEL). Rótulos e mensagens em **português**, title case em títulos, frases curtas. Ações nomeadas por verbo no infinitivo (Salvar, Filtrar, Adicionar). Placeholders orientam ("Buscar por nome…", "Digite o enunciado da questão…"). Confidencialidade e transparência guiam os textos ao participante e ao avaliador.

---

## Instruções para os próximos protótipos

> **Objetivo**: todo protótipo novo deve parecer uma tela do sistema atual. Siga estas regras (consumidas pelos prompts `PROMPT_PROTOTYPE_*` e pela skill `/prototype`).

1. **Linke a biblioteca**: `../…/_biblioteca-ds/ds.css` e use as classes `.dsc-*` — **não invente estilos**. Lacuna → `<!-- TODO: definir no Design System -->`.
2. **Shell padrão**: barra superior teal com "Prêmio IEL" + usuário/avatar; menu horizontal (Dashboard · Administração · Premiação); conteúdo em cards sobre ground `#EFEFEF`. Telas de configuração usam o layout de **duas colunas com a árvore "Estrutura"** à esquerda.
3. **Cores**: primário/confirmação = **teal `#3B8580`**; criar-novo = **verde `#198754`**; contorno de apoio = **roxo `#883CAE`**; links/paginação = **azul `#0D6EFD`**; status por semântica. Nunca use pill em botão — **raio 4px**.
4. **Padrão de página**: título à esquerda + ações à direita; barra de filtros em card; **tabela** com badge de situação, coluna de ações e paginação "Mostrando X a Y de Z registros".
5. **Formulários**: rótulo acima com asterisco vermelho no obrigatório; ajuda inline em `#6C757D`; ação primária (teal) + Cancelar (neutro). Diálogos centralizados com backdrop escuro.
6. **Estados obrigatórios** em toda tela: carregando, vazio, erro e sucesso — com os **textos literais** da tabela acima.
7. **Fidelidade**: registre o protótipo em `prototypes/INDEX.md` (fidelidade lida da `## Superfície` do N3). Telas com fidelidade **obrigatória** são conferidas na implementação por `node scripts/fidelity-checklist.mjs`.
8. **Acessibilidade**: contraste AA (o teal `#3B8580` sobre branco tem contraste suficiente para texto ≥ 16px/negrito; para texto pequeno prefira `#2F6A66`); foco sempre visível; alvos ≥ 40px; navegação por teclado nas tabelas e diálogos.

---

## Mapa de equivalência (protótipo `.dsc-*` → produção PrimeNG)

> Na codificação, as classes de protótipo dão lugar aos componentes reais. A presença de `dsc-` em template de produção denuncia cópia de protótipo (candidato a regra de lint na CI).

| Protótipo (`.dsc-*`) | Produção (Angular + PrimeNG) |
|---|---|
| `.dsc-btn` / `--primary` / `--success` / `--outline` | `p-button` (`severity`, `outlined`) |
| `.dsc-input` / `.dsc-select` / `.dsc-textarea` | `pInputText` · `p-dropdown` · `pInputTextarea` |
| `.dsc-switch` / `.dsc-checkbox` | `p-inputSwitch` · `p-checkbox` |
| `.dsc-table` + paginação | `p-table` (`p-paginator`) |
| `.dsc-badge` | `p-tag` / `p-chip` |
| `.dsc-tabs` | `p-tabView` / `p-tabMenu` |
| `.dsc-modal` | `p-dialog` |
| `.dsc-tree` | `p-tree` |
| barra superior / menu | `p-menubar` |
| toast / confirmação | `p-toast` · `p-confirmDialog` |

---

## Fontes desta especificação

- CSS do tema em produção: `arquivos/html/Prêmio IEL_files/{theme.css, styles.css}` (tokens PrimeNG customizados).
- 30 capturas de tela: `arquivos/prints/` (layout, componentes e cores em contexto).
- Cores conferidas por amostragem de pixel dos prints (topbar `#3B8580`, verde criar `#198754`).

---

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-08-27 | Engenharia reversa (docqui) | Design system criado | Extraído do CSS do tema e das capturas do sistema atual (Angular + PrimeNG, marca teal + roxo de apoio) |

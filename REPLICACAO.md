<!-- docqui: 4.1.0 | prompt: — | atualizado: 2026-10-05 -->
# Registro de mudanças para replicação

> Ledger das mudanças feitas **primeiro aqui** (`premio-iel`) que precisam ser **replicadas depois** nas outras instâncias docqui que usam a mesma solução — `portal-compras` e `transparencia-web`. Cada entrada diz o que mudou, onde e como aplicar no destino; a **matriz de status** mostra o que já foi replicado e o que ainda falta. O fluxo é sempre *fazer tudo aqui → registrar → replicar nos outros → marcar o status* — nunca os três ao mesmo tempo.

---

## Escopo — o que entra e o que não entra

Entra o que é **maquinário compartilhado entre as instâncias**, porque a mudança feita aqui faz sentido nas outras: `scripts/` (validadores, geradores, hooks, `gates.py`), o gerador `scripts/gera-docx.py` e suas regras de exportação, templates e ativos de apoio (`scripts/templates/`, `assets/`), ajustes padrão do visualizador (`index.html`), as skills instaladas em `.claude/skills/` e as convenções do `CLAUDE.md` — além de arquivos operacionais como este próprio ledger.

**Não entra** conteúdo de especificação específico do produto, porque não se replica para outra instância: os N0–N3 em `modules/`, o `global/` preenchido (MASTER, DATA-MODEL, dicionários), `arquivos/demandas/`, `documentos/` e os protótipos de tela do Prêmio IEL descrevem o PIEL e não têm equivalente nas outras.

⚠️ **Exceção vigente sobre o `engine/`.** A regra geral do `CLAUDE.md` é que `engine/` é espelho somente-leitura do `siesa-engine`. Por decisão do usuário em 2026-09-30, mudanças de rota "via engine" passaram a ser aplicadas **direto aqui**, como já se fazia no `portal-compras`. O custo está aceito e registrado: o próximo `sync-instance` a partir de um engine que ainda não tenha essas mudanças **as reverte em silêncio**. Toda entrada nessa condição sai marcada **`via engine — aplicado localmente`**, e a promoção ao canônico continua pendente.

---

## Rotas de replicação

- **Local entre instâncias (manual)** — mudança compartilhada que, por decisão, **não** vai para o engine (ex.: a exportação `.docx`). Replica-se adaptando à mão em cada destino, na mesma família de arquivos.
- **Via engine** — mudança que pertence ao framework: o certo é ir primeiro ao `siesa-engine`, ser mesclada e **conferida na `main` dele**, e só então chegar às instâncias por `node scripts/sync-instance.mjs` (nunca `cp`). Ver `CLAUDE.md` → *"Num conjunto engine + instâncias, o engine sobe primeiro"*.
- **Via engine — aplicado localmente** — a exceção acima: a mudança está em `engine/` **desta cópia** e ainda não no canônico.
- **Não se aplica (➖)** — mudança específica do produto; fica só aqui e não entra na matriz.

---

## Como replicar sem quebrar o destino

As instâncias **divergem** entre si — a mesma seção existe numa com um nome, noutra com outro, numa terceira não existe. Antes de aplicar qualquer entrada no destino: procure o conceito equivalente e **estenda em vez de duplicar**; para artefato do engine use `sync-instance`, não `cp`; e antes de dar por feita a replicação, rode o validador da própria instância de destino e cheque **as duas direções do git**. As lições completas estão no `CLAUDE.md` → *"Replicar padrão entre instâncias"*, *"Ordem do push"* e *"Verificar de verdade"*.

---

## Matriz de status

> Legenda: ⬜ pendente · ✅ replicado · ➖ não se aplica.

| ID | Data | Mudança | Rota | `portal-compras` | `transparencia-web` |
|---|---|---|---|:---:|:---:|
| REP-001 | 2026-10-04 | Geradores de `.docx` leem o título `Major Feature Set:` do N1 e do N2 | Local entre instâncias (manual) | ⬜ | ⬜ |
| REP-002 | 2026-10-05 | `gera-docx.py` no formato 4.1.0 do N3 e jornada sem corte: remissão a regra do N1, Descrição em parágrafos, larguras da tabela de Campos, itálico cru, `viewBox` do diagrama | Local entre instâncias (manual) | ⬜ | ⬜ |

---

## Recebido de outras instâncias

> O que chegou pelo ledger de outra instância. Serve para auditar o estado desta cópia — a entrada canônica continua sendo a do ledger de origem, que não se copia para cá.

### Do `portal-compras` — ledger de 2026-09-23, 56 entradas

Triagem feita em 2026-09-30 conferindo **entrada por entrada contra o estado real deste repositório**, não pela matriz de origem.

| Situação | Entradas |
|---|---|
| ✅ Aplicado | REP-001 (ledger) · REP-023 (`valida-tabelas-md`) · REP-035 e REP-041 (`verifica-texto-corrido`) · REP-042, REP-044 e REP-045 (`valida-citacoes-dicionario`) |
| ⬜ A aplicar | REP-002 a REP-007, REP-009 a REP-022, REP-024, REP-026 a REP-028, REP-030 a REP-034, REP-036 a REP-040, REP-043, REP-046 a REP-050, REP-052 a REP-056 |
| ➖ Não se aplica | REP-008 e REP-025 (modelo de protótipo **composto**, exclusivo do `portal-compras`; aqui o modelo é **por fluxo**) · REP-029 (protótipo não autocontido — os daqui carregam o design system por caminho relativo dentro do repositório) |
| ❓ A conferir | REP-041 e REP-051 — a sonda inicial deu sinal de já estarem presentes, mas era sinal fraco; conferir antes de marcar |

#### Divergências que a replicação encontrou no destino

**Os números de gate colidem.** O `spec-guard.mjs` de origem usa F4 para tabelas, F5 para citações de dicionário, F6 para Sumário de KPI e F7 para Fluxo Principal. Aqui o **F4 já é "checkout atrasado" e o F5 já é "comando destrutivo"** — replicar os números às cegas criaria dois gates com o mesmo nome no mesmo arquivo. Os gates que chegarem de lá entram a partir do **F6** desta cópia, e a correspondência fica registrada aqui: origem F4 → destino F6 · origem F5 → destino F7 · origem F6 → destino F8 · origem F7 → destino F9.

**O `valida-tabelas-md` precisou de duas exceções que a entrada de origem não menciona**, ou acusaria arquivo são. (1) Régua horizontal (`---`) colada à tabela **não** é absorvida — medido no próprio `marked` que o visualizador usa: com `---` colado saem 2 `<tr>` e o texto seguinte fica fora; com um parágrafo colado saem 3 `<tr>` e o parágrafo vira célula. Sem a exceção, 24 arquivos sãos viravam achado, porque fechar seção com `---` logo depois de uma tabela é o formato normal aqui. (2) A divisão em células tem de respeitar o pipe escapado (`\|`), senão o validador acusa exatamente a linha que foi escrita do jeito certo.

**O `valida-citacoes-dicionario` só vale se recusar o índice.** A primeira versão aceitava linha de tabela como entrada em qualquer dicionário, e o `FIELD-DICTIONARY` daqui tem um índice cheio com `## Entradas` quase vazia — as citações "resolviam" contra linhas de índice e o validador saía com 2 órfãs. Aceitando linha de tabela só em ERROR e MESSAGE, onde a chave **é** a entrada, aparecem as **33 órfãs** reais. É a mesma cegueira que a entrada de origem descreve, por outro caminho.

**O que a triagem encontrou**, para quem for auditar: nenhum dos cinco validadores novos existe aqui (`valida-tabelas-md`, `valida-citacoes-dicionario`, `valida-sumario-kpi`, `valida-fluxo-principal`, `valida-acessorio-tela`); **não existe `scripts/spec-guard.mjs`** — só o workflow `.github/workflows/spec-guard.yml` —, de modo que os gates F4–F7 não têm onde entrar; `Prioridade`/`MVP` seguem em **126 de 126** N3; `demandas/` e `global/VOCABULARY-OVERRIDES.md` ainda existem; e a `## Métricas de tamanho` não tem a coluna **Papel**.

⚠️ **Dívida de conteúdo que o `valida-citacoes-dicionario` revelou**: **33 citações órfãs** em 250 conferidas, apontando para 7 alvos que não têm entrada — `URL` (13), `Período de vigência` (6), `Telefone` (6), `Nome de pessoa` (3), `Nome` (2), `CNPJ` (2) e `Slug único público` (1). São pré-existentes e da mesma natureza que a instância de origem encontrou. **O gate correspondente não foi plugado**: enquanto essas entradas não existirem, ele reprovaria a primeira gravação em cada arquivo afetado por um defeito que não é da mudança que o motivou.

### Do `gpe-doc` — ledger de 2026-10-01, 5 entradas

Aplicadas em 2026-10-01 na cópia de trabalho e conferidas no navegador contra o código anterior: 199 documentos e 1.851 títulos `##` da fonte comparados com o texto renderizado. Antes, 7 documentos perdiam conteúdo; depois, nenhum.

| Situação | Entradas |
|---|---|
| ✅ Aplicado | REP-001 (N1 com o título da 3.0.0, no visualizador e no `gera-mapa-features`) · REP-002 (front-matter que engolia seções) · REP-003 (subseção `###` dentro da Descrição do N1) · REP-004 (link de um N1 para outro) · REP-005 (regras coladas ao título, no N3) |

#### Divergência que a replicação encontrou no destino

**O `REP-004` de lá não basta aqui.** Na origem, o link `../outro/README.md` de um N1 deixa de ser reescrito no template e é resolvido pelo pós-processamento do DOM — o `REP-039` do `portal-compras`, que **ainda não chegou a esta cópia**. Só com a troca de lá, o link ficava relativo e tirava o leitor do visualizador. Aqui a seção do N1 passou também pelo `reescreveLinksInternos`, que já existia para o documento genérico; conferido injetando o link em memória e clicando nele, e os 26 links reais dos N1 para os seus Feature Sets seguem válidos.

**Dois dos cinco já perdiam conteúdo aqui**: o `REP-002` (o `global/PATTERNS.md` e o `modules/_base-conhecimento/premio-iel-de-talentos.md`) e o `REP-003` (os 5 N1 sem a subseção *O que este domínio NÃO faz*). Os outros três estavam latentes — nenhum N1 no título novo, nenhum link entre N1, nenhuma lista de regras colada ao título.

---

## Entradas

> Append-only: uma entrada nunca é reescrita para "corrigir" o que a mudança foi — se algo evoluir depois, abre-se **nova** entrada. O que se atualiza é a **matriz** (⬜ → ✅) quando a replicação é feita.

### REP-001 — Geradores de `.docx` leem o título `Major Feature Set:` (2026-10-04)

**O que mudou.** Na regeneração dos artefatos com o engine 4.1.0, o N1 passou a se intitular `# Major Feature Set: <Nome>` e o subtítulo do N2 a dizer `> **Nível 2** - Major Feature Set: <Nome> - \`SIGLA-SFS\``, como mandam o `PROMPT_1A` e o `PROMPT_2A` desde a 3.0.0. Dois geradores só reconheciam o legado `Domínio:` e passariam a sair com o domínio vazio:

- `scripts/gera-docx.py`, função `fs_meta` — o nome do domínio lido do título do N1;
- `scripts/gera-doc-n2.js` — o nome do domínio e o código do Feature Set lidos do subtítulo do N2 (`blocoN2`), e o nome do domínio lido do título do N1.

As três expressões passaram a aceitar `(?:Major Feature Set|Domínio):`, de modo que N1/N2 no formato novo e no legado funcionam. O texto que o documento exibe ("Domínio: …") não mudou.

**Como conferir.** As expressões foram testadas com as duas formas (casam) e com uma terceira (não casa). O `index.html`, o `gera-mapa-features.mjs`, o `gera-planilha-contagem.py`, o `generate-trace-index.mjs` e o `valida-citacoes-dicionario.mjs` já aceitavam as duas formas — não precisaram de mudança.

**Como aplicar no destino.** Procure no destino as expressões que leem `Domínio:` do N1 ou do N2 (`grep -rn "Dom[íi]nio:" scripts/`) e estenda cada uma para `(?:Major Feature Set|Domínio):` — não troque uma pela outra, porque o destino pode ter N1/N2 nos dois formatos. Só é urgente no destino que for regenerar os N1/N2 para o título novo.

### REP-002 — `gera-docx.py` no formato 4.1.0 do N3 e jornada sem corte (2026-10-05)

**O que mudou.** A geração da Especificação Funcional da Sprint 06 foi a primeira depois de os N3 passarem ao formato do engine 4.1.0, e a conferência página a página do `.docx` (convertido em PDF) mostrou cinco defeitos no `scripts/gera-docx.py`. Nenhum é regra de exportação nova — a regra de 2026-09-23 e o leiaute continuam os mesmos —; são o gerador alcançando o formato e um erro de medição antigo:

- **Remissão a regra do N1 não resolvia.** `_regras_do_n1` procurava o N1 por `^# Domínio:`. Com o título `Major Feature Set:`, nenhum N1 casava, e "→ ver N1 <Domínio>: Regras transversais de negócio: N" saía do documento sem a regra original. O REP-001 estendeu `fs_meta` e deixou esta expressão para trás; agora ela também aceita `(?:Major Feature Set|Domínio):`.
- **Descrição do N3 num parágrafo só.** O N3 4.1.0 tem dois parágrafos — a entrega e o "como se usa" —, e o gerador os colava num. Agora sai um parágrafo do Word por parágrafo da fonte, como já acontecia com a Descrição do N2.
- **Tabela de Campos com sete colunas em larguras iguais.** A 4.1.0 acrescentou as colunas Entidade, Preenchimento e Edição; a largura fixa só servia para seis colunas, e as sete caíam em `eq_widths` — o cabeçalho quebrava no meio da palavra ("Preenchimen / to") e o conteúdo também ("desclassificaç / ão"). A função nova `widths_com_piso` dá a cada coluna, no mínimo, o cabeçalho em negrito e a palavra mais longa do conteúdo, e reparte o que sobra pelo tamanho do conteúdo. A largura fixa das tabelas de seis colunas não mudou.
- **Itálico de um asterisco saía cru.** O `clean_md` tirava `**` e crases, não `*…*`: toda nota `⚠️ *(…)*` aparecia com os asteriscos no documento. Agora sai o marcador, inclusive aninhado (`*(ver *Seção*)*`, desfeito de dentro para fora); multiplicação com espaços (`2 * 3`) e `a*b*c` ficam como estão.
- **Diagrama da jornada cortado, com barra de rolagem.** `render_jornada` media o diagrama pelo primeiro `viewBox="0 0 W H"` do DOM. Quando uma aresta contorna o fluxo pela esquerda, o `<svg>` raiz do mermaid vem com origem negativa (`viewBox="-35 0 W H"`), e a expressão casava o `<marker>` de seta (10×10): a janela saía quadrada e a foto cortava o diagrama. Agora a medida é a do `<svg>` raiz, com qualquer origem.

**Como conferir.** Cada defeito foi reproduzido antes da correção e conferido depois: a remissão do N1 resolvida contra `Configuração da Premiação` (antes, nenhum N1 casava); o `clean_md` com nota aninhada, com `2 * 3 * 4` e com `a*b*c`; as larguras nas tabelas de Campos dos seis Feature Sets da SP06 (nenhuma precisou encolher o piso); e a jornada de `INS-ACO` re-renderizada de 2400×2416 cortada para 2400×2866 inteira — as outras cinco saíram idênticas à medida anterior, o que confirma que só o caso de origem negativa mudou. Regerar sem navegador (`GERA_DOCX_NO_BROWSER=1`, como a CI) não altera um byte.

**Como aplicar no destino.** As três cópias do gerador divergem (ver `documentos/README.md` → *Escopo e manutenção*); aplique cada item procurando a função equivalente, não por `cp`. `_regras_do_n1` e `render_jornada` devem existir nos três, porque a remissão (regra de 2026-09-23) e a jornada renderizada são comuns às três cópias — não conferido daqui, confira no destino; a tabela de Campos e a Descrição do N3 só importam no destino cujos N3 já estão no formato 4.1.0 — confira o cabeçalho da `## Campos` antes. Para provar a correção da jornada no destino, procure um N2 cujo diagrama tenha aresta contornando o fluxo pela esquerda: é o caso que o defeito corta.

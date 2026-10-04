# CLAUDE.md
> **Índice de contexto da instância.** Copie este arquivo para a **raiz do
> repositório de documentação** do seu projeto (a instância — não para dentro de
> `engine/`). O Claude Code o lê automaticamente no início de **toda** sessão, de
> modo que o agente sempre carrega o contexto do projeto sem precisar colá-lo.
>
> Mantenha-o **enxuto**: ele é um índice, não uma cópia. Os arquivos pesados
> (dicionários, data-models, árvore de `modules/`) são lidos **sob demanda** pela
> skill `analista-requisitos` — não os importe todos aqui para não inflar o contexto.

---

## Identificação do projeto

- **Sigla**: [sigla do sistema — 5 letras maiúsculas, ex.: SIGEF]
- **Nome**: [nome do sistema por extenso]
- **Descrição**: [descrição em uma frase]
- **Repositório de docs**: [nome-docs] (este repositório — a instância)

Este repositório é uma **instância do framework `docqui`**: contém a
documentação específica deste sistema (N0–N3, dicionários, data-models) e consome
os prompts/templates do `siesa-engine` mais a skill `analista-requisitos`.

---

## Contexto sempre carregado

Os arquivos abaixo entram no contexto automaticamente a cada sessão (sintaxe de
import do Claude Code). Ajuste a lista ao que existir na instância:

@global/MASTER.md
@global/N0_PRODUCT_VISION.md
@modules/INDEX.md

> Os demais arquivos de contexto — `global/DATA-MODEL.md`, `global/data-models/`,
> os dicionários (`FIELD`/`RULES`/`MESSAGE`/`ERROR`), `global/NFR.md` e os N1/N2/N3
> em `modules/` — **não** são importados aqui: a skill os lê do disco sob demanda,
> conforme a etapa da sessão.

---

## Regras da instância

- A documentação gerada vai sempre para `modules/`, `global/`, `prototypes/`,
  `qa/`, `repos/` — **nunca** para dentro de `engine/` (somente-leitura).
- **Sempre que a sessão envolver especificação de requisitos** — N0/N1/N2/N3,
  feature, feature set, domínio, CRUD, wizard, campos/regras de negócio, cenários
  Gherkin, dicionários, ou qualquer `PROMPT_*` de especificação — **acione a skill
  `analista-requisitos` antes de responder** e siga o roteiro do prompt
  correspondente em `engine/prompts/`. Não conduza a especificação "na mão".
  > Reforço necessário em modelos menores (ex.: Haiku), que acionam skills por
  > descrição de forma menos agressiva. Se mesmo assim a skill não aparecer ao
  > digitar `/`, ela não foi instalada nesta instância — rode o
  > `scripts/install-skill.sh` do `siesa-engine`.
- **Na abertura de qualquer sessão de especificação**, apresente primeiro os
  **domínios e Feature Sets já existentes** (do `modules/INDEX.md`) — sempre, qualquer
  que seja o ponto de partida — para situar a nova especificação e evitar duplicar ou
  colocar algo no domínio/Feature Set errado.
- **Ao gerar ou atualizar qualquer artefato**, carimbe-o: a primeira linha deve ser
  o comentário invisível `<!-- docqui: <versão de VERSION> | prompt:
  <PROMPT_ID> | atualizado: <YYYY-MM-DD> -->`. Em updates, reescreva o carimbo (não
  duplique). É invisível ao leitor do documento; serve para auditar com que versão do
  framework o artefato foi produzido. Ver `engine/VERSIONING.md`.
- **Markdown — texto corrido.** Ao criar ou editar qualquer `.md`, cada parágrafo de
  prosa é **uma única linha contínua** — nunca quebre linha no meio de frase/parágrafo
  ("hard wrap"). Quebras de linha só separam parágrafos, itens de lista, cabeçalhos,
  linhas de tabela e blocos de código. Conferência:
  `node scripts/verifica-texto-corrido.mjs [arquivo|pasta]`.
- **Exportação para `.docx`** (Especificação Funcional entregue à CNI, uma por Feature Set): as regras valem para as três instâncias que fazem essa entrega e estão indexadas em `documentos/README.md` → *Regras de exportação*. Regra nova entra lá **e** no gerador `scripts/gera-docx.py`, e é propagada aos três repositórios na mesma sessão. Em vigor: estados `loading`, `empty` e `error` do protótipo não vão para o documento.
- **Mudança compartilhada entra no ledger.** Alteração em maquinário que as outras instâncias docqui também usam — `scripts/`, `index.html`, `.claude/skills/`, templates, convenções do `CLAUDE.md` — é registrada em `REPLICACAO.md` na raiz, com o que mudou, onde e como aplicar no destino. O fluxo é **fazer tudo aqui → registrar → replicar nos outros → marcar o status**, nunca os três ao mesmo tempo. O ledger é **append-only**: entrada não se reescreve para corrigir o que a mudança foi; se algo evoluir, abre-se entrada nova. Conteúdo de especificação do produto (N0–N3, `global/` preenchido, protótipos) **não** entra — não se replica para outra instância.
- [Demais convenções específicas deste projeto que valham para toda sessão.]

## Feature sempre com ID e nome

Ao citar uma feature **no chat**, escreva `ID — Nome da feature` — nunca o ID sozinho, e em **todas as seções**, não só na primeira menção. `TEM-ASO-03` não diz nada a quem lê; `TEM-ASO-03 — Exportar Atendimento Social` diz. Vale para linha de tabela, item de lista, prosa corrida e resumo. Nos documentos de análise de impacto a regra é a da skill `analise-impacto`.

## Verificar de verdade

**Verificação que não distingue "passou" de "não rodou" não é verificação.** Uma checagem que devolve *nenhum problema* só vale como evidência depois que você prova que ela dispara: injete um caso que **deve** falhar e confirme que ela acusa. Vale para validador novo, filtro de busca, teste de regressão e varredura de auditoria — zero achados é o mesmo resultado de uma checagem quebrada.

**Se o alvo tem formatos diferentes entre repositórios, injete em cada um.** Provar que a checagem dispara num repo não prova nada sobre os outros. O FD-12 nasceu mudo no `simpf-doc` porque o data-model de lá usa `## Entidade: \`X\`` e o dos demais usa `## X` — e o zero passava por "nada a apontar".

**Conferência visual não substitui o validador que o repositório já tem.** Ver a tela funcionando prova que a tela funciona, e nada além disso. Antes de dar por feita uma migração ou uma mudança em lote, rode o validador da própria instância (`audit-trace-links`, `validate-doc`, `verifica-texto-corrido`) e **compare com o baseline de antes** — é o que separa "121 inconsistências pré-existentes" de "121 que eu causei". Numa migração conferida só pelo navegador, cinco scripts continuaram apontando para o caminho antigo por três rodadas.

**Contar não é medir: confira a unidade antes de concluir do número.** `grep -c` conta **linhas** que casam, não ocorrências — num arquivo minificado (HTML gerado, `tree.js`, JSON numa linha só) 21 links viram `1`, e o número errado tem a mesma cara do certo. Para ocorrências, `grep -o … | wc -l`. A regra vale para qualquer contagem que vire evidência: pergunte que unidade o comando conta, e se é a que você quer. Um índice de 21 links lido como 1 quase virou caça a um bug que não existia.

**Um check que manda inspecionar não autoriza agir.** Sinal que diz "difere — inspecionar" é convite a olhar, não permissão para apagar. Confirme o sinal antes de agir sobre ele, e desconfie primeiro do próprio check: caminho relativo depois de um `cd` aponta para outro lugar e devolve falso positivo com cara de achado.

## Mudança em lote não reescreve histórico

Em mudanças mecânicas em lote (script sobre muitos artefatos):
- A seção `## Changelog` dos artefatos é **histórico** — nunca reescreva o que já está lá. Acrescente uma linha nova descrevendo a mudança; se o texto antigo virou impreciso, o registro certo é a linha nova, não a edição da antiga.
- Rode em modo seco primeiro e confira o diff de uma amostra antes de aplicar.

## Simular um estado não pode custar trabalho real

**`git reset --hard`, `checkout --` e `rm` apagam o que ainda não foi commitado — inclusive o que você mesmo acabou de escrever.** Para testar um guard, reproduzir um bug ou provar que uma checagem dispara, é tentador sujar o repositório em que você está. Commite ou dê `stash` **antes**; melhor ainda, simule num repositório onde você não tem trabalho pendente. E, depois do teste, confirme **por conteúdo** que o que você estava fazendo continua lá — não pelo `git status`, que fica limpo justamente porque a edição sumiu. Uma regra de `CLAUDE.md` escrita e não commitada foi destruída por um `reset --hard` usado para testar o próprio guard que a acompanhava; só apareceu na conferência final.

## Ordem do push

Trabalhando em vários repositórios, `git fetch origin main && git merge origin/main` vem **antes** de empurrar qualquer ref — branch ou `main`. Empurrar a branch primeiro e mesclar depois deixa a branch atrás do que acabou de subir, e o desencontro só aparece na sessão seguinte.

**O merge só conta depois de conferido na `main`.** O retorno do merge diz que o PR foi mesclado, não que o seu último commit entrou: um PR pode ser mesclado num head anterior ao seu último push. Depois de mesclar, confira — `git rev-list --count origin/main..origin/<branch>` tem de dar **zero** — e confirme o que importa **por conteúdo** na `main`, não pelo log. Seis merges seguidos já deixaram de 3 a 4 commits para trás em cada repositório sem que nada acusasse.

**`main..HEAD` responde o que falta subir, não se você está em dia.** São duas perguntas opostas: `git rev-list --count origin/main..HEAD` conta o que você tem a mais; `HEAD..origin/main` conta o que a `main` tem que você não viu. Ler o primeiro zero como "em dia" é ler metade. **Faça `git fetch` e cheque as duas direções antes de concluir qualquer coisa sobre o conteúdo do repositório** — e obrigatoriamente antes de apagar algo ou de relatar que algo está ausente, órfão ou sem uso. Num checkout 5 commits atrasado, um `.docx` de Feature Set criado naquele mesmo dia foi relatado como órfão e quase apagado; o `git rm` só falhou porque o arquivo nem existia ali. Trabalho de outra sessão some sem deixar rastro por esse caminho.

**Num conjunto engine + instâncias, o engine sobe primeiro.** Sincronizar uma instância a partir de um engine cujo conserto ainda não está na `main` dele **reverte** o conserto na instância, em silêncio. A ordem é: engine mesclado e conferido na `main` → só então `sync-instance` nas instâncias.

## Replicar padrão entre instâncias

As instâncias divergem entre si: a mesma seção de menu existe numa com um nome, noutra com outro, e numa terceira não existe. **Antes de replicar, procure o conceito equivalente no destino e estenda em vez de duplicar** — replicar às cegas cria identificadores repetidos e quebra a página. Já aconteceu duas vezes na mesma sessão, uma delas com a colisão chegando pela `main`.

**O que se replica fica registrado, não na memória de quem fez.** Três instâncias compartilham o mesmo maquinário e divergem no conteúdo; sem um ledger, o que foi feito numa some para as outras — e some para você mesmo, três semanas depois. O `REPLICACAO.md` da raiz é esse registro: cada instância mantém **o seu próprio**, só o mecanismo viaja, e nenhuma entrada de conteúdo de uma vai para o ledger da outra. Antes de replicar, confira o destino **entrada por entrada contra o estado real dele** — a matriz de origem diz o que o autor sabia na época, não o que existe hoje do outro lado.

**Para artefato do engine, use `scripts/sync-instance.mjs`, não `cp`.** O script separa o drift por direção e recusa sobrescrever o que a instância tem **à frente** do canônico; o `cp` não sabe disso e reverte em silêncio. Uma cópia manual da skill quase apagou um parágrafo que a instância tinha e o engine ainda não.

## A contagem nasce no N3

Contagem de Pontos de Função se faz **na feature** — seção `## Métricas de tamanho` do N3, com a `### Memória de cálculo` que a sustenta — e no `DATA-MODEL.md` para as funções de dados. Só depois é consolidada em `global/CONTAGEM-PF.md` e propagada para `modules/INDEX.md`. O consolidado espelha a fonte; nunca recebe número que não exista nela, e nenhum relatório antecede o N3. Conferência: `node scripts/valida-contagem-consolidada.mjs`. Para entregar a contagem à equipe de métrica, gere a planilha **sob demanda**: `python3 scripts/gera-planilha-contagem.py` (um processo elementar por linha; a planilha é saída, não fonte).

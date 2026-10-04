# Central de Documentos

Esta pasta guarda as **Especificações Funcionais em `.docx`** (uma por Feature Set) e a página **`index.html`** que as lista para download no GitHub Pages, junto com as pendências de especificação. É o alvo do item **"Docs (.docx)"** da barra lateral do visualizador.

> **Não edite os arquivos desta pasta à mão** — `*.docx`, `index.html`, `_diagramas/*.png` e `_prototipos/**/*.png` são **gerados**. Ajustes de conteúdo se fazem nos N2/N3 em `modules/`; ajustes de layout, no gerador `scripts/gera-docx.py` e no template `scripts/templates/especificacao-funcional.docx`. O único arquivo editado à mão aqui é `ESCOPO.txt`, que declara quais Feature Sets a central entrega.

## Como (re)gerar

A partir da raiz do repositório:

```bash
python3 scripts/gera-docx.py --all                        # os feature sets de ESCOPO.txt (todos, sem o arquivo)
python3 scripts/gera-docx.py modules/avaliacao/apuracao-devolutiva   # um feature set específico
```

O gerador lê o N2 e os `f-*.md` da pasta, preenche o template PHL e grava `documentos/<NomeDoFeatureSet>.docx`; ao final, regenera esta `index.html` (lista dos `.docx` + pendências de `modules/INDEX.md`).

## Diagrama da Jornada e telas do protótipo

A imagem da "Jornada do Usuário" é o bloco ```mermaid``` do N2 renderizado, com **cache** em `_diagramas/<SIGLA>.png`; as telas do protótipo navegável do Feature Set (`prototypes/<domínio>/<feature-set>/flow*.html`) são fotografadas e guardadas em `_prototipos/<feature-set>/`. O gerador reaproveita o cache quando existe; só precisa de um **Chromium/Chrome no PATH** para renderizar uma figura **nova**. Sem navegador e sem cache, a jornada sai como lista textual dos passos e a tela some do documento — o gerador avisa. Para forçar novo render, apague o PNG e rode o gerador com um navegador disponível.

## Automação (CI)

O workflow **`.github/workflows/gera-docx.yml`** regenera esta pasta (e o índice do site, `assets/tree.js`) a cada push na `main` que toque a documentação, o gerador ou o template, e **commita apenas se algo mudou** (a saída é determinística — regerar sem mudança de spec não gera commit). No runner ele usa o cache de figuras (`GERA_DOCX_NO_BROWSER=1`), sem navegador. Também dá para rodar manualmente em **Actions → Run workflow**.

## Regras de exportação

> Índice das regras da exportação para `.docx`, comuns às três instâncias que fazem esta entrega — `portal-compras`, `premio-iel` e `transparencia-web`. É a base da futura skill de exportação: **toda regra nova entra aqui e é propagada aos três repositórios na mesma sessão**, junto com o ajuste no gerador. O texto desta seção é o mesmo nos três; o que difere entre eles está marcado.

### Propósito

O processo da CNI exige entregar, para cada funcionalidade desenvolvida ou evoluída, uma **Especificação Funcional em `.docx`** no modelo do cliente. O documento é **derivado** da especificação: nasce dos N2/N3 em `modules/` e do template `scripts/templates/especificacao-funcional.docx`, e nunca se corrige à mão — conteúdo se ajusta na spec, leiaute no gerador ou no template.

### Unidade, nome e recorte

- **Um `.docx` por Feature Set** (o N2 mais os seus N3). Não há documento por feature nem por domínio.
- **Nome do arquivo** = nome do N2 em TitleCase, sem a sigla (`ApuracaoEDevolutiva.docx`, não `AVL-APU.docx`): é o nome que a planilha de contagem usa, e quem recebe não precisa consultar a tabela de siglas.
- **Recorte**: `documentos/ESCOPO.txt` (uma sigla de Feature Set por linha, `#` comenta) limita o `--all` ao subconjunto entregue; sem o arquivo, saem todos. Existe porque a CI regenera tudo a cada push e desfazia em silêncio a decisão de entregar só parte. *Hoje só o `premio-iel` tem o recorte no gerador* ⚠️ convergir.
- **Sigla do sistema** no cabeçalho: vem da variável de ambiente ou do `**Sigla**` do `global/MASTER.md`; sem sigla o gerador **aborta** — documento com a sigla errada é pior que documento não gerado. Nome do sistema: `assets/js/config.js`.

### Estrutura do documento

Capa do template; à direita, sigla do sistema, "Especificação Funcional" e `Nome do Feature Set (SFS)`. **Histórico de Versões** derivado do `## Changelog` do N2 (versões `1.n` geradas, da mais recente para a mais antiga). A coluna **Autor** do histórico é fixa, `PHL TI` *(regra de 2026-09-03)*: o changelog do N2 diz quem editou a spec, e isso é rastreabilidade interna; o documento entregue sai em nome da PHL TI. Depois, em nova página: **1.** nome e `## Descrição` do N2 · **2.** Funcionalidades (tabela nome/descrição da `## Features`) · **3.** Jornada do Usuário · **4.** Permissões (uma tabela por tabela de `## Permissões por perfil`, largura por conteúdo). Em seguida, **cada funcionalidade em nova página**, com numeração reiniciada: Descrição · Regras de Negócio (lista numerada em tabela, notas em itálico) · Cenários · Telas e Protótipos · Campos (tabela `## Campos`) · Campos Automáticos (`## Campos automáticos`, ou "Não se aplica").

**Regra citada por remissão sai como a regra original** *(regra de 2026-09-23)*. Um N3 que escreve "→ ver N1 <Domínio>: Regras transversais de negócio: N" ou "→ ver <ID> <Feature>: Regras de negócio: N" costuma trazer só um resumo da regra; quem lê a spec chega à original pelo link, quem lê o `.docx` não. O gerador troca o resumo pelo texto da regra citada (lido do `## Regras transversais de negócio` do N1 ou do `## Regras de negócio` do N3 alvo, pelo `id:` do frontmatter) e a remissão some do documento — nem "ver N1…", nem número de regra de outro artefato. Intervalo ("6 a 9") vira as regras citadas em sequência; o que vem depois da remissão (uma nota ⚠️) é preservado; regra citada que cita outra é resolvida em cadeia. Alvo inexistente: fica o texto do N3 sem a remissão e o console avisa. As demais remissões (`FIELD-DICTIONARY`, `RULES-DICTIONARY`, `MESSAGE-DICTIONARY`, `DATA-MODEL`) seguem como estão ⚠️ decidir se também viram texto.

### Jornada do Usuário

- É o bloco ```` ```mermaid ```` do N2 renderizado por Chromium headless, com **cache** em `documentos/_diagramas/<SIGLA-FS>.png`. Com cache, o navegador não é necessário; sem cache e sem navegador, a jornada sai como lista textual dos passos.
- *No `premio-iel`* a jornada ocupa uma página própria, inteira (6,6" × até 9,2"): partida em pedaços perde as setas que cruzam o corte. *Nos outros dois* fica no fluxo do texto, limitada a 7,4" de altura ⚠️ convergir.

### Telas e protótipos

O vínculo tela ↔ funcionalidade segue a convenção de protótipo de cada instância — são **três modelos**, e a skill precisa reconhecer os três:

- **Um HTML por estado** (`transparencia-web`: `prototypes/<domínio>/<feature-set>/<f-feature>/<estado>.html`). O gerador lê os elos `[abrir … ↗](prototypes/…/<estado>.html)` que o **próprio N3** carrega — na `## Superfície` e na tabela de estados de tela —, na ordem em que aparecem, uma figura por elo, com legenda (dicionário `LEGENDAS` do gerador para os estados que pedem explicação; legenda genérica para os demais; legenda própria para `arquivo*.html`, o exemplo do arquivo exportado). Cache em `documentos/_diagramas/proto-<ID>-<estado>.png`, **nomeado pelo estado, não pela posição** — nomeado pela posição, tirar ou inserir um elo fazia a CI servir a foto de um estado no lugar de outro.
- **Um fluxo navegável por Feature Set** (`premio-iel`: `prototypes/<domínio>/<feature-set>/flow*.html`). As telas são os botões da barra `.proto-bar` **antes do primeiro** separador `.sepv` (depois dele são perfil e estado, que não viram figura); `data-feature="ID …"` diz em que funcionalidade(s) a tela entra — tela sem o atributo cai no capítulo "Telas e Protótipos" do Feature Set, como não atribuída; `data-doc="nao"` tira a tela do documento (stub de navegação). A foto se tira **clicando o botão**, não chamando a função de troca de tela, porque alguns botões abrem modal ou preparam estado. Cache em `documentos/_prototipos/<feature-set>/NN-<slug>.png`; tela alta é **fatiada** em páginas (`-pN.png`, exige Pillow); tela que serve a várias funcionalidades aparece em todas, mas a tabela de campos só na primeira.
- **Um HTML composto por Feature Set** (`portal-compras`: `prototypes/<domínio>/<feature-set>/<composição>.html`), com as telas trocadas por JS num único arquivo. Um manifesto invisível `<script type="application/json" id="docx-telas">` no protótipo lista cada tela — `nome`, `features` (IDs de N3 a que pertence) e `setup` (o JS que a exibe antes da captura). O gerador lê o protótipo referenciado na `## Superfície` do N3 (`Fidelidade ao protótipo … prototypes/…html`), captura cada tela cujo `features` casa com a funcionalidade — escondendo o andaime `.req-toggle`, medindo a altura do conteúdo e capturando a 1280px de largura — e a coloca no capítulo "Telas e Protótipos" daquela funcionalidade, com o `nome` como legenda. Sem manifesto, captura a tela de entrada. Cache em `documentos/_prototipos/<SIGLA-FS>/<ID>-<slug>.png`, nomeado pela feature e pela tela. **Fonte**: o Chromium headless não usa o proxy do ambiente nem confia na CA dele, então o `@import` remoto do Google Fonts falha e a tela cairia no fallback; a captura injeta a **Inter vendorizada** em `assets/vendor/inter/` (latin + latin-ext, pesos 400/500/700) e neutraliza o `@import` remoto — a tela sai com a fonte real, offline e determinística. *Em vigor desde 2026-09-03; antes o `portal-compras` só levava a jornada ("Sem protótipo de tela" fixo).*
- **A figura mostra o artefato, não o andaime**: painel de notas, barra do protótipo, selo de conformidade, botão flutuante e qualquer elemento `position:fixed` ficam fora da foto; a medida da altura para no fim do conteúdo, para não sair faixa branca.
- **Estados `loading`, `empty` e `error` não vão para o `.docx`** *(regra de 2026-09-03)*. Vale para as variantes em português (`carregando`, `vazio`/`vazia`, `erro`) e para o estado de um componente da tela (`combos-ano-vazio`). Aplica-se pelo **nome do arquivo** no modelo por estado e pelo **título do botão** no modelo por fluxo, casando palavra inteira (`erro` casa "Erro de servidor", não "Erros de crítica", que é conteúdo de negócio). O helper `estado_fora_do_docx()` é idêntico nos três geradores. O que vai: a tela de entrada e os estados que mostram conteúdo ou operação — `form`, `conteudo`, `sucesso`, `modal`, `invalid`, `janela-expirada`…
- **Tamanho**: largura útil 6,2" (`transparencia-web`) / 6,4" (`premio-iel`) ⚠️ convergir; altura máxima por figura; captura em escala 1 (1280 px, ~200 DPI no documento) porque o cache é versionado e em escala 2 os PNG triplicavam.

### Geração, cache e CI

- `python3 scripts/gera-docx.py --all` ou `python3 scripts/gera-docx.py modules/<domínio>/<feature-set>`; ao final regenera `documentos/index.html` (lista dos `.docx` + pendências do `modules/INDEX.md`).
- **Saída determinística**: o zip leva datas fixas; regerar sem mudança de spec não altera um byte, e é isso que permite à CI commitar só quando há diferença. Ao mexer no gerador, confira com `git status` que só mudou o que devia.
- **CI** (`.github/workflows/gera-docx.yml`): roda na `main` a cada push em `modules/**`, no gerador ou no template, com `GERA_DOCX_NO_BROWSER=1` — reusa o cache; **figura nova exige render local com Chromium e commit do PNG**; sem cache e sem navegador a tela some do documento (o gerador avisa). Commita apenas `documentos/**` com `[skip ci]`. *No `premio-iel`* o mesmo workflow também regenera `assets/tree.js` ⚠️.
- **Integridade do pacote**: `python3 scripts/valida-docx.py` confere referência → relacionamento → arquivo e ids únicos de figura — um rId errado faz o Word recusar o arquivo, e a geração não acusa. *Só existe no `transparencia-web`* ⚠️ propagar.
- `documentos/` é pasta gerada: não editar `.docx`, `index.html`, `_diagramas/` nem `_prototipos/` à mão.

### Escopo e manutenção

- A exportação é **local às três instâncias** e **não vai para o `siesa-engine`**: o engine distribuiria o script e o template PHL para instâncias que não fazem essa entrega (decisão de 2026-09-02).
- As três cópias de `scripts/gera-docx.py` deveriam ser idênticas e hoje divergem (o `premio-iel` carrega o modelo por fluxo, o `transparencia-web` o modelo por estado, o `portal-compras` o modelo composto por manifesto de telas). A convergência num gerador único, que escolha o modelo pela convenção da instância, é a primeira entrega da skill. O modelo composto está descrito neste índice nos três repositórios; o código da captura por manifesto (e a Inter vendorizada) é do `portal-compras`, e entra nos outros dois quando o gerador único for montado.
- **Pendências para a skill**: gerador único · `ESCOPO.txt` nos três · `valida-docx.py` nos três · fatiamento de tela alta em páginas no `portal-compras` (hoje escala para caber em uma; exige Pillow) · larguras e enquadramento da jornada iguais · `scripts/gera-exemplo-exportacao.py` (`transparencia-web`) como o padrão para o exemplo do arquivo que uma exportação entrega.

### Histórico das regras

| Data | Regra |
|---|---|
| 2026-09-02 | Exportação local às três instâncias; não promover ao engine. Recorte por `ESCOPO.txt` (`premio-iel`). Telas do fluxo por `data-feature` (`premio-iel`); uma figura por elo do N3 (`transparencia-web`). |
| 2026-09-03 | Estados `loading`, `empty` e `error` (e variantes) ficam fora do `.docx`. Cache do protótipo nomeado pelo estado (`transparencia-web`). Autor do Histórico de Versões fixo em `PHL TI`. Este índice criado nos três repositórios. |
| 2026-09-03 | `portal-compras` passa a levar as telas do protótipo ao `.docx`: modelo de HTML composto por Feature Set com manifesto `<script id="docx-telas">` (tela → funcionalidade → `setup` JS), captura por Chromium com a Inter vendorizada (`assets/vendor/inter`). Modelo registrado neste índice nos três repositórios; o código da captura segue no `portal-compras` até o gerador único. |
| 2026-09-23 | Regra citada por remissão ("→ ver N1 …: Regras transversais de negócio: N" e "→ ver <ID> …: Regras de negócio: N") sai no `.docx` como a regra original, sem a remissão. Mecanismo idêntico nos três geradores (`regra_original()`). |
